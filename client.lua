local IsJailed = false
local EarlyRelease = false
local JailCoords = vector3(1677.233, 2658.618, 45.216)
local MaxDistance = 50.0 -- Maximum distance the player can wander from the jail center
local TimeAddedForEscape = 60 -- Seconds added for escape attempts
local HasAttemptedEscape = false -- New variable to track escape attempts

RegisterNetEvent("Lumen:JailPlayer")
AddEventHandler("Lumen:JailPlayer", function(jailtime)
    if IsJailed then return end
    
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        Citizen.CreateThread(function()
            SetEntityCoords(playerPed, JailCoords)
            IsJailed = true
            EarlyRelease = false
            HasAttemptedEscape = false -- Reset escape attempt flag
            
            while jailtime > 0 and not EarlyRelease do
                playerPed = PlayerPedId()
                RemoveAllPedWeapons(playerPed, true)
                SetEntityInvincible(playerPed, true)
                
                if IsPedInAnyVehicle(playerPed, false) then
                    ClearPedTasksImmediately(playerPed)
                end
                
                if jailtime % 30 == 0 then
                    lib.notify({
                        title = 'Jail Time Remaining',
                        description = math.floor(jailtime) .. " seconds left until release.",
                        type = 'inform'
                    })
                end
                
                Citizen.Wait(500)
                
                -- Only check distance if not being released
                if not EarlyRelease then
                    local playerLoc = GetEntityCoords(playerPed, true)
                    local distance = #(JailCoords - playerLoc)
                    
                    if distance > MaxDistance then
                        SetEntityCoords(playerPed, JailCoords)
                        jailtime = jailtime + TimeAddedForEscape
                        if jailtime > 1500 then
                            jailtime = 1500
                        end
                        if not HasAttemptedEscape then
                            lib.notify({
                                title = 'Escape Attempt',
                                description = "Your jail time was extended by " .. TimeAddedForEscape .. " seconds because you tried to escape.",
                                type = 'error'
                            })
                            TriggerServerEvent("Lumen:LogEscapeAttempt")
                            HasAttemptedEscape = true
                        end
                    end
                end
                
                jailtime = jailtime - 0.5
            end
            
            -- Release the player
            SetEntityCoords(playerPed, 1849.0, 2585.0, 45.0)
            SetEntityHeading(playerPed, 265.0)
            IsJailed = false
            SetEntityInvincible(playerPed, false)
            lib.notify({
                title = 'Released',
                description = "You have been released from jail.",
                type = 'success'
            })
        end)
    end
end)

RegisterNetEvent("Lumen:UnjailPlayer")
AddEventHandler("Lumen:UnjailPlayer", function()
    EarlyRelease = true
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 1849.0, 2585.0, 45.0)
    SetEntityHeading(playerPed, 265.0)
    IsJailed = false
    SetEntityInvincible(playerPed, false)
    lib.notify({
        title = 'Early Release',
        description = "You have been released from jail early.",
        type = 'success'
    })
end)

function LumenJailPlayerFromGUI(targetId, jailtime)
    TriggerServerEvent("Lumen:JailPlayerServer", targetId, jailtime)
end

function LumenUnJailPlayerFromGUI(targetId)
    TriggerServerEvent("Lumen:UnjailPlayerServer", targetId)
end

exports("LumenJailPlayerFromGUI", LumenJailPlayerFromGUI)
exports("LumenUnJailPlayerFromGUI", LumenUnJailPlayerFromGUI)