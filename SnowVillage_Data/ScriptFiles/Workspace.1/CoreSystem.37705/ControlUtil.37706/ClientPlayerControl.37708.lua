
PlayerControl = Script.Parent

--! ------------------------------ <> ------------------------------
--# -----요약 : 
function PlayerControl:SetCharacterControl(state)
    LocalPlayer:SetEnableMovementControl(state)
    LocalPlayer:GetEnableCameraControl(state)
end
PlayerControl:ConnectEventFunction("SetCharacterControl", function(state)    PlayerControl:SetCharacterControl(state)    end)



--# -----요약 : 
function PlayerControl:SetMoveControl(state)
    LocalPlayer:SetEnableMovementControl(state)
end
PlayerControl:ConnectEventFunction("SetMoveControl", function(state)    PlayerControl:SetMoveControl(state)    end)


--# -----요약 : 
function PlayerControl:SetCameraControl(state)
    LocalPlayer:GetEnableCameraControl(state)
end
PlayerControl:ConnectEventFunction("SetCameraControl", function(state)    PlayerControl:SetCameraControl(state)    end)








