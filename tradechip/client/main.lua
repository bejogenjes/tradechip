ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Blip map --
Citizen.CreateThread(function()
    Citizen.Wait(100)

    for locationIndex = 1, #Config.TradeChipLocations do
        local locationPos = Config.TradeChipLocations[locationIndex]
        local blip = AddBlipForCoord(locationPos)
        SetBlipSprite (blip, 500)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.8)
        SetBlipColour (blip, 69)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Tukar Chip')
        EndTextCommandSetBlipName(blip)
    end

    while true do
        local sleepThread = 500
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        for locationIndex = 1, #Config.TradeChipLocations do
            local locationPos = Config.TradeChipLocations[locationIndex]
            local dstCheck = GetDistanceBetweenCoords(pedCoords, locationPos, true)
            if dstCheck <= 5.0 then
                sleepThread = 5
                local text = 'Tukar Chip'
                if dstCheck <= 1.5 then
                    text = '[~g~E~s~] ' .. text
                    if IsControlJustReleased(0, 38) then
                        trademenu()
                    end
                elseif GetDistanceBetweenCoords(pedCoords, locationPos, true) > 1 then
                    ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'tukar_chip')
                end
                ESX.Game.Utils.DrawText3D(locationPos, text, 0.4)
            end
        end
        Citizen.Wait(sleepThread)
    end
end)

-- Tukar chip --
function trademenu(jumlahchip)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tukar_chip',
    {
        title    = 'Yakin ingin menukar Chip?',
        align    = 'top-left',
        elements = {
            {label = 'Tukar Chip '..Config.tukarchip.label..' / Chip', value = 'C'},
        },
    }, function(data, menu)
        if data.current.value == 'C' then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'tukar_chip', {
                title = 'Berapa jumlah yang anda ingin tukar?'
            }, function(data, menu)
                local jumlahchip = tonumber(data.value)
                if jumlahchip == nil or jumlahchip < 0 then
                    exports['mythic_notify']:SendAlert('error', 'Anda tidak memiliki Chip!')
                else
                    menu.close()
                    TriggerServerEvent('tradechip:trade', jumlahchip)
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end