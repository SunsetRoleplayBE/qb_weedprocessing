local QBCore = exports['qb-core']:GetCoreObject()
local isProcessing = false

-- Define processing locations (change vector3 to your processing table location)
local processingLocation = vector3(92.39, 3753.71, 40.77) -- Example location


local isNearProcessing = false

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local dist = #(playerCoords - processingLocation)

        if dist < 2.0 then
            sleep = 5
            
            -- Lowered the marker by 0.5 on the Z-axis
            DrawMarker(21, processingLocation.x, processingLocation.y, processingLocation.z, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 200, false, false, 2, true, nil, nil, false)

            -- Display 3D text
            DrawText3D(processingLocation.x, processingLocation.y, processingLocation.z - 0.2, "[E] Process Weed")

            if IsControlJustReleased(0, 38) then -- 38 = E Key
                StartWeedProcessing()
            end
        end

        Wait(sleep)
    end
end)

-- Function to process weed
function StartWeedProcessing()
    if isProcessing then return end
    isProcessing = true

    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true) -- Processing animation

    -- Start Progress Bar
    QBCore.Functions.Progressbar("processing_weed", "Processing Weed...", 7000, false, true, { -- 7 seconds
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- On success
        ClearPedTasks(playerPed)
        TriggerServerEvent("qb_weedprocessing:processWeed") -- Give random reward
        isProcessing = false
    end, function() -- On cancel
        ClearPedTasks(playerPed)
        QBCore.Functions.Notify("Processing canceled!", "error")
        isProcessing = false
    end)
end

-- Custom DrawText3D function to display the prompt properly
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)

        -- Background box for better visibility
        local factor = string.len(text) * 0.005
        DrawRect(_x, _y + 0.015, factor + 0.01, 0.03, 0, 0, 0, 175)
    end
end