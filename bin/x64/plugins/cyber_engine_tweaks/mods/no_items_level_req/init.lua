local itemTypesBasedOnStrength
local itemTypesBasedOnReflexes
local config = require("config")
local loadedConfig

---For given level returns adequate attribute value by performing linear interpolation.
---Assumes that level is in range 1 - 50 and attribute in range 1 - 20.
---@param levelValue number Level value. Should be in range 1 - 50
---@return number attributeValue Attribute value. If level value was in range 1 - 50 then the attribute will be in range 1 - 20
local function mapLevelValueToAttributeValue(levelValue)
	return math.floor((levelValue - 1) / (50 - 1) * (20 - 1) + 1)
end

---Removes item modifier
---@param item gameItemData
---@param statType gamedataStatType
local function removeStat(item, statType)
	Game.GetStatsSystem():RemoveAllModifiers(item:GetStatsObjectID(), statType, true)
end

---Adds stat with modifier to item
---@param item gameItemData
---@param statTypeString string
---@param modifierTypeString string
---@param modifierValue Float
local function addStat(item, statTypeString, modifierTypeString, modifierValue)
	---@type gameStatModifierData
	local modifier = Game['gameRPGManager::CreateStatModifier;gamedataStatTypegameStatModifierTypeFloat'](statTypeString, modifierTypeString, modifierValue)
	Game.GetStatsSystem():AddModifier(item:GetStatsObjectID(), modifier)
end

---Removes leevl requirement from an item.
---@param item gameItemData
local function removeLevelRequirementFromItem(item)
	if item:HasStatData(gamedataStatType.Level) then
		if loadedConfig.useAttributeRequirements then
			if itemTypesBasedOnStrength[item:GetItemType().value] then
				addStat(item, "Strength", "Additive", mapLevelValueToAttributeValue(item:GetStatValueByType(gamedataStatType.Level)))
			elseif itemTypesBasedOnReflexes[item:GetItemType().value] then
				addStat(item, "Reflexes", "Additive", mapLevelValueToAttributeValue(item:GetStatValueByType(gamedataStatType.Level)))
				-- That may be not enough. Other modifiers may be needed to actually lower the weapon potential
			end
		end
		removeStat(item, gamedataStatType.Level)
	end
end

---Removes level requirement for all items in player's inventory
local function removeLevelRequirementFromInventoryItems()
	---@type InventoryDataManagerV2
	local inventoryManager = Game.GetScriptableSystemsContainer():Get('EquipmentSystem'):GetPlayerData(Game.GetPlayer()):GetInventoryManager()
	---@type gameItemData[]
	local items = inventoryManager:GetPlayerInventory({})
	for _, item in ipairs(items) do
		removeLevelRequirementFromItem(item)
	end
end

-- gameDataItemType.<type>.value returns string representation of the type.
-- without the .value it's an address of the Sol.enum object, which does not work with table indexing in removeLevelRequirementFromInventoryItems
local function onLoaded()
	itemTypesBasedOnStrength = {
		[gamedataItemType.Wea_Fists.value] = true,
		[gamedataItemType.Wea_Hammer.value] = true,
		[gamedataItemType.Wea_HeavyMachineGun.value] = true,
		[gamedataItemType.Wea_LightMachineGun.value] = true,
		[gamedataItemType.Wea_Melee.value] = true,
		[gamedataItemType.Wea_OneHandedClub.value] = true,
		[gamedataItemType.Wea_Shotgun.value] = true,
		[gamedataItemType.Wea_ShotgunDual.value] = true,
		[gamedataItemType.Wea_TwoHandedClub.value] = true
	}

	itemTypesBasedOnReflexes = {
		[gamedataItemType.Wea_AssaultRifle.value] = true,
		[gamedataItemType.Wea_Handgun.value] = true,
		[gamedataItemType.Wea_Katana.value] = true,
		[gamedataItemType.Wea_Knife.value] = true,
		[gamedataItemType.Wea_LongBlade.value] = true,
		[gamedataItemType.Wea_PrecisionRifle.value] = true,
		[gamedataItemType.Wea_Revolver.value] = true,
		[gamedataItemType.Wea_Rifle.value] = true,
		[gamedataItemType.Wea_ShortBlade.value] = true,
		[gamedataItemType.Wea_SniperRifle.value] = true,
		[gamedataItemType.Wea_SubmachineGun.value] = true
	}
	loadedConfig = config.readConfig()
	removeLevelRequirementFromInventoryItems()
end

registerForEvent("onInit", function()
	local isLoaded = Game.GetPlayer() and Game.GetPlayer():IsAttached() and not Game.GetSystemRequestsHandler():IsPreGame()

	if isLoaded then
		onLoaded()
	end

	Observe('QuestTrackerGameController', 'OnInitialize', function()
		if not isLoaded then
			isLoaded = true
			onLoaded()
		end
	end)

	Observe('QuestTrackerGameController', 'OnUninitialize', function()
		if Game.GetPlayer() == nil then
			isLoaded = false
		end
	end)

	Override("gameInventoryScriptCallback", "OnItemAdded", function(self, itemID, itemData, flaggedAsSilent)
		removeLevelRequirementFromItem(itemData)
	end)
end)
