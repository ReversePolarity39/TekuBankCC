-- ATM version 0.0.6 --
-- Must be called pullapi.lua --

local chests = {
    ["minecraft:chest_0"] = {
        coins = {"lightmanscurrency:coin_copper"}
    },
    ["minecraft:chest_4"] = {
        coins = {"lightmanscurrency:coin_iron"}
    },
    ["minecraft:chest_5"] = {
        coins = {"lightmanscurrency:coin_gold"}
    },
    ["minecraft:chest_6"] = {
        coins = {"lightmanscurrency:coin_emerald"}
    },
    ["minecraft:chest_7"] = {
        coins = {"lightmanscurrency:coin_diamond"}
    },
    ["minecraft:chest_8"] = {
        coins = {"lightmanscurrency:coin_netherite"}
    },
}

-- Initialize coin values
local currencyValues = {
    ["lightmanscurrency:coin_copper"] = 1,
    ["lightmanscurrency:coin_iron"] = 10,
    ["lightmanscurrency:coin_gold"] = 100,
    ["lightmanscurrency:coin_emerald"] = 1000,
    ["lightmanscurrency:coin_diamond"] = 10000,
    ["lightmanscurrency:coin_netherite"] = 100000
}

local dropper = "minecraft:dropper_0"
local junk = "minecraft:dropper_1"

local d = peripheral.wrap(dropper)
local j = peripheral.wrap(junk)

function getStored()
    local totalValue = 0
    for chest, _ in pairs(chests) do
        local cs = peripheral.wrap(chest)
        local chestItems = cs.list()
        
        for _, item in pairs(chestItems) do
            local value = currencyValues[item.name]
            if value then
                totalValue = totalValue + (value * item.count)
            end
        end
    end
    return totalValue
end

function deposit()
    local count = 0
    for chest, coinTypes in pairs(chests) do
        local cs = peripheral.wrap(chest)
        for i = 1, 9 do
            local tab = d.getItemDetail(i)
            if tab ~= nil then
                local currencyValue = currencyValues[tab.name]
                if currencyValue then
                    local deped = d.pushItems(chest, i, 64)
                    count = count + (currencyValue * deped)
                end
            end
        end
    end
    if count > 0 then
        return true, count
    else
        return false, "No valid coins to deposit"
    end
end

function withdraw(amount)
    if amount > 36000000 then
        return false, "Amount must be at maximum 360,000,000"
    end
    
    local count = 0
    for chest, coinTypes in pairs(chests) do
        local cs = peripheral.wrap(chest)
        for i = 1, 9 do
            local tab = cs.getItemDetail(i)
            if tab ~= nil then
                local currencyValue = currencyValues[tab.name]
                if currencyValue then
                    local withdrawAmount = math.min(tab.count, (amount - count) / currencyValue)
                    if withdrawAmount > 0 then
                        d.pullItems(chest, i, withdrawAmount)
                        count = count + (currencyValue * withdrawAmount)
                    end
                    if count == amount then
                        return true
                    end
                end
            end
        end
    end

    return false, "Not enough valid coins in storage"
end

return {
    getStored = getStored,
    deposit = deposit,
    withdraw = withdraw,
}
