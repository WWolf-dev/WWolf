-- Pute your discord webhooks here to have log from wipe
local webhookUrl = "https://discord.com/api/webhooks/1136007542984691852/PnjjZgKxemzo4pvJwN9MVWTMt2hCN4LFLwoqOzLDre5tC1K1Gw_fVYGKR_xZBzbvMlsE"

function sendDiscordLog(payload)
    PerformHttpRequest(webhookUrl, function(statusCode, text, headers)
        if statusCode == 200 or 204 then
            print("Message envoyé sur Discord avec succès.")
        else
            print("Erreur lors de l'envoi du message sur Discord. Code de statut :", statusCode)
            print(text)
        end
    end, "POST", json.encode(payload), {["Content-Type"] = "application/json"})
end