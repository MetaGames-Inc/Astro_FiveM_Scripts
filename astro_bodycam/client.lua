local bodycamActive = false
local cameraHandle = nil
local videoNumber = math.random(100000000,999999999)
local bwvAllowed = false

local toggleOnDraw = true -- If true will toggle bodycam on when player draws their taser.

local policeJobs = { 'police', 'sheriff', 'highway' } -- Lista dei lavori polizia

local fogDensity = 0.0
local fogMaxDensity = 4.0
local fogStep = 0.1

local videoQuality = "HD" -- Impostazione predefinita della qualità del video
local videoResolution = {
    ["HD"] = { width = 1280, height = 720 },
    -- Altre risoluzioni possono essere aggiunte secondo necessità
}

local videoRecording = false
local videoFileName = ""

local playerLocked = false

RegisterCommand("bwv", function(source, args, rawCommand)
    local playerJob = ESX.PlayerData.job.name -- Assumi che stai utilizzando ESX per ottenere il lavoro del giocatore
    if IsJobAllowed(playerJob) then
        bwvAllowed = not bwvAllowed
        if bwvAllowed then
            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 6, "bodyOn", 0.3)
            ShowNotification("Your bodycam is now ~g~activated~s~.")
        else
            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 6, "bodyOff", 0.3)
            ShowNotification("Your bodycam is now ~r~deactivated~s~.")
        end
    else
        ShowNotification("You are not authorized to use the bodycam.")
    end
end)

RegisterKeyMapping('bwv', 'Toggle Bodycam', 'keyboard', '')

RegisterCommand("bwview", function(source, args, rawCommand)
    local playerJob = ESX.PlayerData.job.name -- Assumi che stai utilizzando ESX per ottenere il lavoro del giocatore
    if not IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) and bwvAllowed and IsJobAllowed(playerJob) then
        if bodycamActive then
            Disablebody()
        else
            Enablebody()
        end
    end
end)

RegisterKeyMapping('bwview', 'Toggle Bodycam View', 'keyboard', '')

RegisterCommand("bwfog", function(source, args, rawCommand)
    local option = tonumber(args[1])
    if option == nil then
        ShowNotification("Usage: /bwfog [0-4] (0 for clear, 4 for heavy fog)")
    elseif option >= 0 and option <= 4 then
        SetFogDensity(option * fogStep)
        fogDensity = option * fogStep
    else
        ShowNotification("Invalid fog density. Use a value between 0 and 4.")
    end
end)

RegisterCommand("bwrecord", function(source, args, rawCommand)
    if bwvAllowed and bodycamActive then
        if not videoRecording then
            StartRecording()
        else
            StopRecording()
        end
    else
        ShowNotification("Cannot record while bodycam is inactive or not allowed.")
    end
end)

RegisterCommand("bwquality", function(source, args, rawCommand)
    local qualityOption = args[1]
    if qualityOption then
        SetVideoQuality(qualityOption)
    else
        ShowNotification("Usage: /bwquality [HD/720p/...] (Specify the desired video quality)")
    end
end)

RegisterCommand("bwlock", function(source, args, rawCommand)
    TogglePlayerLock()
end)

RegisterCommand("bwbrightness", function(source, args, rawCommand)
    local brightnessLevel = tonumber(args[1])
    if brightnessLevel and brightnessLevel >= 0 and brightnessLevel <= 100 then
        SetBrightness(brightnessLevel)
    else
        ShowNotification("Usage: /bwbrightness [0-100] (Specify the desired brightness level)")
    end
end)

RegisterCommand("bwcontrast", function(source, args, rawCommand)
    local contrastLevel = tonumber(args[1])
    if contrastLevel and contrastLevel >= 0 and contrastLevel <= 100 then
        SetContrast(contrastLevel)
    else
        ShowNotification("Usage: /bwcontrast [0-100] (Specify the desired contrast level)")
    end
end)

RegisterCommand("bwshare", function(source, args, rawCommand)
    ShowNotification("Video sharing feature disabled.")
end)

RegisterNetEvent("oBodycam:bodycamOn")

AddEventHandler("oBodycam:bodycamOn", function()
    local playerJob = ESX.PlayerData.job.name -- Assumi che stai utilizzando ESX per ottenere il lavoro del giocatore
    if not bwvAllowed and IsJobAllowed(playerJob) then
        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 6, "bodyOn", 0.3)
        ShowNotification("Your bodycam is now ~g~activated~s~.")
        bwvAllowed = true
    end
end)

Citizen.CreateThread(function()
    while true do
        if bwvAllowed then
            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 6, "bodyOn", 0.3)
            ShowNotification("Your bodycam is still ~r~recording~s~.")
        end
        Citizen.Wait(120000)
    end
end)

Citizen.CreateThread(function()
    while true do
        if bodycamActive then
            if bodycamActive and IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) then
                Disablebody()
                bodycamActive = false
            end
            if not IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) and bodycamActive then
                Updatebodycam()
            end
        end
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerLocked then
            DisableControlAction(0, 1, true) -- Movimento in avanti
            DisableControlAction(0, 2, true) -- Movimento indietro
            DisableControlAction(0, 142, true) -- Fumo / Ragdoll / Azione speciale
            DisableControlAction(0, 18, true) -- Enter / Cancella / Azione speciale secondaria
            DisableControlAction(0, 322, true) -- Tasto di arresto
            DisableControlAction(0, 106, true) -- Tasto di arresto in veicolo
        end
    end
end)

function Enablebody()
    SetTimecycleModifier("scanline_cam_cheap")
    SetTimecycleModifierStrength(1.5)
    SendNUIMessage({
        type = "enablebody"
    })
    bodycamActive = true
end

function Disablebody()
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFollowPedCamViewMode(0)
    SendNUIMessage({
        type = "disablebody"
    })
    bodycamActive = false
end

function Updatebodycam()
    local gameTime = GetGameTimer()
    local year, month, day, hour, minute, second = GetLocalTime() 
    
    SendNUIMessage({
        type = "updatebody",
        info = {
            gameTime = gameTime,
            clockTime = {year = year, month = month, day = day, hour = hour, minute = minute, second = second},
            videoNumber = videoNumber
        }
    })
end

function ShowNotification(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function IsJobAllowed(job)
    for _, allowedJob in ipairs(policeJobs) do
        if job == allowedJob then
            return true
        end
    end
    return false
end

function StartRecording()
    local resolution = videoResolution[videoQuality] or { width = 1280, height = 720 }
    local fileName = "bwv_" .. os.time() .. "_" .. math.random(1000, 9999) .. ".webm"
    
    StartResourceRecording(fileName, true)
    videoRecording = true
    videoFileName = fileName
    ShowNotification("Recording started. File: " .. fileName)
end

function StopRecording()
    StopResourceRecording()
    videoRecording = false
    ShowNotification("Recording stopped. File saved: " .. videoFileName)
end

function SetVideoQuality(qualityOption)
    if videoResolution[qualityOption] then
        videoQuality = qualityOption
        ShowNotification("Video quality set to: " .. qualityOption)
    else
        ShowNotification("Invalid video quality option. Available options: HD, 720p, ...")
    end
end

function TogglePlayerLock()
    playerLocked = not playerLocked
    if playerLocked then
        ShowNotification("Player locked. Use /bwlock again to unlock.")
    else
        ShowNotification("Player unlocked.")
    end
end

function SetBrightness(brightnessLevel)
    SetTimecycleModifierStrength(brightnessLevel / 100.0)
    ShowNotification("Brightness set to: " .. brightnessLevel .. "%")
end

function SetContrast(contrastLevel)
    SetTimecycleModifierStrength(contrastLevel / 100.0)
    ShowNotification("Contrast set to: " .. contrastLevel .. "%")
end
