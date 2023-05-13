
UIRoot = HUD.MainUI


--버튼
SnowBallButton = UIRoot.Btn_Snowball
IcicleButton = UIRoot.Btn_Icicle
SnowCrystalButton = UIRoot.Btn_SnowCrystal



--!---------------------------- 버튼 입력 처리 ------------------------------
--# 목적 : 
local function SnowBallButtonEvent(self)
    local player = LocalPlayer:GetRemotePlayer()
    local playerID = player:GetPlayerID()
    local forward = LocalPlayer:GetCameraForward()

    Game:SendEventToServer( "WeaponFire_cTos", 1, forward.X, forward.Y, forward.Z)
end
SnowBallButton.OnUpEvent:Connect(SnowBallButtonEvent)


--# 목적 : 
local function IcicleButtonEvent(self)
    local player = LocalPlayer:GetRemotePlayer()
    local playerID = player:GetPlayerID()
    local forward = LocalPlayer:GetCameraForward()

    Game:SendEventToServer( "WeaponFire_cTos", 2, forward.X, forward.Y, forward.Z)
end
IcicleButton.OnUpEvent:Connect(IcicleButtonEvent)


--# 목적 : 
local function SnowCrystalButtonEvent(self)
    local player = LocalPlayer:GetRemotePlayer()
    local playerID = player:GetPlayerID()
    local forward = LocalPlayer:GetCameraForward()

    Game:SendEventToServer( "WeaponFire_cTos", 3, forward.X, forward.Y, forward.Z)
end
SnowCrystalButton.OnUpEvent:Connect(SnowCrystalButtonEvent)




--!---------------------------- UI 처리 ------------------------------
--# 목적 : ㅁ
local function SnowBall_UIUpdate(num)
    local toyRoot = Toybox.SpawnItem:GetChildList()
    for i=1, #toyRoot do
        if i == num then
            local remaincnt = SnowBallButton.Img_TextBackground.T_Count
            remaincnt:SetText("X " .. tostring(num) )
        end
    end
end
Game:ConnectEventFunction("SnowBall_UIUpdate", SnowBall_UIUpdate)


