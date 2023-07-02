
local Toy = Script.Parent


local IsOn = true

local TotalTime = 5
local WaitTime = 0
local StartTime = time()


local TonadoDir = Vector.new(0,0,0)
local TonadoSpeed = 100



local function TornadoMove(player, dir)
    StartTime = time()
    WaitTime = 0
    
    TonadoDir = Vector.new(dir.X, dir.Y, 0)
end
Game:ConnectEventFunction("TornadoMove_cTos", TornadoMove)



local function UpdateEvent(updateTime)
    if IsOn then
        if WaitTime <= TotalTime then
            Toy.Location = Vector.new(Toy.Location.X + TonadoDir.X*TonadoSpeed*updateTime, Toy.Location.Y + TonadoDir.Y*TonadoSpeed*updateTime, 0)
            WaitTime = WaitTime + updateTime
        end
        
        
    end
    
end
Toy.OnUpdateEvent:Connect(UpdateEvent)
