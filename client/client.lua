local player = GetPlayerPed(-1)
local oc = GetEntityCoords(playerPed)
local nc
local distanceDriven = 0
local pedInVeh = false
local isRunning = false
local hasFuelNotBeenCalculated = true
local carFuel = 100
local carConsumption = 7
local wasFuelNotSavedYet = false

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local vehicle = GetVehiclePedIsIn(player, false)
        local carPlate = GetVehicleNumberPlateText(vehicle)

		if IsPedInAnyVehicle(player, false) then
			pedInVeh = true
		else
			pedInVeh = false
            oc = GetEntityCoords(player)
		end
		if pedInVeh and GetIsVehicleEngineRunning(vehicle) == 1 then
            if(hasFuelNotBeenCalculated) then

                local props = ESX.Game.GetVehicleProperties(vehicle)
                local carModel = GetDisplayNameFromVehicleModel(props.model):lower()

                ESX.TriggerServerCallback('CarFuel:GetInfoSV', function(fuel, consumos)
                    carFuel = fuel
                    carConsumption = consumos
                    isRunning = false
                end, carPlate, carModel)
                
                isRunning = true
                while isRunning do
                    Wait(200)
                end
                hasFuelNotBeenCalculated = false
            end    
            nc = GetEntityCoords(player)
            distanceDriven += GetDistanceBetweenCoords(nc.x, nc.y, nc.z, oc.x, oc.y, oc.z, false)
            oc = GetEntityCoords(player)
            SetVehicleFuelLevel(vehicle, carFuel)

            carFuel = carFuel - (distanceDriven/100) * (carConsumption/10)
            
            ESX.Game.SetVehicleProperties(vehicle, { fuelLevel = carFuel })
            showMenu(carFuel)
            wasFuelNotSavedYet = true
        else
            if(carPlate ~= nil and wasFuelNotSavedYet) then
                TriggerServerEvent('CarFuel:SaveFuel', carFuel, carPlate)
                wasFuelNotSavedYet = false
            end
            hasFuelNotBeenCalculated = true
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