local M = {}

local cycling_restrictions_expire = osm2pgsql.define_expire_output({
	maxzoom = 20,
	table = 'cycling_restrictions_expire'
})

local cycling_restrictions_lines = osm2pgsql.define_way_table('cycling_restrictions_lines', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'access', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'linestring', projection = 3857, expire = { { output = cycling_restrictions_expire } } },
})

local cycling_restrictions_lines2 = osm2pgsql.define_way_table('cycling_restrictions_lines2', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'forward', type = 'text' },
	{ column = 'backward', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'linestring', projection = 3857, expire = { { output = cycling_restrictions_expire } } },
})

local cycling_restrictions_areas = osm2pgsql.define_area_table('cycling_restrictions_areas', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'access', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'geometry', projection = 3857, expire = { { output = cycling_restrictions_expire } } },
})

local function get_access(tags, direction)
	local highway = tags.highway

	if not highway then
		return nil
	end

	local bicycle = (direction and tags['bicycle:' .. direction]) or tags.bicycle
	local oneway = tags['oneway:bicycle'] or tags['oneway']

	-- Check oneway streets (oneway has a higher importance than access restrictions)
	if direction and oneway and ((direction == 'backward' and (oneway == 'yes' or oneway == 'true' or oneway == '1')) or (direction == 'forward' and (oneway == '-1' or oneway == 'reverse'))) then
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
			cycling_restrictions_areas:insert({
				osm_id = object.id,
				access = access,
				highway = get_highway(object.tags),
				geom = object:as_polygon()
			})
		end
	else
		local forward = get_access(object.tags, 'forward')
		local backward = get_access(object.tags, 'backward')

		if forward ~= nil or backward ~= nil then
			if forward == backward then
				cycling_restrictions_lines:insert({
					osm_id = object.id,
					access = forward,
					highway = get_highway(object.tags),
					geom = object:as_linestring()
				})
			else
				cycling_restrictions_lines2:insert({
					osm_id = object.id,
					forward = forward,
					backward = backward,
					highway = get_highway(object.tags),
					geom = object:as_linestring()
				})
			end
		end
	end
end

function M.process_relation(object)
	if object.tags.type == 'multipolygon' then
		local access = get_access(object.tags)

		if access ~= nil then
			cycling_restrictions_areas:insert({
				osm_id = object.id,
				access = access,
				highway = get_highway(object.tags),
				geom = object:as_multipolygon()
			})
		end
	end
end

return M