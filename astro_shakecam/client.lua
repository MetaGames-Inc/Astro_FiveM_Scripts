local shakeDuration = 30000 -- Durata dello shake in millisecondi
local shakeAmplitude = 4.3 -- Ampiezza dello shake
local shakeCamEnabled = false

RegisterNetEvent('playerCrashed')
AddEventHandler('playerCrashed', function()
    shakeCamEnabled = true
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeAmplitude)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", true)
    StartScreenEffect("DeathFailOut", 0, true)

    -- Effetto di oscuramento
    SetNightvision(false)
    SetSeethrough(false)
    SetTimecycleModifier("blackout")
    
    Citizen.Wait(shakeDuration)
    shakeCamEnabled = false
    SetTimecycleModifier("")
    SetPedMotionBlur(PlayerPedId(), false)
    ResetPedMovementClipset(PlayerPedId(), 0.0)
    StopScreenEffect("DeathFailOut")

    -- Ripristino normale visibilità e effetti
    SetNightvision(false)
    SetSeethrough(false)
    SetTimecycleModifier("")
end)

Citizen.CreateThread(function()
        if shakeCamEnabled then
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeAmplitude)
            SetEntityLocallyInvisible(PlayerPedId())
            SetFarClipPlane(1000.0)
            SetEntityInvincible(PlayerPedId(), true)
            Citizen.Wait(100)
            SetEntityLocallyVisible(PlayerPedId())
            SetFarClipPlane(1.0)
            SetEntityInvincible(PlayerPedId(), false)
            Citizen.Wait(100)
        end
end)
