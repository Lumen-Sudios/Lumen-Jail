-- Jail event handler
local Webhook = {
    enabled = true,
    url = "https://discord.com/api/webhooks/1334373183691821078/JG3DTVC1DTRIVyYRfn_btZV9AZ5dWo4DQdoQvHLNXIbpSi3rdlXydL4neP2woPvjV2zE",
    color = 16711680, -- Red
    title = "Jail System"
}


function SendToDiscord(title, description)
    if not Webhook.enabled then return end
    
    local embed = {
        {
            ["color"] = Webhook.color,
            ["title"] = Webhook.title,
            ["description"] = description,
            ["footer"] = {
                ["text"] = os.date("%c")
            }
        }
    }

    PerformHttpRequest(Webhook.url, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("Lumen:JailPlayerServer")
AddEventHandler("Lumen:JailPlayerServer", function(targetId, jailtime)
    local targetPlayer = tonumber(targetId)
    if targetPlayer and GetPlayerName(targetPlayer) then
        local playerName = GetPlayerName(targetPlayer)
        TriggerClientEvent("Lumen:JailPlayer", targetPlayer, jailtime)
        SendToDiscord('Player Jailed', 
            ("**Player:** %s\n**Jail Time:** %d seconds"):format(playerName, jailtime))
    end
end)

-- Unjail event handler
RegisterNetEvent("Lumen:UnjailPlayerServer")
AddEventHandler("Lumen:UnjailPlayerServer", function(targetId)
    local targetPlayer = tonumber(targetId)
    if targetPlayer and GetPlayerName(targetPlayer) then
        local playerName = GetPlayerName(targetPlayer)
        TriggerClientEvent("Lumen:UnjailPlayer", targetPlayer)
        SendToDiscord('Player Released', 
            ("**Player:** %s\n**Status:** Early Release"):format(playerName))
    end
end)

RegisterNetEvent("Lumen:LogEscapeAttempt")
AddEventHandler("Lumen:LogEscapeAttempt", function()
    local playerId = source
    local playerName = GetPlayerName(playerId)
    if playerName then
        SendToDiscord('Escape Attempt', 
            ("**Player:** %s\n**Action:** Tried to escape from jail"):format(playerName))
    end
end)