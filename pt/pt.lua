local M = {};

---@alias tags { [string]: string | nil }
---@alias mode 'ferry' | 'subway' | 'tram' | 'monorail' | 'funicular' | 'trolleybus' | 'aerialway' | 'bus' | 'sbahn' | 'fbahn'
---@alias station_type 'mainstation' | 'station' | 'halt' | 'tram_stop' | 'bus_station' | 'aerialway_station' | 'bus_stop'
---@alias station_prio number

local pt_nodes = osm2pgsql.define_node_table('pt_nodes', {
    { column = 'geom', type = 'point', projection = 3857 },
    { column = 'type', type = 'text' },
    { column = 'prio', type = 'int2' },
    { column = 'name', type = 'text' },
    { column = 'shortname', type = 'text' }
})

local pt_areas = osm2pgsql.define_area_table('pt_areas', {
    { column = 'geom', type = 'multipolygon', projection = 3857 },
    { column = 'type', type = 'text' },
    { column = 'prio', type = 'int2' },
    { column = 'name', type = 'text' },
    { column = 'shortname', type = 'text' }
})

local pt_lines = osm2pgsql.define_way_table('pt_lines', {
    { column = 'geom', type = 'linestring', projection = 3857 },
    { column = 'mode', type = 'text' },
    { column = 'state', type = 'text' },
    { column = 'ref', type = 'text' },
    { column = 'name', type = 'text' }
})

-- Storing base geometries and tags of ways to be resolved by SQL later
local pt_route_ways = osm2pgsql.define_way_table('pt_route_ways', {
    { column = 'id', type = 'int8' },
    { column = 'geom', type = 'linestring', projection = 3857 },
    { column = 'tags', type = 'jsonb' }
})

-- Storing route relations and a JSONB array of their members
local pt_route_relations = osm2pgsql.define_relation_table('pt_route_relations', {
    { column = 'id', type = 'int8' },
    { column = 'mode', type = 'text' },
    { column = 'state', type = 'text' },
    { column = 'ref', type = 'text' },
    { column = 'name', type = 'text' },
    { column = 'members', type = 'jsonb' }
})

---@param tags tags
---@return mode | nil
local function get_line_mode(tags)
    local route, line, ref = tags.route or '', tags.line or '', tags.ref or ''
    if route == 'ferry' or line == 'ferry' then return 'ferry' end
    if route == 'subway' or line == 'subway' then return 'subway' end
    if route == 'tram' or line == 'tram' then return 'tram' end
    if route == 'monorail' then return 'monorail' end
    if route == 'funicular' then return 'funicular' end
    if route == 'trolleybus' then return 'trolleybus' end
    if route == 'aerialway' then return 'aerialway' end
    if route == 'bus' or line == 'bus' then return 'bus' end

    local is_rail = (route == 'train' or route == 'railway' or line == 'rail')
    local is_light_rail = (route == 'light_rail' or line == 'light_rail')
    if is_light_rail or (is_rail and ref:match('^S') ~= nil) then return 'sbahn'
    elseif is_rail then return 'fbahn' end
end

---@param tags tags
---@return station_type, station_prio, string, string
---@overload fun(tags: tags): nil
local function get_station_info(tags)
    if tags.disused == 'yes' then return nil end
    local name = tags.name or ''
    local is_main = name:match(' Hbf$') or name:match(' HB$') or name:match(' Hauptbahnhof$') or name == 'Wien Westbahnhof'

    local type, prio
    if tags.railway == 'station' and is_main then type, prio = 'mainstation', 1
    elseif tags.railway == 'station' or (tags.public_transport == 'stop_area' and tags.train == 'yes') then type, prio = 'station', 2
    elseif tags.railway == 'halt' then type, prio = 'halt', 3
    elseif tags.railway == 'tram_stop' then type, prio = 'tram_stop', 4
    elseif tags.amenity == 'bus_station' then type, prio = 'bus_station', 5
    elseif tags.aerialway == 'station' then type, prio = 'aerialway_station', 6
    elseif (tags.public_transport == 'platform' and tags.bus == 'yes') or tags.highway == 'bus_stop' then type, prio = 'bus_stop', 7
    else return nil end

    local shortname = name
    if type == 'mainstation' then
        shortname = shortname:gsub(' Hauptbahnhof$', ''):gsub(' Hbf$', ''):gsub(' HB$', ''):gsub(' Westbahnhof$', '')
        local lower = name:lower()
        if lower:match('^s ') or lower:match('^u ') or lower:match('^s+') or name:match('^Fürth ') then
            type, prio = 'station', 2
            shortname = name
        end
    end
    return type, prio, name, shortname
end

function M.process_node(object)
    local type, prio, name, shortname = get_station_info(object.tags)
    if type then
        pt_nodes:insert({ geom = object:as_point(), type = type, prio = prio, name = name, shortname = shortname })
    end
end

function M.process_way(object)
    if object.tags.railway == 'platform' then return end

    -- 1. Process explicit areas (Stations)
    if object.is_closed then
        local type, prio, name, shortname = get_station_info(object.tags)
        if type then
            pt_areas:insert({ geom = object:as_polygon(), type = type, prio = prio, name = name, shortname = shortname })
        end
    end

    -- 2. Process explicit independent lines
    local mode = get_line_mode(object.tags)
    if mode then
        pt_lines:insert({ geom = object:as_linestring(), mode = mode, state = object.tags.state, ref = object.tags.ref, name = object.tags.name })
    end

    -- 3. Store geometries for member resolution in SQL (only in stage 2 processing, which is called only for ways that we explicitly marked in select_relation_members).
    if osm2pgsql.stage == 2 and object.tags.railway ~= 'platform' then
        pt_route_ways:insert({ id = object.id, geom = object:as_linestring(), tags = object.tags })
    end
end

function M.process_relation(object)
    -- 1. Multipolygon handling for Station Areas
    if object.tags.type == 'multipolygon' or object.tags.type == 'boundary' then
        local type, prio, name, shortname = get_station_info(object.tags)
        if type then
            pt_areas:insert({ geom = object:as_multipolygon(), type = type, prio = prio, name = name, shortname = shortname })
        end
    end

    -- 2. Route Relations
    if object.tags.type == 'route' then
        local mode = get_line_mode(object.tags)
        if mode then
            local members = {}
            for _, member in ipairs(object.members) do
                table.insert(members, { type = member.type, ref = member.ref, role = member.role })
            end
            pt_route_relations:insert({
                id = object.id,
                mode = mode,
                state = object.tags.state,
                ref = object.tags.ref,
                name = object.tags.name,
                members = members
            })
        end
    end
end

function M.select_relation_members(relation)
    if relation.tags.type == 'route' then
        local mode = get_line_mode(relation.tags)
        if mode then
            return {
                ways = osm2pgsql.way_member_ids(relation)
            }
        end
    end
end

return M