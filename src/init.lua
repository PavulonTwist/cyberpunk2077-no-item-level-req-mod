 ---Removes level requirement from an item
 ---@param item gameItemData
 local function removeLevelRequirementForItem(item)
	if item.HasStatData(gamedataStatType.Level) then
		Game.GetStatsSystem():RemoveAllModifiers(item:GetStatsObjectID(), gamedataStatType.Level, true)
	end
end

---Removes level requirement for all items in player's inventory
local function removeLevelRequirementFromInventoryItems()
	local inventoryManager = Game.GetScriptableSystemsContainer():Get('EquipmentSystem'):GetPlayerData(Game.GetPlayer()):GetInventoryManager()
	local items = inventoryManager:GetPlayerInventory({})
	for _, item in ipairs(items) do
		removeLevelRequirementForItem(item)
	end
end

registerForEvent("onInit", function()
	local isLoaded = Game.GetPlayer() and Game.GetPlayer():IsAttached() and not Game.GetSystemRequestsHandler():IsPreGame()

	if isLoaded then
		removeLevelRequirementFromInventoryItems()
	end

	Observe('QuestTrackerGameController', 'OnInitialize', function()
		if not isLoaded then
			isLoaded = true
			removeLevelRequirementFromInventoryItems()
		end
	end)

	Observe('QuestTrackerGameController', 'OnUninitialize', function()
		if Game.GetPlayer() == nil then
			isLoaded = false
		end
	end)

	Override("gameInventoryScriptCallback", "OnItemAdded", function(self, itemID, itemData, flaggedAsSilent)
		removeLevelRequirementForItem(itemData)
	end)
end)
