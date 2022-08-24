local QBCore = exports['qb-core']:GetCoreObject()
local currentRegister = 0
local currentCashier = nil

RegisterNetEvent('qb-restaurants:server:giveItem', function(item, quantity)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local x = false
    for _,v in pairs(Config.Items) do
        if item == v then x = true end
    end
    if x then
        Player.Functions.AddItem(item,quantity)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[item], "add")
    end
end)

RegisterNetEvent('qb-restaurants:server:setPizzaRegister', function(total)
    print(tonumber(total))
    currentRegister = tonumber(total)
    currentCashier = source
end)

QBCore.Functions.CreateCallback('qb-restaurants:server:getTotalPizza', function(source, cb)
    cb(currentRegister)
end)

RegisterNetEvent('qb-restaurants:server:payPizza', function(total)
    local src = source
    print(currentRegister)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.money.bank > currentRegister then
        Player.Functions.RemoveMoney('bank', currentRegister, "Pizza Shop")
        TriggerClientEvent('QBCore:Notify', currentCashier, "Payment Success")
    elseif Player.PlayerData.money.cash > currentRegister then
        Player.Functions.RemoveMoney('cash', currentRegister, "Pizza Shop")
        TriggerClientEvent('QBCore:Notify', currentCashier, "Payment Success")
    else
        TriggerClientEvent('QBCore:Notify', src, "You are broke!", 'error')
        TriggerClientEvent('QBCore:Notify', currentCashier, "Payment Declined", 'error')
    end
end)