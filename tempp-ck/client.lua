RegisterNetEvent('esx_ck:teleportToMorgue')
AddEventHandler('esx_ck:teleportToMorgue', function()
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, 3553.8027, 3685.1689, 28.1219, false, false, false, true)
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {'[Character Kill]', 'You have been sent to the morgue.'}
    })
end)