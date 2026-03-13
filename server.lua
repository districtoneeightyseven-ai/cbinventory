-- QBCore Inventory Server-Side Code

QBCore = exports['qb-core']:GetCoreObject()

local PlayerInventories = {}

-- Function to create a new inventory for a player
function CreateInventory(playerId)
    PlayerInventories[playerId] = {items = {}}
end

-- Function to add an item to a player's inventory
function AddItem(playerId, itemName, amount)
    if PlayerInventories[playerId] then
        local item = PlayerInventories[playerId].items[itemName]
        if item then
            item.amount = item.amount + amount
        else
            PlayerInventories[playerId].items[itemName] = {amount = amount}
        end
    end
end

-- Function to remove an item from a player's inventory
function RemoveItem(playerId, itemName, amount)
    if PlayerInventories[playerId] then
        local item = PlayerInventories[playerId].items[itemName]
        if item and item.amount >= amount then
            item.amount = item.amount - amount
            if item.amount <= 0 then
                PlayerInventories[playerId].items[itemName] = nil
            end
        end
    end
end

-- Function to get a player's inventory
function GetInventory(playerId)
    return PlayerInventories[playerId] or {items = {}}
end

-- Add server events to handle inventory management
RegisterServerEvent('qb-inventory:addItem')
AddEventHandler('qb-inventory:addItem', function(itemName, amount)
    local _source = source
    AddItem(_source, itemName, amount)
end)

RegisterServerEvent('qb-inventory:removeItem')
AddEventHandler('qb-inventory:removeItem', function(itemName, amount)
    local _source = source
    RemoveItem(_source, itemName, amount)
end)

RegisterServerEvent('qb-inventory:getInventory')
AddEventHandler('qb-inventory:getInventory', function()
    local _source = source
    TriggerClientEvent('qb-inventory:sendInventory', _source, GetInventory(_source))
end)