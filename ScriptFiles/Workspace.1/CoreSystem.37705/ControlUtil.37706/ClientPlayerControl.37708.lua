
PlayerControl = Script.Parent

--! ------------------------------ <> ------------------------------
function PlayerControl:SetMoveControl(state)
    LocalPlayer:SetEnableMovementControl(state)
end
PlayerControl:ConnectEventFunction("SetMoveControl", function(state)    PlayerControl:SetMoveControl(state)    end)












