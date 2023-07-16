
local UI = UIRoot.StormUI



--!---------------------------- <> ------------------------------
function Toggle_UI(state)
    UI.Visible = state
end




--!---------------------------- <> ------------------------------






--!---------------------------- <> ------------------------------
UI.F_Control.Left.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(0, -1, 0))
end)



UI.F_Control.Right.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(0, 1, 0))
end)



UI.F_Control.Top.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(1, 0, 0))
end)



UI.F_Control.Down.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(-1, 0, 0))
end)






--!---------------------------- <> ------------------------------
UI.F_Control.LT.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(1, -1, 0))
end)



UI.F_Control.RT.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(1, 1, 0))
end)



UI.F_Control.LD.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(-1, -1, 0))
end)



UI.F_Control.RD.OnPressEvent:Connect(function(self)
    Game:SendEventToServer("TornadoMove_cTos", Vector.new(-1, 1, 0))
end)





