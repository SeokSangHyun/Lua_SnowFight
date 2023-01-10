

local toy = Script.Parent



local function CollisionEvent(self, target)
    if target == nil then;    return;    end;
    
    g_ConnectGate[toy.Index] = target:GetPlayerID()

end
toy.BoxCollider.Collision.OnCollisionEvent:Connect(CollisionEvent)
--toy.BoxCollider.Collision.OnBeginOverlapEvent:Connect(CollisionEvent)


