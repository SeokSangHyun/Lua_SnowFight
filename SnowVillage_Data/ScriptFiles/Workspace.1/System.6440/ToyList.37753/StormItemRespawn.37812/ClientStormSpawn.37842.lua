

local function StormItemSpawnComplete()
    Camera:PlayCameraShake(1.5, 10)
end
Game:ConnectEventFunction("StormItemSpawnComplete", StormItemSpawnComplete)

