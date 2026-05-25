local M = {}

local overlay_expire = osm2pgsql.define_expire_output({
	maxzoom = 20,
	table = 'overlay_expire'
})

local overlay_lines = osm2pgsql.define_way_table('overlay_lines', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'linestring', projection = 3857, expire = { { output = overlay_expire } } },
})

local overlay_areas = osm2pgsql.define_area_table('overlay_areas', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'geometry', projection = 3857, expire = { { output = overlay_expire } } },
})

local function is_relevant(tags)
	return false
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
	if is_relevant(object.tags) then
		if object.is_closed and object.tags.area == 'yes' then
			overlay_areas:insert({
				osm_id = object.id,
				highway = get_highway(object.tags),
				geom = object:as_polygon()
			})
		else
			overlay_lines:insert({
				osm_id = object.id,
				highway = get_highway(object.tags),
				geom = object:as_linestring()
			})
		end
	end
end

function M.process_relation(object)
	if object.tags.type == 'multipolygon' and is_relevant(object.tags) then
		overlay_areas:insert({
			osm_id = object.id,
			highway = get_highway(object.tags),
			geom = object:as_multipolygon()
		})
	end
end

return M