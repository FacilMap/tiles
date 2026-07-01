-- This Lua script combines all the scripts found under the following glob:
local scripts = "*/*.lua"
-- Each of those scripts must export a table that may contain any of the `process_node`, … functions as elements,
-- rather than assigning those to the global `osm2pgsql` global object as you normally would in an osm2pgsql script.

local script_name = debug.getinfo(1, "S").source:sub(2):match("([^/\\]+)$")
local script_path = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or ""

local processors = {}
local handle = io.popen(string.format('ls -1p "%s"%s | grep -v overlay-template', script_path, scripts))
if not handle then return end

local package_path = package.path
for filename in handle:lines() do
    if filename:match("%.lua$") and filename ~= script_name then
        local module_name = filename:match("([^/]+)%.lua$")
        package.path = filename:match("(.*/)") .. "?.lua;" .. package_path
        processors[module_name] = require(module_name)
    end
end
package.path = package_path

handle:close()

for _, func in ipairs({
    "process_node", "process_way", "process_relation",
    "process_untagged_node", "process_untagged_way", "process_untagged_relation",
    "process_deleted_node", "process_deleted_way", "process_deleted_relation"
}) do
    local handlers = {}
    for _, processor in pairs(processors) do
        if processor[func] then
            table.insert(handlers, processor[func])
        end
    end

    if #handlers > 0 then
        osm2pgsql[func] = function(object)
            for _, handler in ipairs(handlers) do
                handler(object)
            end
        end
    end
end