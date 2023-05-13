-- Body_Charge Client --

local Item = Script.Parent.Parent
local Body = Script.Parent
local Base = Item.Base

----------- FX Setting -----------
local ReloadFX = Base.SFX.Reload:GetChildList()
local PreFireFX = Base.SFX.PreFire:GetChildList()

local BulletUI = Body.BulletUI

local Equip = false

BulletUI.Visible = false

---------------------------아이템 장착시 연결 함수--------------------------------
local function EquipItem(Player)
    local player = LocalPlayer:GetRemotePlayer()
    if player ~= Player then
        return
    end
    
    Equip = true
    BulletUI.InitB:SetText(Body.InitBullet)
    BulletUI.MaxB:SetText(Body.MaxBullet)
    BulletUI.NameText:SetText(Item.Name)
    BulletUI.Charge:SetPercent(Body.InitBullet/Body.MaxBullet)
    BulletUI.Visible = true
    
    --모바일 총 기본 버튼 표시
    Input:SetJoystickControlVisibility(2, true)
    Input:SetPadCenter(2, -165, -65)
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
   Input:SetJoystickControlVisibility(2, false)
   
end
Item.UnEquipEvent:Connect(UnEquipItem)

---------------------------마우스 왼쪽버튼 클릭시 액션함수 생성--------------------------------
local function EndClick()
   if Equip == false then
       return
   end
   Item:EndFire()
end
Item:ConnectEventFunction("EndClick", EndClick)

local function StartClick(player, location, direction)
end

local function SClick(player, location, direction)
end

local function EClick(player, location, direction)
end

Item:AddAction("Fire", Body.FireRate, true, StartClick, Enum.Key.LeftMouseButton, Enum.Key.GamePad_Button2)
Item:AddToggleAction("CheckAction", Body.FireRate, SClick, EClick, Enum.Key.LeftMouseButton, Enum.Key.GamePad_Button2)


---------------------------BulletCharging Start-----------------------------------
local function Charging()
   if Equip == false then
       return
   end
   
   if ReloadFX ~= nil then
       for i = 1, #ReloadFX do               
           if ReloadFX[i]:IsFX() or ReloadFX[i]:IsSound() then
               ReloadFX[i]:Play()
           end
       end
   end
end
Item:ConnectEventFunction("Charging", Charging)


-----------------------------------Bullet UI 최신화-----------------------------------
local function SetBulletUI(initB)
   if Equip == false then
       return
   end
   
   BulletUI.InitB:SetText(initB)
   
   --------------------최신화 시 탄환량에 따른 TEXT 색 변경 처리 ---------------------------
   local RedColor = Color.new(255, 0, 0, 255)  
   local DefaultColor = Color.new(255, 255, 255, 255)
   
   BulletUI.InitB:SetTextColor(DefaultColor)
   BulletUI.MaxB:SetTextColor(DefaultColor)
   --BulletUI.Slash:SetTextColor(DefaultColor)
   BulletUI.NameText:SetTextColor(DefaultColor)
   
   if initB == 0 then
       BulletUI.InitB:SetTextColor(RedColor)
     --BulletUI.Slash:SetTextColor(RedColor)
       BulletUI.MaxB:SetTextColor(RedColor)
       BulletUI.NameText:SetTextColor(RedColor)
          
   end
   BulletUI.Charge:SetPercent(initB/Body.MaxBullet)
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


----------------------------------충전기를 이용한 충전처리--------------------------------
local function ChargingGun(charging)
   if Equip == false then
       return
   end
   Item:SendEventToServer("ChargingServer", charging)
end
Game:ConnectEventFunction("ChargingGun", ChargingGun)






