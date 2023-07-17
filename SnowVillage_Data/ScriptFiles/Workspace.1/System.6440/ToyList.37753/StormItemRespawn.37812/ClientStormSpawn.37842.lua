

local function StormItemSpawnComplete()
    Camera:PlayCameraShake(1, 10)
end
Game:ConnectEventFunction("StormItemSpawnComplete", StormItemSpawnComplete)

