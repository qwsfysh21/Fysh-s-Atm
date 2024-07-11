ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent("qws:fetch_konto")
AddEventHandler("qws:fetch_konto", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local konto = xPlayer.getAccount('bank').money
    TriggerClientEvent("qws:send_konto", src, konto)
end)

RegisterServerEvent("qws:fetch_cash")
AddEventHandler("qws:fetch_cash", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local cash = xPlayer.getMoney()
    TriggerClientEvent("qws:send_cash", src, cash)
end)

ESX.RegisterServerCallback('qws:withdraw_10000', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount('bank').money >= 10000 then
        xPlayer.removeAccountMoney('bank', 10000)
        xPlayer.addMoney(10000)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('qws:withdraw', function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount('bank').money >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('qws:deposit_10000', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = 'cash'
    local amount = 10000

    if xPlayer.getInventoryItem(item).count >= amount then
        xPlayer.removeInventoryItem(item, amount)
        xPlayer.addAccountMoney('bank', amount)
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("qws:deposit", function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = 'cash'

    if xPlayer.getInventoryItem(item).count >= amount then
        xPlayer.removeInventoryItem(item, amount)
        xPlayer.addAccountMoney('bank', amount)
        cb(true)
    else
        cb(false)
    end
end)
