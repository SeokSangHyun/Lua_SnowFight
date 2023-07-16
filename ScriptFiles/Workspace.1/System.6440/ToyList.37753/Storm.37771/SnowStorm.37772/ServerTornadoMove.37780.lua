
local Item = Script.Parent


local IsOn = true

local TotalTime = 5
local WaitTime = 0
local StartTime = time()


local TonadoDir = Vector.new(0,0,0)
local TonadoSpeed = 100



function Item:TornadoMove(dir)
    StartTime = time()
    WaitTime = 0
    
    TonadoDir = Vector.new(dir.X, dir.Y, 0)
end



local function UpdateEvent(updateTime)
    if IsOn then
        if WaitTime <= TotalTime then
            Item.Location = Vector.new(Item.Location.X + TonadoDir.X*TonadoSpeed*updateTime, Item.Location.Y + TonadoDir.Y*TonadoSpeed*updateTime, Item.Location.Z)
            WaitTime = WaitTime + updateTime
        end
        
        
    end
    
end
Item.OnUpdateEvent:Connect(UpdateEvent)
