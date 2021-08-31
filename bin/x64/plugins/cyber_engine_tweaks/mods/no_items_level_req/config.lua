---@class modConfig
---@field useAttributeRequirements Bool
local modConfig = {}

---Gets default configuration which just removes of the mod which make the mod to only remove the level requirement.
---@return modConfig
local function getDefaultConfig()
	return {useAttributeRequirements = false}
end

local config = {}

---Reads config file
---@return modConfig
function config.readConfig()
    local f = io.open("config.json", "r")
	if f == nil then
		print("[No items level requirement]: Config file not found")
		return getDefaultConfig()
	end
    local content = f:read("*a")
    f:close()
	if content == nil then
		print("[No items level requirement]: couldn't read config file")
		return getDefaultConfig()
	end
	return json.decode(content)
end

return config