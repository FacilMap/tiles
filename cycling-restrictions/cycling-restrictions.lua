local M = {}

---@alias access 'restricted' | 'motorway' | 'motorroad' | 'sidepath' | 'pedestrian' | 'optional'
---@alias direction 'forward' | 'backward'
---@alias tags { [string]: string | nil }

local cycling_restrictions_expire = osm2pgsql.define_expire_output({
	maxzoom = 20,
	table = 'cycling_restrictions_expire'
})

local cycling_restrictions_lines = osm2pgsql.define_way_table('cycling_restrictions_lines', {
	{ column = 'osm_id', type = 'int8', not_null = true },
	{ column = 'access', type = 'text' },
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

---@param oneway string | nil
---@param direction direction
---@return boolean
local function is_oneway(oneway, direction)
	return oneway and (direction == 'forward' and (oneway == 'yes' or oneway == 'true' or oneway == '1')) or (direction == 'backward' and (oneway == '-1' or oneway == 'reverse'))
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
			cycling_restrictions_areas:insert({
				osm_id = object.id,
				access = access,
				highway = get_highway(object.tags),
				geom = object:as_polygon()
			})
		end
	else
		---@type access | 'allowed' | nil
		local forward = get_access(object.tags, 'forward')
		---@type access | 'allowed' | nil
		local backward = get_access(object.tags, 'backward')

		if forward == backward and forward ~= nil then
			cycling_restrictions_lines:insert({
				osm_id = object.id,
				access = forward,
				highway = get_highway(object.tags),
				geom = object:as_linestring()
			})

		-- Keep in mind special case: Oneway streets where cycling is allowed in both directions now still have forward and backward both nil
		else
			local oneway = object.tags.oneway
			local access = nil

			-- If access is different in both directions
			if forward == 'motorway' or backward == 'motorway' then
				access = 'motorway';
			elseif forward == 'motorroad' or backward == 'motorroad' then
				access = 'motorroad'
			elseif forward == 'sidepath' or backward == 'sidepath' then
				access = 'sidepath'
			elseif forward == 'optional' or backward == 'optional' then
				access = 'optional'
			end

			if is_oneway(oneway, 'forward') then
				if backward == nil then
					-- Render a green arrow opposite to the OSM Carto one-way street arrow to indicate that cycling is allowed
					-- in the opposite direction.
					backward = 'allowed'
				elseif backward == 'restricted' then
					-- Cycling being forbidden in the opposite direction is the default assumption and we don't render anything
					-- and let the OSM Carto arrows indicate the one-way street. If we rendered this case explicitly, the whole
					-- map would be cluttered because it would apply to almost every dual carriageway.
					backward = nil
				end
			elseif is_oneway(oneway, 'backward') then
				if forward == nil then
					forward = 'allowed'
				elseif forward == 'restricted' then
					forward = nil
				end
			end

			if forward == access then
				forward = nil
			end

			if backward == access then
				backward = nil
			end

			if access ~= nil or forward ~= nil or backward ~= nil then
				cycling_restrictions_lines:insert({
					osm_id = object.id,
					access = access,
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