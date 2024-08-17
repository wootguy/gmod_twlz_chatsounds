--Horror, but client-side.

print("Clientside chatsounds started.")

local FlowerMaterial = Material("sprites/flower")

local FlowerPlayers = {}

net.Receive("DrawFlower", function(length)
    local player = net.ReadEntity()
    FlowerPlayers[player:AccountID()] = os.time()
end)

local function DrawFlower(player)
	if (!IsValid(player)) then return end 
 
	local Distance = LocalPlayer():GetPos():Distance(player:GetPos())
	
    if Distance < 2500 && FlowerPlayers[player:AccountID()] != nil then
        local currentTime = os.time()
        local addedTime = FlowerPlayers[player:AccountID()] + 4

        local offset = Vector(0, 0, 85)
	    local ang = LocalPlayer():EyeAngles()
	    local pos = player:GetPos() + offset + ang:Up()
	 
	    ang:RotateAroundAxis(ang:Forward(), 90)
	    ang:RotateAroundAxis(ang:Right(), 90)
	 
	    cam.Start3D()
            render.SetMaterial(FlowerMaterial)
		    render.DrawSprite(pos, 24, 24, color_white)
	    cam.End3D()

        if currentTime >= addedTime then
            FlowerPlayers[player:AccountID()] = nil
        end
    end
end

hook.Add("PostPlayerDraw", "DrawFlower", DrawFlower)