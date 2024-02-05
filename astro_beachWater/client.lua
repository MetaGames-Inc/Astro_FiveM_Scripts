-- File: client.lua

local isWaterClear = true
local waveHeight = 0.0

RegisterCommand("watermenu", function()
    OpenWaterMenu()
end, false)

function OpenWaterMenu()
    local elements = {
        {label = "Toggle Water Clarity", value = "toggle_clarity"},
        {label = "Set Wave Height", value = "set_wave_height"}
        -- Aggiungi ulteriori opzioni del menu se necessario
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'water_menu', {
        title = 'Water Settings',
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
        local action = data.current.value

        if action == "toggle_clarity" then
            ToggleWaterClarity()
        elseif action == "set_wave_height" then
            SetWaveHeight()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function ToggleWaterClarity()
    isWaterClear = not isWaterClear
    if isWaterClear then
        SetWaterClearness(0.5) -- Valore tra 0.0 e 1.0 per la chiarezza dell'acqua
    else
        SetWaterClearness(0.0)
    end
end

function SetWaveHeight()
    local height = KeyboardInput("Enter Wave Height (0.0 - 10.0)", "", 3)
    waveHeight = tonumber(height)

    if waveHeight ~= nil then
        SetWaterWaveAmplitude(waveHeight)
    else
        ESX.ShowNotification("Invalid input. Please enter a number between 0.0 and 10.0.")
    end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    
    end
end)
