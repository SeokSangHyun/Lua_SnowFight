
local toy = Script.Parent



local function CollisionEvent(self, target)
    if target == nil or not target:IsMyCharacter() then;    return;    end;
    
    Game:SendEventToServer("CheckChairState_cTos", toy.Index)
    
    -- g_ConnectGate = toy
    
    -- Toggle_StardardPopup(true)
    -- Input:SetJoystickControlVisibility(0, false)
    -- LocalPlayer:SetEnableMovementControl(false)
end
toy.BoxCollider.Collision.OnCollisionEvent:Connect(CollisionEvent)
--toy.BoxCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)


