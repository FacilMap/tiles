local M = {};

local toll_expire = osm2pgsql.define_expire_output({
    maxzoom = 20,
    table = 'toll_expire'
})

local toll_lines = osm2pgsql.define_way_table('toll_lines', {
	{ column = 'osm_id',   type = 'int8', not_null = true },
	{ column = 'highway', type = 'text' },
	{ column = 'geom',     type = 'linestring', projection = 3857, expire = { { output = toll_expire } } },
})

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
	if object.tags.toll == 'yes' and object.tags.route ~= 'ferry' then
		toll_lines:insert({
			osm_id = object.id,
			highway = get_highway(object.tags),
			geom = object:as_linestring()
		})
	end
end

return M