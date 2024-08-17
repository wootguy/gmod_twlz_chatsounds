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

local function HandleSound(plyer, sound, pitch)
    for l, m in pairs(PlayerTimers) do
        if l == plyer:AccountID() then
            if m == true then
                --return false
            end
        end
    end

    plyer:EmitSound(sound, 70, pitch, 0.80, CHAN_VOICE2)

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
        local allWords = string.Split(text, " ")
        local pitch = 100
		
		if #allWords > 1 then
			pitch = tonumber(allWords[2]);
			
			if pitch != nil then
				if pitch > 255 then
					pitch = 255
				end
				if pitch < 10 then
					pitch = 10
				end
			else
				pitch = 100
			end
		end
		
		if string.lower(allWords[1]) == "." then
			HandleSound(sender, "null.wav", 100)
			return text
		end
		
        for k, v in pairs(SoundDictionary) do
            if string.lower(allWords[1]) == k then
                if HandleSound(sender, v, pitch) == false then
                    sender:ChatPrint("[CHATSOUNDS] Please wait 5 seconds between each chat sound!")
                end
                return text
            end
        end
    end
end)