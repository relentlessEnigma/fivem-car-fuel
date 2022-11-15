-- set the car fuel to 100% when the car is sold in a car dealer
-- show the fuel level in screen when riding the car
-- if the player catches a car that is not associated to a player, randomize its fuel level from 15 to 100 %
--get the fuel the car has that the player is using at the moment and start decreasing it as the player is driving it. 
-- get the consumption level per mile and adjust it in the calculation

local playerPed = GetPlayerPed(-1)
local oc = GetEntityCoords(playerPed)
local distanceDriven = 0
local pedInVeh = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(player, false)
		if IsPedInAnyVehicle(player, false) then
			pedInVeh = true
		else
			pedInVeh = false
            oc = GetEntityCoords(playerPed)
		end
		if pedInVeh and GetIsVehicleEngineRunning(vehicle) == 1 then
            local nc = GetEntityCoords(playerPed)
            distanceDriven += GetDistanceBetweenCoords(nc.x, nc.y, nc.z, oc.x, oc.y, oc.z, false)
            oc = GetEntityCoords(playerPed)
            local actualFuel = GetVehicleFuelLevel(vehicle) --60
            local fuelAmount = actualFuel - (distanceDriven/100) * 0.7 -- this value is now hardcoded but should then be the consumption of each car
            SetVehicleFuelLevel(vehicle, fuelAmount)
            showMenu(GetVehicleFuelLevel(vehicle))
        end
        distanceDriven = 0
    end
end)

function showMenu(amount)
    SetTextScale(0.6, 0.6)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(false)
    AddTextComponentString('Fuel: ' .. string.format("%.0f", amount) .. "%")
    DrawText(0.825, 0.825)    
end
