
local toy = Script.Parent.Parent

local IsEquip = false




--!---------------------------- Getter/Setter ------------------------------
--[[
local function Script:SetIsEquip(state)
    IsEquip = state
end

]]--




--!---------------------------- Getter/Setter ------------------------------
--[[
local function CollisionEvent(self, target)
    if target == nil or not target:IsCharacter() then;    return;    end;

    local targetID = target:GetPlayerID()
    local myID = LocalPlayer:GetRemotePlayer()


    if PID == 0 or targetID == myID or target:IsMyCharacter() then;
        PID = targetID
        return;
    end
    
    g_Player:HitMyPlayer(target, bulletIndex)
    local fx = Game:CreateFX(FX, self.Location)
    fx:Play()
    
    
    Game:DeleteObject(self)
end
toy.HitCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)
]]--




