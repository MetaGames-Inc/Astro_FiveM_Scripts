local shakeDuration  = 500
local shakeAmplitude = 1.1

function ShakeCamera()
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeAmplitude)
    Wait(shakeDuration)
    StopGameplayCamShaking(true)
end

RegisterNetEvent('incidente')
AddEventHandler('incidente', function()
    ShakeCamera()
end)
-- Chiamare questo codice quando si verifica un incidente
TriggerEvent('incidente')
