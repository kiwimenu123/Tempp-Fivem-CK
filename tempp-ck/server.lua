ESX = nil

-- Wait for ESX to load
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end

    -- Register the /ck command
    RegisterCommand('ck', function(source, args, rawCommand)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        -- Check if player has permission (e.g., admin)
        if xPlayer.getGroup() == 'admin' then
            if #args < 2 then
                TriggerClientEvent('chat:addMessage', src, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {'[ERROR]', 'Usage: /ck [playerID] [reason]'}
                })
                return
            end

            local targetId = tonumber(args[1])
            local reason = table.concat(args, ' ', 2)
            local targetPlayer = ESX.GetPlayerFromId(targetId)

            if targetPlayer then
                local targetIdentifier = targetPlayer.identifier
                local targetName = GetPlayerName(targetId)

                TriggerClientEvent('chat:addMessage', -1, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {'[Character Kill]', targetName .. ' has been killed by ' .. GetPlayerName(src) .. '. Reason: ' .. reason}
                })

                TriggerClientEvent('esx_ck:teleportToMorgue', targetId)

                -- Execute database query using oxmysql
                exports.oxmysql:execute('DELETE FROM users WHERE identifier = ?', {targetIdentifier}, function(rowsAffected)
                    if rowsAffected > 0 then
                        TriggerClientEvent('chat:addMessage', src, {
                            color = {0, 255, 0},
                            multiline = true,
                            args = {'[SUCCESS]', 'Character for ' .. targetName .. ' has been wiped.'}
                        })
                        -- Kick player to force character selection
                        DropPlayer(targetId, 'Your character has been killed. Please select or create a new character.')
                    else
                        TriggerClientEvent('chat:addMessage', src, {
                            color = {255, 0, 0},
                            multiline = true,
                            args = {'[ERROR]', 'Failed to wipe character for ' .. targetName}
                        })
                    end
                end)
            else
                TriggerClientEvent('chat:addMessage', src, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {'[ERROR]', 'Player with ID ' .. targetId .. ' not found.'}
                })
            end
        else
            TriggerClientEvent('chat:addMessage', src, {
                color = {255, 0, 0},
                multiline = true,
                args = {'[ERROR]', 'You do not have permission to use this command.'}
            })
        end
    end, false)
end)