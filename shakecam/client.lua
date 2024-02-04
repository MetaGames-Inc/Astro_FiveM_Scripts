local shakeDuration = 2000 -- Durata dello shake in millisecondi
local shakeAmplitude = 1.2 -- Ampiezza dello shake

local shakeCamEnabled = false

RegisterNetEvent('playerCrashed')
AddEventHandler('playerCrashed', function()
    shakeCamEnabled = true
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeAmplitude)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", true)
    StartScreenEffect("DeathFailOut", 0, true)
    Citizen.Wait(shakeDuration)
    shakeCamEnabled = false
    SetTimecycleModifier("")
    SetPedMotionBlur(PlayerPedId(), false)
    ResetPedMovementClipset(PlayerPedId(), 0.0)
    StopScreenEffect("DeathFailOut")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if shakeCamEnabled then
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeAmplitude)
            local playerPed = PlayerPedId()
            SetEntityLocallyInvisible(playerPed)
            Citizen.Wait(100)
            SetEntityLocallyVisible(playerPed)
            Citizen.Wait(100)
        end
    end
end)