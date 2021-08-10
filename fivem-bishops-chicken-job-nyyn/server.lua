ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'bishops', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'bishops', 'bishops', 'society_bishops', 'society_bishops', 'society_bishops', {type = 'public'})

RegisterServerEvent('nyyn_bishops:zbierajkurczak1')
AddEventHandler('nyyn_bishops:zbierajkurczak1', function(zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local itemQuantity = xPlayer.getInventoryItem('kurczak1').count
	
	if itemQuantity == 50 or itemQuantity > 50 then
		TriggerClientEvent("pNotify:SendNotification", _source, {
            text = 'Nie masz już miejsca na kurczaki',
            type = "error",
            timeout = 2500,
            layout = "topRight"
        })
	return
	end
	
		PlayersHarvesting[_source]=true
		TriggerClientEvent('nyyn_bishops:zbierajkurczak12', source)
			end)




RegisterServerEvent('nyyn_bishops:zbierajkurczak13')
AddEventHandler('nyyn_bishops:zbierajkurczak13', function(zone)
local _source = source
local xPlayer  = ESX.GetPlayerFromId(source)
local itemQuantity = xPlayer.getInventoryItem('kurczak1').count

	Citizen.Wait(10000)
	xPlayer.addInventoryItem('kurczak1', 5)
end)



RegisterServerEvent('nyyn_bishops:przerobkurczak12')
AddEventHandler('nyyn_bishops:przerobkurczak12', function(zone)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	local kurczak1 = xPlayer.getInventoryItem('kurczak1').count
	local kurczak2 = xPlayer.getInventoryItem('kurczak2').count
			
if kurczak1 < 10 then
	TriggerClientEvent("pNotify:SendNotification", _source, {
		text = 'Nie posiadasz wystarczającej ilości surowych kurczakow do usmazenia kurczakow.',
		type = "error",
         timeout = 2500,
         layout = "topRight"
	})

elseif kurczak2 == 5 or kurczak2 > 5 then

	TriggerClientEvent("pNotify:SendNotification", _source, {
		text = 'Masz już wystarczającą ilość smazonych kurczakow.',
		type = "error",
         timeout = 2500,
        layout = "topRight"
	})
return
else
PlayersHarvesting[_source]=true
TriggerClientEvent('nyyn_bishops:przerobkurczak13', source)
end
end)
	
			


RegisterServerEvent('nyyn_bishops:przerobkurczak14')
AddEventHandler('nyyn_bishops:przerobkurczak14', function(zone)
local _source = source
local xPlayer  = ESX.GetPlayerFromId(source)


	Citizen.Wait(10000)
	xPlayer.removeInventoryItem('kurczak1', 10)
	xPlayer.addInventoryItem('kurczak2', 1)

end)




RegisterServerEvent('nyyn_bishops:stopHarvest')
AddEventHandler('nyyn_bishops:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false

	end
end)

RegisterServerEvent('nyyn_bishops:stopTransform')
AddEventHandler('nyyn_bishops:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		
	else
		PlayersTransforming[_source]=true
		
	end
end)


RegisterServerEvent('nyyn_bishops:startSell')
AddEventHandler('nyyn_bishops:startSell', function(zone)
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(source)
		local kurczak2 = xPlayer.getInventoryItem('kurczak2').count
		
if kurczak2 < 1 then
	TriggerClientEvent("pNotify:SendNotification", _source, {
		text = 'Nie posiadasz więcej kurczakow na sprzedaz.',
		type = "error",
		timeout = 2500,
		layout = "topRight"
	})

	return
end
		PlayersHarvesting[_source]=true
		TriggerClientEvent('nyyn_bishops:startSell2', source)
end)


RegisterServerEvent('nyyn_bishops:startSell3')
AddEventHandler('nyyn_bishops:startSell3', function(zone)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(source)

    Citizen.Wait(10000)
    local reward = math.random(900,1000)
    xPlayer.removeInventoryItem('kurczak2', 1)
    xPlayer.addMoney(reward)
end)