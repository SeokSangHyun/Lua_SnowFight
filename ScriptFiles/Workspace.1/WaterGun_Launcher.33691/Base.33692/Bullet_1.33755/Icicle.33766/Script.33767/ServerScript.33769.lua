
local Object = Script.Parent.Parent
local FX = Object.FX.Guage
Object.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
--[[
local toy = Script.Parent.Parent.Parent
local ColFolder = toy.Trigger

--충돌 설정
ColFolder.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
ColFolder.GetCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)


local function GainItem(character)
    if character == nil or not character:IsCharacter() then;    return;    end;
    local player = character:GetPlayer()
    local playerID = player:GetPlayerID()
    
    g_PlayerList[ tostring(playerID) ]:GetItem(player, toy.ItemNum)

end
toy:ConnectEventFunction("GainItem", GainItem)

]]--

--[[
local function CollisionEvent(self, target)
    print("fx")
    HUD.MainUI.T_Log:SetText( target.Name )
    
    local fx = Game:CreateFX(FX, target.Location)
    fx:Play()
    
    wait(3)
    Game:DeleteFX(fx)
    Game:DeleteObject(self)
    
    if target == nil or not target:IsCharacter() then;    return;    end;
    
    --toy:SendEventToServer("GainItem")
end
Object.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)
]]--

