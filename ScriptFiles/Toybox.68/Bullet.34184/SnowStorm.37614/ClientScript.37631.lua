
local Toy = Script.Parent
local UI = Toy.ScreenUI





UI.F_Control.Left.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(0, -1, 0), 100)
end)




UI.F_Control.Right.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(0, 1, 0), 100)
end)








