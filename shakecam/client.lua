local shakeDuration  = 500
local shakeAmplitude = 1.1
local shakeCamEnabled = true

RegisterNetEvent('pkayterCrashed') 
AddEventHandler('playerCrashed', function()
    shakeCamEnabled = true
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeAmplitude)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(PlayerPedId(), true)

    SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", true)
    Citizen.Wait(shakeDuration)
    shakeCamEnabled = false 
    SetTimecycleModifier("")
    SetPedMotionBlur(PlayerPedId(), false) 
    ResetPedMovementClipset(PlayerId(), 0.0)
 end
)

Citizen.CreateThread(function()
     while true do 
        Citizen.Wait(0)
        if shakeCamEnabled then 

            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeAmplitude) 
            local playerPed = PlayerPedId()
            SetEntityLocallyInvisible(playerPed) 
            Citizen.Wait(100) 
            SetEntityLocallyInvisible(playerPed)
            Citizen.Wait(100)

end
end
end
)