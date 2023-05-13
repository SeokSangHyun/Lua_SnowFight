

g_ConnectGate = nil
Root_Infomation = Workspace.System.InformSystem

--총알 전역 객체
--[[
g_BulletSnowBall = Game:CreateObject(Toybox.SpawnItem.SnowBall.Mesh.Item)
g_BulletIcicle = Game:CreateObject(Toybox.SpawnItem.Icicle.Mesh.Item)
g_BulletSnowCrystals = Game:CreateObject(Toybox.SpawnItem.SnowCrystals.Mesh.Item)
]]--

wait(3)
local function ChangeReplicateValue(self, value) -- value : 변화한 값
    Update_InformUI()
end
Game:ConnectChangeEventFunction("GameTime", ChangeReplicateValue)


