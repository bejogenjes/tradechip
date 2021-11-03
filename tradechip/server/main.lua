ESX = nil
local all = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- TradeChip --
RegisterServerEvent('tradechip:trade')
AddEventHandler('tradechip:trade', function(jumlahchip)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem('chip')
    local harga = ESX.Math.Round(Config.tukarchip.price * jumlahchip)
    if item['count'] >= 0 then
        if jumlahchip <= item['count'] then
            xPlayer.removeInventoryItem('chip', jumlahchip)
            xPlayer.addMoney(harga)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'inform', text = 'Anda telah menukar '..jumlahchip..' Chip dan mendapatkan $'..harga})
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type = 'error', text = 'Anda tidak memiliki chip sebanyak itu!'})
        end
    end
end)