-- Body_Reload Client --

local Item = Script.Parent.Parent
local Body = Script.Parent
local Base = Item.Base

----------- FX Setting -----------
local ReloadFX = Base.SFX.Reload:GetChildList()
local PreFireFX = Base.SFX.PreFire:GetChildList()

local BulletUI = Body.BulletUI
local SupplyUI = Body.SupplyUI
local ReloadUI = Body.ReloadUI 

local Equip = false
local Supply = false
local Firecheck = false

BulletUI.Visible = false
SupplyUI.Visible = false
ReloadUI.Visible = false

local RedColor = Color.new(255, 0, 0, 255)  
local DefaultColor = Color.new(255, 255, 255, 255)

--GunInput = Input:AddGroup("GunInput")


---------------------------아이템 장착시 연결 함수--------------------------------
local function EquipItem(Player)
    local player = LocalPlayer:GetRemotePlayer()
    if player ~= Player then
        return
    end
    
    Equip = true
    --Input:ActiveGroup("GunInput")
    BulletUI.MaxB:SetText(Body.MaxBullet)
    BulletUI.InitB:SetText(Body.InitBullet)
    --BulletUI.MagazineB:SetText(Body.ReloadBullet)
    BulletUI.NameText:SetText(Item.Name)
    BulletUI.Visible = true
        
    --모바일 총 기본 버튼 표시
    Input:SetJoystickControlVisibility(2, true)
    Input:SetPadCenter(2, -165, -65)
    Input:SetJoystickControlVisibility(3, true)
    Input:SetPadCenter(3, -140, -175)
    
end
Item.EquipEvent:Connect(EquipItem)

-------------------------아이템 해제시 연결 함수--------------------------------
local function UnEquipItem(Player)
   local player = LocalPlayer:GetRemotePlayer()
    if player ~= Player then
        return
    end
    
   Equip = false
   
   BulletUI.Visible = false
   ReloadUI.Visible = false
   SupplyUI.Visible = false
   
   --모바일 총 기본 버튼 표시
   Input:SetJoystickControlVisibility(2, false)
   Input:SetJoystickControlVisibility(3, false)

   --Input:DeactiveGroup("GunInput")
end
Item.UnEquipEvent:Connect(UnEquipItem)

---------------------------마우스 왼쪽버튼 클릭 액션함수 생성--------------------------------
local function EndClick(player, location, direction)
   if Equip == false then
       return
   end
   Item:EndFire()
end

local function StartClick(player, location, direction)
end

local function StartReload(player, location, direction)
end

Item:AddAction("Fire", Body.FireRate, true, StartClick, Enum.Key.LeftMouseButton, Enum.Key.GamePad_Button2)
Item:AddAction("Reload", 0, false, StartReload, Enum.Key.R, Enum.Key.GamePad_Button3)
Item:AddToggleAction("CheckAction", Body.FireRate, StartClick, EndClick, Enum.Key.LeftMouseButton, Enum.Key.GamePad_Button2)

------------------------서버에서 판단 완료후 재장전 이벤트 받음-------------------------------
local function GunReloadUI(reloadTime)
   if Equip == false then
       return
   end
   
    local player = LocalPlayer:GetRemotePlayer()

    if ReloadFX ~= nil then
        for i = 1, #ReloadFX do
              
            if ReloadFX[i]:IsFX() or ReloadFX[i]:IsSound() then
                ReloadFX[i]:Play()
            end
        end
    end 
    
    local endClick = coroutine.create(EndClick)
    coroutine.resume(endClick)
    
    ReloadUI.Visible = true
    ReloadUI.ReloadBar:SetPercent(0)
    local i = 0
    while i < reloadTime do       
       wait(0.05)
       i = i + 0.05
       
       if Equip == false then
           return
       end
       
       ReloadUI.ReloadBar:SetPercent(i / (reloadTime - 0.5))
    end
    ReloadUI.Visible = false
end
Item:ConnectEventFunction("GunReloadUI", GunReloadUI)

--[[
------------------------R키 눌렀을 때 재장전 연결이벤트---------------------------------
local function ReloadStart()
   if Equip == false then
       return 
   end    
   
   Item:SendEventToServer("GunReloadStart")
end
GunInput:AddActionKeyEvent("ReloadGun", Enum.Key.R)
GunInput:ProcessInputActionEvent("ReloadGun", Enum.KeyInputType.Pressed, ReloadStart)
--]]

------------------------총알 충전 함수---------------------------
Game:ConnectEventFunction("BulletSupply", function()
   if Equip == false or Supply then
       return
   end
   
   Supply = true
   Game:SendEventToServer("ServerSupply")
   SupplyUI.Visible = true
   wait(1)
   SupplyUI.Visible = false
   Supply = false
end)


-----------------------------------Bullet UI 최신화-----------------------------------
local function SetBulletUI(maxB, initB)
   if Equip == false then
       return
   end
   
   BulletUI.MaxB:SetText(maxB)
   BulletUI.InitB:SetText(initB)
   
   --------------------최신화 시 탄환량에 따른 TEXT 색 변경 처리 ---------------------------
   
   BulletUI.InitB:SetTextColor(DefaultColor)
   BulletUI.MaxB:SetTextColor(DefaultColor)
   --BulletUI.MagazineB:SetTextColor(DefaultColor)   
   BulletUI.NameText:SetTextColor(DefaultColor)
   
   if initB == 0 then
       BulletUI.InitB:SetTextColor(RedColor)       
       --BulletUI.MagazineB:SetTextColor(RedColor)
   end
   
   if maxB == 0 then
       BulletUI.MaxB:SetTextColor(RedColor)
   end
   
   if initB == 0 and maxB == 0 then
       BulletUI.NameText:SetTextColor(RedColor)
   end
end
Item:ConnectEventFunction("SetBulletUI", SetBulletUI)


-----------------------------------공격 시 연출--------------------------------
local function PreFire(startfire)
    
    if Equip == false then
        return
    end
    
    if not startfire then
        Firecheck = false
        
        for i = 1, #PreFireFX do              
            if PreFireFX[i]:IsFX() or PreFireFX[i]:IsSound() then
                PreFireFX[i]:Stop()
            end
       end
    else    
        if Firecheck then
            return
        end
        
        Firecheck = true
        
        if PreFireFX ~= nil then       
            for i = 1, #PreFireFX do              
                if PreFireFX[i]:IsFX() or PreFireFX[i]:IsSound() then
                    PreFireFX[i]:Play()
                end
            end
        end
     end
end
Item:ConnectEventFunction("PreFire", PreFire)






