
--! ------------------------------ Body_Reload Client ------------------------------
local Item = Script.Parent.Parent
local Body = Script.Parent
local Base = Item.Base

----------- FX Setting -----------
local Equip = false
local Supply = false
local Firecheck = false


local RedColor = Color.new(255, 0, 0, 255)  
local DefaultColor = Color.new(255, 255, 255, 255)
--GunInput = Input:AddGroup("GunInput")





--! ------------------------------ 아이템 장착시 연결 함수 ------------------------------
local function EquipItem(Player)
    local player = LocalPlayer:GetRemotePlayer()
    if player ~= Player then
        return
    end
    
    Equip = true
        
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
   
   --모바일 총 기본 버튼 표시
   Input:SetJoystickControlVisibility(2, false)
   Input:SetJoystickControlVisibility(3, false)

   --Input:DeactiveGroup("GunInput")
end
Item.UnEquipEvent:Connect(UnEquipItem)




--! ------------------------------ 서버와 동기화 함수 ------------------------------
--# ===== 마우스를 뗐을 때(?)
local function EndClick(player, location, direction)
   if Equip == false then
       return
   end
   Item:EndFire()
end


--# ===== 공격 버튼을 눌렀을 때
local function StartClick(player, location, direction)
end

local function StartReload(player, location, direction)
end

Item:AddAction("Fire", 0.5, true, StartClick, Enum.Key.SpaceBar , Enum.Key.GamePad_Button2)
Item:AddToggleAction("CheckAction", 0.5, StartClick, EndClick, Enum.Key.LeftMouseButton, Enum.Key.GamePad_Button2)





--! ------------------------------ 공격 시스템 ------------------------------
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






