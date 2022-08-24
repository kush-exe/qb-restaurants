local QBCore = exports['qb-core']:GetCoreObject()

--functions

local function payFood()
    QBCore.Functions.TriggerCallback('qb-restaurants:server:getTotalPizza', function(total)
        if total then
            TriggerServerEvent('qb-restaurants:server:payPizza')
        end
    end)
end

local function chargeCustomer()
    local total = exports['qb-input']:ShowInput({
        header = "Total: $",
        submitText = "Charge",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'total',
                text = 'Total'
            }
        }
    })
    if total then
        TriggerServerEvent('qb-restaurants:server:setPizzaRegister', total.total)
    end
end

local function openCounter()
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "pizzashop", {
        maxweight = 10000,
        slots = 6,
    })
end

local function cutMeat()
    exports['ps-ui']:Circle(function(success)
        if success then
            --give meat item
            TriggerServerEvent('qb-restaurants:server:giveItem', 'rawmeat', 1)
        end
    end, 6, 10)
end

local function prepFood()

    local foodMenu = {
        {
            header = "Food Menu",
            icon = "fa-solid fa-pizza-slice",
            isMenuHeader = true,
        },
    }

    for _, v in pairs(Config.Items) do
        if v ~= 'rawmeat' then
            local x = QBCore.Shared.Items[v]['label']
            table.insert(foodMenu, {
                    header = x,
                    txt = "",
                    icon = "fa-solid fa-utensils",
                    params = {
                        event = "qb-restaurants:client:pizzaPrep",
                        args = {
                            item = v,
                            quantity = 1
                        }
                    }
            })
        end
    end

    exports['qb-menu']:openMenu(foodMenu)
end

--events
RegisterNetEvent('qb-restaurants:client:pizzaPrep', function(data)
    local reqMeat = false
    if data.item == 'mushroompizza' or data.item == 'lasagna' or data.item == 'chickenalfredo' or data.item == 'meatloverpizza' or data.item == 'pepperonipizza' or data.item == 'pepperonipizza' or data.item == 'spaghetti' or data.item == 'salmon' or data.item == 'chickenpasta' then
        reqMeat = true
    end

    if reqMeat then
        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasItem)
            if hasItem then
                exports['ps-ui']:Circle(function(success)
                    if success then
                        --give item
                        TriggerServerEvent('qb-restaurants:server:giveItem', data.item, data.quantity)
                    end
                end, 6, 10)
            else
                QBCore.Functions.Notify("You need raw meat to make this item!", "error")
            end
        end, 'rawmeat')
    else
        exports['ps-ui']:Circle(function(success)
            if success then
                --give item
                TriggerServerEvent('qb-restaurants:server:giveItem', data.item, data.quantity)
            end
        end, 6, 10)
    end
end)

--create polyzones for registers
exports['qb-target']:AddBoxZone("register1", vector3(287.48, -977.0, 29.43), 0.8, 1, {
    name = "register1",
    heading=270,
  --debugPoly=true,
    minZ=28.43,
    maxZ=30.03
}, {
    options = {
        {
            icon = "fa fa-dollar",
            label = "Pay for your food",
            action = function()
                payFood()
            end,
        },
        {
            icon = "fa fa-dollar",
            label = "Ring up the customer",
            job = "pizza",
            action = function()
                chargeCustomer()
            end,
        }
    },
    distance = 1.5
})

exports['qb-target']:AddBoxZone("meat", vector3(294.88, -984.17, 29.43), 4.0, 1, {
    name = "meat",
    heading=0,
  --debugPoly=true
}, {
    options = {
        {
            icon = "fa fa-cow",
            label = "Cut Meat",
            job = "pizza",
            action = function()
                cutMeat()
            end,

        },
    },
    distance = 2.0
})

exports['qb-target']:AddBoxZone("cook", vector3(286.67, -983.49, 29.43), 2.0, 1, {
    name = "cook",
    heading=0,
    minZ=28.43,
    maxZ=29.63
  --debugPoly=true
}, {
    options = {
        {
            icon = "fa fa-pizza-slice",
            label = "Prepare Food",
            job = "pizza",
            action = function()
                prepFood()
            end,

        },
    },
    distance = 2.0
})

exports['qb-target']:AddBoxZone("counter", vector3(288.38, -977.02, 29.43), 0.6, 1, {
    name = "counter",
    heading=0,
    minZ=28.43,
    maxZ=29.63
  --debugPoly=true
}, {
    options = {
        {
            icon = "fa fa-pizza-slice",
            label = "Counter",
            action = function()
                openCounter()
            end,

        },
    },
    distance = 2.0
})