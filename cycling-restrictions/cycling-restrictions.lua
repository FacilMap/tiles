local M = {}

---@alias access 'restricted' | 'motorway' | 'motorroad' | 'sidepath' | 'pedestrian' | 'optional'
---@alias direction 'forward' | 'backward'
---@alias tags { [string]: string | nil }

local maxzoom = 20

local cycling_restrictions_expire1 = osm2pgsql.define_expire_output({
	minzoom = 6,
	maxzoom = maxzoom,
	table = 'cycling_restrictions_expire1'
})

local cycling_restrictions_expire2 = osm2pgsql.define_expire_output({
	minzoom = 10,
	maxzoom = maxzoom,
	table = 'cycling_restrictions_expire2'
})

local cycling_restrictions_expire3 = osm2pgsql.define_expire_output({
	minzoom = 13,
	maxzoom = maxzoom,
	table = 'cycling_restrictions_expire3'
})

local cycling_restrictions_expire4 = osm2pgsql.define_expire_output({
	minzoom = 16,
	maxzoom = maxzoom,
	table = 'cycling_restrictions_expire4'
})

local cycling_restrictions_lines1 = osm2pgsql.define_way_table('cycling_restrictions_lines1', {
	-- The road will be filled in a colour representing the access type. Roads where cycling is
	-- allowed will not be filled (access is null).
	{ column = 'access', type = 'text' },

	-- For roads where the forward/backward access is different, we render directional arrows
	-- in the colours representing the access type stored here. null means that no arrow should
	-- be rendered in this direction.
	{ column = 'forward', type = 'text' },
	{ column = 'backward', type = 'text' },

	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'linestring', projection = 3857, expire = { { output = cycling_restrictions_expire1 } } }
})

local cycling_restrictions_lines2 = osm2pgsql.define_way_table('cycling_restrictions_lines2', {
	{ column = 'access', type = 'text' },
	{ column = 'forward', type = 'text' },
	{ column = 'backward', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'linestring', projection = 3857, expire = { { output = cycling_restrictions_expire2 } } }
})

local cycling_restrictions_lines3 = osm2pgsql.define_way_table('cycling_restrictions_lines3', {
	{ column = 'access', type = 'text' },
	{ column = 'forward', type = 'text' },
	{ column = 'backward', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'linestring', projection = 3857, expire = { { output = cycling_restrictions_expire3 } } }
})

local cycling_restrictions_lines4 = osm2pgsql.define_way_table('cycling_restrictions_lines4', {
	{ column = 'access', type = 'text' },
	{ column = 'forward', type = 'text' },
	{ column = 'backward', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'linestring', projection = 3857, expire = { { output = cycling_restrictions_expire4 } } }
})

local cycling_restrictions_areas1 = osm2pgsql.define_area_table('cycling_restrictions_areas1', {
	{ column = 'access', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'geometry', projection = 3857, expire = { { output = cycling_restrictions_expire1 } } },
})

local cycling_restrictions_areas2 = osm2pgsql.define_area_table('cycling_restrictions_areas2', {
	{ column = 'access', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'geometry', projection = 3857, expire = { { output = cycling_restrictions_expire2 } } },
})

local cycling_restrictions_areas3 = osm2pgsql.define_area_table('cycling_restrictions_areas3', {
	{ column = 'access', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'geometry', projection = 3857, expire = { { output = cycling_restrictions_expire3 } } },
})

local cycling_restrictions_areas4 = osm2pgsql.define_area_table('cycling_restrictions_areas4', {
	{ column = 'access', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'geometry', projection = 3857, expire = { { output = cycling_restrictions_expire4 } } },
})

---@param oneway string | nil
---@param direction direction
---@return boolean
local function is_oneway(oneway, direction)
	return oneway and (direction == 'forward' and (oneway == 'yes' or oneway == 'true' or oneway == '1')) or (direction == 'backward' and (oneway == '-1' or oneway == 'reverse'))
end

---@generic T
---@param arr T[]
---@param val T
---@return boolean
local function array_contains(arr, val)
    for index, value in ipairs(arr) do
        if value == val then
            return true
        end
    end

    return false
end

local mid_highways = {
	'tertiary', 'motorway_link', 'trunk_link', 'primary_link',
	'secondary_link', 'tertiary_link', 'residential',
	'unclassified', 'raceway', 'bus_guideway'
}

local high_highways = {
	'living_street', 'road', 'service', 'service-minor',
	'pedestrian', 'platform', 'steps', 'bridleway',
	'footway', 'path', 'cycleway', 'track'
}

local function get_table(highway, access, table1, table2, table3, table4)
	if highway == 'footway' and access == 'restricted' then
		return table4
	elseif array_contains(high_highways, highway) then
		return table3
	elseif array_contains(mid_highways, highway) then
		return table2
	else
		return table1
	end
end

---@param tags tags
---@return access | nil
local function get_access(tags, direction)
	local highway = tags.highway

	if not highway then
		return nil
	end

	local bicycle = (direction and tags['bicycle:' .. direction]) or tags.bicycle
	local oneway = tags['oneway:bicycle'] or tags['oneway']

	-- Check oneway streets (oneway has a higher importance than access restrictions)
	if direction and is_oneway(oneway, direction == 'forward' and 'backward' or 'forward') then
		return 'restricted'

	-- Check explicit bicycle access
	elseif bicycle == 'designated' then
		-- If bicycles are explicitly permitted, skip checks based on other tags below
		return nil
	elseif bicycle == 'no' or bicycle == 'dismount' then
		return 'restricted'
	elseif bicycle == 'use_sidepath' then
		return 'sidepath'
	elseif bicycle == 'yes' or bicycle == 'discouraged' or bicycle == 'optional_sidepath' or bicycle == 'permissive' then
		if highway == 'footway' or highway == 'pedestrian' or tags.foot == 'designated' then
			return 'pedestrian'
		elseif bicycle == 'optional_sidepath' then
			return 'optional'
		else
			return nil
		end

	-- Check implicit bicycle access through vehicle access
	elseif bicycle == nil and ((direction and tags['vehicle:' .. direction]) or tags.vehicle) == 'no' then
		return 'restricted'

	-- Check implicit bicycle access through highway type
	elseif highway == 'living_street' then
		return 'pedestrian'
	elseif highway == 'footway' then
		-- highway=footway implies that cycling is forbidden, but for highway=pedestrian, it depends on the country, so we don't render that
		return 'restricted'
	elseif highway == 'motorway' or highway == 'motorway_link' then
		return 'motorway'
	elseif tags.motorroad == 'yes' then
		return 'motorroad'
	end
end

---@param tags tags
---@return string | nil
local function get_highway(tags)
	local highway = tags.highway

	if highway == 'service' then
		local service = tags.service
		if service == 'parking_aisle' or service == 'drive-through' or service == 'driveway' then
			return 'service-minor'
		end
	end

	return highway
end

function M.process_way(object)
	if object.is_closed and object.tags.area == 'yes' then
		local access = get_access(object.tags)

		if access ~= nil then
			local highway = get_highway(object.tags)
			local table = get_table(highway, access, cycling_restrictions_areas1, cycling_restrictions_areas2, cycling_restrictions_areas3, cycling_restrictions_areas4)
			table:insert({
				osm_id = object.id,
				access = access,
				highway = highway,
				geom = object:as_polygon()
			})
		end
	else
		---@type access | 'allowed' | nil
		local forward = get_access(object.tags, 'forward')
		---@type access | 'allowed' | nil
		local backward = get_access(object.tags, 'backward')

		local access
		if forward == backward then
			access = forward
		else
			access = get_access(object.tags) -- Decide "main" access type based on non-directional tags
		end

		local highway = get_highway(object.tags)
		local oneway = object.tags.oneway
		local oneway_forward = is_oneway(oneway, 'forward')
		local oneway_backward = is_oneway(oneway, 'backward')

		if (oneway_forward or oneway_backward) and forward == nil and backward == nil then
			-- A one-way street where cycling is allowed in both directions. We explicitly render two arrows here to make it
			-- clear that the OSM Carto one-way street arrow has no relevance for cyclists.
			forward = 'allowed'
			backward = 'allowed'
		elseif (oneway_forward and forward == nil and backward == 'restricted') or (oneway_backward and backward == nil and forward == 'restricted') then
			-- A one-way street where cycling is allowed in its direction and forbidden in the opposite direction. This is the
			-- default case of a one-way street. We do not render anything on such a road because the OSM Carto one-way street
			-- arrows already indicate this case.
			access = nil
			forward = nil
			backward = nil
		elseif forward == access and backward == access then
			-- Forward and backward both equal the main access level, so no arrows needed
			forward = nil
			backward = nil
		elseif forward == 'restricted' then
			-- (Only) forward is forbidden. Render no forward arrow.
			forward = nil

			if oneway_backward and backward == access then
				-- A oneway street where cycling is forbidden in the opposite direction. This is the default case of a
				-- one-way street. We do not render any arrows on such a road because the OSM Carto one-way street arrows
				-- already indicate this case.
				forward = nil
				backward = nil
			else
				-- Force a backward arrow to indicate one-way access.
				backward = backward or access or 'allowed'
			end
		elseif backward == 'restricted' then
			-- (Only) backward is forbidden. Render no backward arrow.
			backward = nil

			if oneway_forward and forward == access then
				-- A oneway street where cycling is forbidden in the opposite direction. This is the default case of a
				-- one-way street. We do not render any arrows on such a road because the OSM Carto one-way street arrows
				-- already indicate this case.
				forward = nil
				backward = nil
			else
				-- Force a forward arrow to indicate one-way access.
				forward = forward or access or 'allowed'
			end
		else
			-- Neither forward nor backward are forbidden, but ther access levels differ. Render two arrows, one for each direction.
			forward = forward or access or 'allowed'
			backward = backward or access or 'allowed'
		end

		if access ~= nil or forward ~= nil or backward ~= nil then
			local table = get_table(highway, access, cycling_restrictions_lines1, cycling_restrictions_lines2, cycling_restrictions_lines3, cycling_restrictions_lines4)
			table:insert({
				osm_id = object.id,
				access = access,
				forward = forward,
				backward = backward,
				highway = highway,
				geom = object:as_linestring()
			})
		end
	end
end

function M.process_relation(object)
	if object.tags.type == 'multipolygon' then
		local access = get_access(object.tags)

		if access ~= nil then
			local highway = get_highway(object.tags)
			local table = get_table(highway, access, cycling_restrictions_areas1, cycling_restrictions_areas2, cycling_restrictions_areas3, cycling_restrictions_areas4)
			table:insert({
				osm_id = object.id,
				access = access,
				highway = highway,
				geom = object:as_multipolygon()
			})
		end
	end
end

return M