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


local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local JobBlips                = {}
local publicBlip = false
local CzyJest                 	= false
ESX                             = nil
GUI.Time                        = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function TeleportFadeEffect(entity, coords)

	Citizen.CreateThread(function()

		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)

	end)
end


function OpenVehicleSpawnerMenu()
local model = 'vwcaddy'
		
ESX.Game.SpawnVehicle(model, Config.Zones.VehicleSpawnPoint.Pos, 335.6, function(vehicle)
	local playerPed = GetPlayerPed(-1)
	TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
end)
CurrentAction     = 'vehicle_spawner_menu'
CurrentActionData = {}
end


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	blips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	blips()
end)


AddEventHandler('nyyn_bishops:hasEnteredMarker', function(zone)
	local playerPed = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(player,false)
	
	if zone == 'kurczak1' and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' and not IsPedInAnyVehicle(playerPed, false) then	

		CurrentAction     = 'kurczak1'
		ESX.ShowNotification('~o~[E] ~w~Aby zbierac kurczaki', 8)
		CurrentActionData = {zone= zone}

	end
		
	if zone == 'kurczak2' and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'kurczak2'
		ESX.ShowNotification('~o~[E] ~w~Aby usmazyc kurczaki', 8)
		CurrentActionData = {zone= zone}
	end
			
	if zone == 'SellFarm' and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'farm_resell'
		ESX.ShowNotification('~o~[E] ~w~Aby sprzedac kurczaki', 8)
		CurrentActionData = {zone = zone}
	end

	if zone == 'bishopsakcje' and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' and not IsPedInAnyVehicle(playerPed, false) then
		CurrentAction     = 'piekarz_actions_menu'
		ESX.ShowNotification('~o~[E] ~w~Aby się przebrać', 8)
		CurrentActionData = {}
	end
  
	if zone == 'VehicleSpawner' and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then
		CurrentAction     = 'vehicle_spawner_menu'
		ESX.ShowNotification('~o~[E] ~w~Aby zabrać samochód', 8)
		CurrentActionData = {}
	end
		
	if zone == 'VehicleDeleter' and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then

		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)
		
		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle, distance = ESX.Game.GetClosestVehicle({
				x = coords.x,
				y = coords.y,
				z = coords.z
			})

			if distance ~= -1 and distance <= 1.0 then

				CurrentAction     = 'delete_vehicle'
				ESX.ShowNotification('~o~[E] ~w~Aby schować samochód', 8)
				CurrentActionData = {vehicle = vehicle}

			end
		end
	end
end)

AddEventHandler('nyyn_bishops:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	
	if (zone == 'kurczak1') and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then
		TriggerServerEvent('nyyn_bishops:stopHarvest')
	end  

	if (zone == 'kurczak2') and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then
		TriggerServerEvent('nyyn_bishops:stopTransform')
	end
	
	if (zone == 'SellFarm') and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then
		TriggerServerEvent('nyyn_bishops:stopSell')
	end
	CurrentAction = nil
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
		RemoveBlip(JobBlips[i])
		JobBlips[i] = nil
		end
	end
end

function blips()

    if PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then

		for k,v in pairs(Config.Blipkurczaczki)do
			if v.Type == -1 then
				local blip2 = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

				SetBlipSprite (blip2, 353)
				SetBlipDisplay(blip2, 4)
				SetBlipScale  (blip2, 0.8)
				SetBlipColour (blip2, 1)
				SetBlipAsShortRange(blip2, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.Name)
				EndTextCommandSetBlipName(blip2)
				table.insert(JobBlips, blip2)
			end
		end

		for k,v in pairs(Config.Blipkurczaczki2)do
			if v.Type == 27 then
				local blip3 = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

				SetBlipSprite (blip3, 353)
				SetBlipDisplay(blip3, 4)
				SetBlipScale  (blip3, 0.8)
				SetBlipColour (blip3, 1)
				SetBlipAsShortRange(blip3, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.Name)
				EndTextCommandSetBlipName(blip3)
				table.insert(JobBlips, blip3)
			end
		end

		for k,v in pairs(Config.JebacToGownoEs)do
			if v.Type == 32 then
				local blip4 = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

				SetBlipSprite (blip4, 478)
				SetBlipDisplay(blip4, 4)
				SetBlipScale  (blip4, 0.8)
				SetBlipColour (blip4, 75)
				SetBlipAsShortRange(blip4, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.Name)
				EndTextCommandSetBlipName(blip4)
				table.insert(JobBlips, blip4)
			end
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Wait(5)
		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				

				end
			end
		end
		for k,v in pairs(Config.JebacToGownoEs) do
			if PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				

				end
			end
		end

	end
end)

Citizen.CreateThread(function()
	while true do

		Wait(5)

		if PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then

			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			for k,v in pairs(Config.JebacToGownoEs) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('nyyn_bishops:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('nyyn_bishops:hasExitedMarker', LastZone)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(5)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                        DrawMarker(27, Config.Zones.kurczak1.Pos.x, Config.Zones.kurczak1.Pos.y, Config.Zones.kurczak1.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 25, 0, 0, 100, false, true, 2, false, nil, nil, false)
                        DrawMarker(27, Config.Zones.kurczak2.Pos.x, Config.Zones.kurczak2.Pos.y, Config.Zones.kurczak2.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 25, 0, 0, 100, false, true, 2, false, nil, nil, false)
                        DrawMarker(27, Config.Zones.SellFarm.Pos.x, Config.Zones.SellFarm.Pos.y, Config.Zones.SellFarm.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 25, 0, 0, 100, false, true, 2, false, nil, nil, false)

			if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'bishops' then
				if CurrentAction == 'kurczak1' then
					TriggerServerEvent('nyyn_bishops:zbierajkurczak1', CurrentActionData.zone)
				end

				if CurrentAction == 'kurczak2' then
					TriggerServerEvent('nyyn_bishops:przerobkurczak12', CurrentActionData.zone)
				end
			
				
				if CurrentAction == 'farm_resell' then
					TriggerServerEvent('nyyn_bishops:startSell', CurrentActionData.zone)
				end
				
				if CurrentAction == 'vehicle_spawner_menu' then
					OpenVehicleSpawnerMenu()
				end
				if CurrentAction == 'delete_vehicle' then

					if Config.EnableSocietyOwnedVehicles then
						local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
						TriggerServerEvent('esx_society:putVehicleInGarage', 'bishops', vehicleProps)
					end

					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end
				CurrentAction = nil
			end
		end
	end
end)



function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(scale, scale)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextEntry("STRING")
  SetTextCentre(1)
  SetTextColour(255, 255, 255, 255)
  SetTextOutline()

  AddTextComponentString(text)
  DrawText(_x, _y)

  local factor = (string.len(text)) / 270
  DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 0, 0, 0, 55)
end

function procent(time)
	TriggerEvent('bishops:procenty')
	TimeLeft = 0
	repeat
	TimeLeft = TimeLeft + 1
	Citizen.Wait(time)
	until(TimeLeft == 100)
	CzyJest = false
	cooldownclick = false
end


RegisterNetEvent('bishops:procenty')
AddEventHandler('bishops:procenty', function()
  CzyJest = true
    while (CzyJest) do
      Citizen.Wait(8)
      local playerPed = PlayerPedId()
      local coords = GetEntityCoords(playerPed)
      DrawText3D(coords.x, coords.y, coords.z, TimeLeft .. '~o~%', 0.4)
    end
end)

function animka1()
	local dict = "mini@repair"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "fixing_a_ped", 8.0, 8.0, 10000, 1, 0, false, false, false)
end


function animka2()
	local dict = "amb@prop_human_bum_bin@idle_b"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(7200)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "idle_d", 8.0, 8.0, 10000, 1, 0, false, false, false)

end

function animka4()
	local dict = "mp_am_hold_up"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "purchase_beerbox_shopkeeper", 8.0, 8.0, 10000, 1, 0, false, false, false)
end




RegisterNetEvent('nyyn_bishops:zbierajkurczak12')
AddEventHandler('nyyn_bishops:zbierajkurczak12', function()

	FreezeEntityPosition(PlayerPedId(), true)
	animka1()
	TriggerServerEvent('nyyn_bishops:zbierajkurczak13')
	procent(95)
	FreezeEntityPosition(PlayerPedId(), false)
	HasAlreadyEnteredMarker, LastZone = true, currentZone


end)


RegisterNetEvent('nyyn_bishops:przerobkurczak13')
AddEventHandler('nyyn_bishops:przerobkurczak13', function()

	FreezeEntityPosition(PlayerPedId(), true)
	animka2()
	TriggerServerEvent('nyyn_bishops:przerobkurczak14')
	procent(100)
	FreezeEntityPosition(PlayerPedId(), false)
	HasAlreadyEnteredMarker, LastZone = true, currentZone


end)


RegisterNetEvent('nyyn_bishops:startSell2')
AddEventHandler('nyyn_bishops:startSell2', function()

	FreezeEntityPosition(PlayerPedId(), true)
	animka4()
	TriggerServerEvent('nyyn_bishops:startSell3')
	procent(95)
	FreezeEntityPosition(PlayerPedId(), false)
	HasAlreadyEnteredMarker, LastZone = true, currentZone


end)
