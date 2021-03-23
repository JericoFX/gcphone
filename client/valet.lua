--[[


     ██╗███████╗██████╗ ██╗ ██████╗ ██████╗ ███████╗██╗  ██╗ ██╗ ██╗ ██████╗ ███████╗ ██╗██████╗ 
     ██║██╔════╝██╔══██╗██║██╔════╝██╔═══██╗██╔════╝╚██╗██╔╝████████╗╚════██╗██╔════╝███║╚════██╗
     ██║█████╗  ██████╔╝██║██║     ██║   ██║█████╗   ╚███╔╝ ╚██╔═██╔╝ █████╔╝███████╗╚██║ █████╔╝
██   ██║██╔══╝  ██╔══██╗██║██║     ██║   ██║██╔══╝   ██╔██╗ ████████╗ ╚═══██╗╚════██║ ██║██╔═══╝ 
╚█████╔╝███████╗██║  ██║██║╚██████╗╚██████╔╝██║     ██╔╝ ██╗╚██╔═██╔╝██████╔╝███████║ ██║███████╗
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚══════╝ ╚═╝╚══════╝
                                                                                                 

 ]]


local enroute = false
local mechPed = nil
local vehicle = {}
local vehhash = nil
function setCars(cars)
    SendNUIMessage({event = 'updateCars', cars = cars})
end

RegisterNUICallback('getCars', function(data)
    FXCore.Functions.TriggerCallback('gcPhone:getCars', function(data)
        for i = 1, #data do
            model = GetDisplayNameFromVehicleModel(data[i]["props"].model)
            data[i]["props"].model = model
        end
        setCars(data)
    end)
end)

RegisterNUICallback('getCarsValet', function(data)
    local plate = data.props.plate
    FXCore.Functions.TriggerCallback("Jerico:GetCarByPLate",function(vehicle)
    if enroute then
        FXCore.Functions.Notify(_U('valet_wait'))
        return
    end

    local gameVehicles = FXCore.Functions.GetVehicles()

	for i = 1, #gameVehicles do
		local vehicle = gameVehicles[i]

        if DoesEntityExist(vehicle) then
            if GetVehicleNumberPlateText(vehicle) == data.props.plate then
                local vehicleCoords = GetEntityCoords(vehicle)
                SetNewWaypoint(vehicleCoords.x, vehicleCoords.y)
				FXCore.Functions.Notify(_U('valet_already_outside'))
				return
			end
        end
    end

    TriggerServerEvent("gcPhone:valet-car-set-outside", data.props.plate)
        local driverhash = 999748158
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
      if vehicle ~= nil then
             vehhash = vehicle
 
         end

    while not HasModelLoaded(driverhash) and RequestModel(driverhash) or not HasModelLoaded(vehhash) and RequestModel(vehhash) do
        RequestModel(driverhash)
        RequestModel(vehhash)
        Citizen.Wait(0)
    end
    SpawnVehicle(playerPos.x, playerPos.y, playerPos.z, vehhash, driverhash, data.props)
    print(plate)
end,plate)

    Wait(2000)
    TriggerEvent("vehiclekeys:client:SetOwner",plate)
  --  TriggerEvent('vehiclekeys:client:ToggleEngine')
end)

function SpawnVehicle(x, y, z, vehhash, driverhash, props)       

    local found, spawnPos, spawnHeading = GetClosestVehicleNodeWithHeading(x + math.random(-100, 100), y + math.random(-100, 100), z, 0, 3, 0)
    local coordinates = {x=spawnPos.x,y=spawnPos.y,z=spawnPos.z, spawnHeading}
    FXCore.Functions.SpawnVehicle(vehhash,  function(callback_vehicle)
        SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)
        
        SetEntityAsMissionEntity(callback_vehicle, true, true)
        ClearAreaOfVehicles(GetEntityCoords(callback_vehicle), 5000, false, false, false, false, false);  
        SetVehicleOnGroundProperly(callback_vehicle)
        FXCore.Functions.SetVehicleProperties(callback_vehicle, props)
        
        mechPed = CreatePedInsideVehicle(callback_vehicle, 26, driverhash, -1, true, false)              		--Driver Spawning.
        
        mechBlip = AddBlipForEntity(callback_vehicle)                                                        	--Blip Spawning.
        SetBlipFlashes(mechBlip, true)  
        SetBlipColour(mechBlip, 5)
        SetVehicleEngineOn(vehhash,true)
        GoToTarget(x, y, z, callback_vehicle, mechPed, vehhash)
    end,coordinates)                          --Car Spawning.
end

function GoToTarget(x, y, z, vehicle, driver, vehhash, target)
    enroute = true
    while enroute do
        Citizen.Wait(500)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        SetDriverAbility(driver, 1.0)        -- values between 0.0 and 1.0 are allowed.
        SetDriverAggressiveness(driver, 0.0)
        TaskVehicleDriveToCoordLongrange(driver, vehicle, playerPos.x, playerPos.y, playerPos.z, 20.0, 0, 786468, 1)
        local distanceToTarget = #(playerPos - GetEntityCoords(vehicle))
        if distanceToTarget < 15 or distanceToTarget > 150 then
            RemoveBlip(mechBlip)
            TaskVehicleTempAction(driver, vehicle, 27, 6000)
            --SetVehicleUndriveable(vehicle, true)
            SetEntityHealth(mechPed, 2000)
            GoToTargetWalking(x, y, z, vehicle, driver)
            enroute = false
        end
    end
end

function GoToTargetWalking(x, y, z, vehicle, driver)
    Citizen.Wait(500)
    TaskWanderStandard(driver, 10.0, 10)
    TriggerServerEvent('gcPhone:finish')
    Citizen.Wait(35000)
    DeletePed(mechPed)
    mechPed = nil
end