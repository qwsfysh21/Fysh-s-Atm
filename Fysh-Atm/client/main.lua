ESX = exports["es_extended"]:getSharedObject()

function options()
    return {
        {
            label = "Tilgå Hæveautomat",
            icon = 'fa fa-arrow-right',
            onSelect = function()
                MainMenu()
            end
        }
    }
end

exports.ox_target:addModel("prop_fleeca_atm", options())

function MainMenu()
    local playerID = GetPlayerServerId(PlayerId())
    local xPlayer = ESX.GetPlayerData()
    local playerName = xPlayer.name
    
    local konto = 0
    local cash = 0
    
    TriggerServerEvent("qws:fetch_konto")
    TriggerServerEvent("qws:fetch_cash")

    RegisterNetEvent("qws:send_konto")
    AddEventHandler("qws:send_konto", function(serverKonto)
        konto = serverKonto
        UpdateMenu(playerName, playerID, konto, cash)
    end)

    RegisterNetEvent("qws:send_cash")
    AddEventHandler("qws:send_cash", function(serverCash)
        cash = serverCash
        UpdateMenu(playerName, playerID, konto, cash)
    end)
end

function formatNumber(num)
    local formatted = tostring(num)
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

function UpdateMenu(playerName, playerID, konto, cash)
    konto = formatNumber(konto)
    cash = formatNumber(cash)

    lib.registerContext({
        id = 'qws_atms_main_menu',
        title = 'Penge Automat',
        options = {
            {
                title = 'Hæv penge',
                description = 'Hæv et bestemt beløb.',
                icon = 'https://cdn.discordapp.com/attachments/1203978985428623411/1260652110026899586/10074041.png?ex=66901944&is=668ec7c4&hm=dd6b8e060adeb789772a173c8dc791631250b11236f4b21a132efe7acddd18b9&',
                onSelect = function()
                    local input = lib.inputDialog("Hæveautomat | Fysh's Development", {
                        {type = 'number', description = 'Hvor meget ønsker du at hæve?', required = true}
                    })

                    if input and input[1] then
                        local amount = tonumber(input[1])
                        if amount and amount > 0 then
                            ESX.TriggerServerCallback('qws:withdraw', function(success)
                                if success then
                                    lib.notify({title = 'Pengeautomat', description = 'Du hævede ' .. formatNumber(amount) .. ' DKK.', type = 'success', position = 'center-left'})
                                else
                                    lib.notify({title = 'Pengeautomat', description = 'Du har ikke nok penge på din konto!', type = 'error', position = 'center-left'})
                                end
                            end, amount)
                        else
                            lib.notify({title = 'Fejl', description = 'Ugyldigt beløb angivet.', type = 'error', position = 'center-left'})
                        end
                    end
                end
            },
            {
                title = 'Indsæt penge',
                description = 'Indsæt et bestemt beløb på din konto.',
                icon = 'https://cdn.discordapp.com/attachments/1203978985428623411/1260654722696609894/ATM_terminal_pay_cash_out_cash_bank-07-512.png?ex=66901bb3&is=668eca33&hm=98746ebf60264ae91ebcdf0fa51f7121b1b0c32d96ed3e40aabfac023ff4bb0c&',
                onSelect = function()
                    local input = lib.inputDialog("Hæveautomat | Fysh's Development", {
                        {type = 'number', description = 'Hvor meget ønsker du at indsætte?', required = true}
                    })

                    if input and input[1] then
                        local amount = tonumber(input[1])
                        if amount and amount > 0 then
                            ESX.TriggerServerCallback('qws:deposit', function(success)
                                if success then
                                    lib.notify({title = 'Pengeautomat', description = 'Du indsætte ' .. formatNumber(amount) .. ' DKK.', type = 'success', position = 'center-left'})
                                else
                                    lib.notify({title = 'Pengeautomat', description = 'Du har ikke nok kontanter til at indsætte dette beløb!', type = 'error', position = 'center-left'})
                                end
                            end, amount)
                        else
                            lib.notify({title = 'Fejl', description = 'Ugyldigt beløb angivet.', type = 'error', position = 'center-left'})
                        end
                    end
                end
            },
            {
                progress = 100,
                colorScheme = "green"
            },
            {
                title = 'Hurtig handling',
                description = 'Hæv 10.000 DKK',
                arrow = true,
                icon = 'fa-solid fa-forward-fast',
                onSelect = function()
                    ESX.TriggerServerCallback('qws:withdraw_10000', function(success)
                        if success then
                            lib.notify({title = 'Pengeautomat', description = 'Du hævede 10.000 DKK.', type = 'success', position = 'center-left'})
                        else
                            lib.notify({title = 'Pengeautomat', description = 'Du har ikke 10.000 DKK på din konto!', type = 'error', position = 'center-left'})
                        end
                    end)
                end
            },
            {
                title = 'Hurtig handling',
                description = "Indsæt 10.000 DKK",
                arrow = true,
                icon = 'fa-solid fa-forward-fast',
                onSelect = function()
                    ESX.TriggerServerCallback('qws:deposit_10000', function(success)
                        if success then
                            lib.notify({title = 'Pengeautomat', description = 'Du indsatte 10.000 DKK.', type = 'success', position = 'center-left'})
                        else
                            lib.notify({title = 'Pengeautomat', description = 'Du har ikke 10.000 DKK i kontanter.', type = 'error', position = 'center-left'})
                        end
                    end)
                end
            },
            {
                progress = 100,
                colorScheme = "green"
            },
            {
                title = "Information",
                description = 'Se dine detaljer.',
                icon = "fa fa-person",
                metadata = {
                    {
                        label = 'Dit navn',
                        value = playerName
                    },
                    {
                        label = 'Spiller ID',
                        value = playerID
                    },
                    {
                        label = 'Kontanter',
                        value = cash .. ' DKK'
                    },
                    {
                        label = 'Bankkonto',
                        value = konto .. ' DKK'
                    }
                }
            },
            {
                description = "Fysh's Development | Discord.gg/fyshdev"
            },
        }
    })

    lib.showContext("qws_atms_main_menu")
end
