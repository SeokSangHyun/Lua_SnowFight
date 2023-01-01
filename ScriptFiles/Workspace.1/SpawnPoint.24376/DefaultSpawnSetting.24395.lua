local SpawnPoint = Script.Parent
local WaitSpawnPoint = Game:AddSpawnPoint(SpawnPoint)
local SpawnRadius = Script.SpawnRadius

WaitSpawnPoint:SetSpawnType(Enum.PointSpawnType.Area, SpawnRadius)

Game:SetUsingSpawnPoint(WaitSpawnPoint) -- 처음 실행 시 사용할 SpawnPoint 지정






