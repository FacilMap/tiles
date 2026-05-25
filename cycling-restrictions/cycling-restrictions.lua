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

local cycling_restrictions_areas = osm2pgsql.define_area_table('cycling_restrictions_areas', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'access', type = 'text' },
	{ column = 'highway', type = 'text' },
	{ column = 'geom', type = 'geometry', projection = 3857, expire = { { output = cycling_restrictions_expire } } },
})

local function get_access(tags)
	local highway = tags.highway

	if not highway then
		return nil
	end

	local bicycle = tags.bicycle

	-- Check explicit bicycle access
	if bicycle == 'designated' then
		-- If bicycles are explicitly permitted, skip checks based on other tags below
		return nil
	elseif bicycle == 'no' or bicycle == 'dismount' then
		if highway == 'footway' then
			-- Do not render footways, as it is clear from the map that cycling is not allowed and they would clutter the map
			return nil
		else
			return 'restricted'
		end
	elseif bicycle == 'use_sidepath' then
		return 'sidepath'
	elseif bicycle == 'yes' or bicycle == 'discouraged' or bicycle == 'optional_sidepath' or bicycle == 'permissive' then
		if highway == 'footway' or highway == 'pedestrian' or highway == 'living_street' or tags.foot == 'designated' then
			return 'pedestrian'
		else
			return nil
		end

	-- Check implicit bicycle access through vehicle access
	elseif bicycle == nil and tags.vehicle == 'no' then
		return 'restricted'

	-- Check implicit bicycle access through highway type
	elseif highway == 'motorway' or highway == 'motorway_link' then
		return 'motorway'
	elseif tags.motorroad == 'yes' then
		return 'motorroad'
	end

	-- We do not display highway=pedestrian or highway=living_street unless they have explicit bicycle tags,
	-- because their regulations vary from country to country and the default map already renders them.
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
	local access = get_access(object.tags)

	if access ~= nil then
		if object.is_closed and object.tags.area == 'yes' then
			cycling_restrictions_areas:insert({
				osm_id = object.id,
				access = access,
				highway = get_highway(object.tags),
				geom = object:as_polygon()
			})
		else
			cycling_restrictions_lines:insert({
				osm_id = object.id,
				access = access,
				highway = get_highway(object.tags),
				geom = object:as_linestring()
			})
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