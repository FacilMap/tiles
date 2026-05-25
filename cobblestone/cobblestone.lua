local M = {}

local cobblestone_expire = osm2pgsql.define_expire_output({
	maxzoom = 20,
	table = 'cobblestone_expire'
})

local cobblestone_lines = osm2pgsql.define_way_table('cobblestone_lines', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'linestring', projection = 3857, expire = { { output = cobblestone_expire } } },
})

local cobblestone_areas = osm2pgsql.define_area_table('cobblestone_areas', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'geometry', projection = 3857, expire = { { output = cobblestone_expire } } },
})

local function is_cobblestone(tags)
	if tags.highway == nil then
		return false
	end

	local surface = tags.surface
	return surface == 'cobblestone' or surface == 'unhewn_cobblestone' or surface == 'sett'
end

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
	if is_cobblestone(object.tags) then
		if object.is_closed and object.tags.area == 'yes' then
			cobblestone_areas:insert({
				osm_id = object.id,
				highway = get_highway(object.tags),
				geom = object:as_polygon()
			})
		else
			cobblestone_lines:insert({
				osm_id = object.id,
				highway = get_highway(object.tags),
				geom = object:as_linestring()
			})
		end
	end
end

function M.process_relation(object)
	if object.tags.type == 'multipolygon' and is_cobblestone(object.tags) then
		cobblestone_areas:insert({
			osm_id = object.id,
			highway = get_highway(object.tags),
			geom = object:as_multipolygon()
		})
	end
end

return M