-- Horrible piece of code
print("Chatsounds started.")

local AllSounds, _ = file.Find("sound/*.wav", "TWLZ Chat Sounds")
local SoundDictionary = {}
local PlayerTimers = {}

util.AddNetworkString("DrawFlower")

for i, j in pairs(AllSounds) do
    resource.AddFile(AllSounds[i])
    local substring = string.sub(AllSounds[i], 1, -5)
    SoundDictionary[substring] = AllSounds[i]
end

concommand.Add("list_chatsounds", function()
    PrintTable(SoundDictionary)
end)

local function HandleSound(plyer, sound)
    for l, m in pairs(PlayerTimers) do
        if l == plyer:AccountID() then
            if m == true then
                return false
            end
        end
    end

    if plyer:Alive() then
        plyer:EmitSound(sound, 70, 100, 0.80, CHAN_AUTO)
    else
        plyer:EmitSound(sound, 0, 100, 0.80, CHAN_AUTO)
    end

    PlayerTimers[plyer:AccountID()] = true
    timer.Simple(5, function()
        PlayerTimers[plyer:AccountID()] = false
    end)

    for k, v in ipairs(player.GetAll()) do
        net.Start("DrawFlower")
            net.WriteEntity(plyer)
        net.Send(v)
    end

    return true
end

hook.Add("PlayerSay", "HandleChatSound", function(sender, text, team)
    if team == false then
        for k, v in pairs(SoundDictionary) do
            local allWords = string.Split(text, " ")
            if string.lower(allWords[1]) == k then
                if HandleSound(sender, v) == false then
                    sender:ChatPrint("[CHATSOUNDS] Please wait 5 seconds between each chat sound!")
                end
                return text
            end
        end
    end
end)