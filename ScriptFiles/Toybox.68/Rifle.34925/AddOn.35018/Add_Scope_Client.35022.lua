-- Addon_Scope Client --

local Item = Script.Parent.Parent 
local AddOn = Script.Parent

local ZoomFOV = AddOn.ZoomFOV
local ScopeUI = AddOn.ScopeUI
ScopeUI.Visible = false

local Equip = false
local NormalFOV = nil

--AddOnInput = Input:AddGroup("AddOnInput")
--AddOnInput:AddActionKeyEvent("ZoomInOut", Enum.Key.RightMouseButton)

---------------------------아이템 장착시 연결 함수--------------------------------
local function EquipItem(Player)
    local player = LocalPlayer:GetRemotePlayer()
    if player ~= Player then
        return
    end
    
    --Input:ActiveGroup("AddOnInput")

    --모바일 총 애드온 버튼 표시
    Input:SetJoystickControlVisibility(4, true)
    Input:SetPadCenter(4, -30, -200)
    
    Equip = true
end
Item.EquipEvent:Connect(EquipItem)

-------------------------마우스 우클릭 끝날 시 줌아웃--------------------------
local function ZoomOut(player, location, direction)
   if Equip == false then
       return
   end
   local currentCamera = LocalPlayer:GetCurrentCamera()
   if NormalFOV ~= nil then
       currentCamera.FieldOfView = NormalFOV
   end
   ScopeUI.Visible = false
end
--AddOnInput:ProcessInputActionEvent("ZoomInOut", Enum.KeyInputType.Released, ZoomOut)

-------------------------아이템 해제시 연결 함수--------------------------------
local function UnEquipItem(Player)
   local player = LocalPlayer:GetRemotePlayer()
    if player ~= Player then
        return
    end
    
    --Input:DeactiveGroup("AddOnInput")
    
    if NormalFOV ~= nil then
       ZoomOut() 
    end
    
    --모바일 총 애드온 버튼 표시
    Input:SetJoystickControlVisibility(4, false)
        
    Equip = false
   
end
Item.UnEquipEvent:Connect(UnEquipItem)

-------------------------마우스 우클릭 시 카메라 줌-----------------------------
local function ZoomIn(player, location, direction)
   if Equip == false then
       return
   end
   local currentCamera = LocalPlayer:GetCurrentCamera()
   
   NormalFOV = currentCamera.FieldOfView
   currentCamera.FieldOfView = currentCamera.FieldOfView - ZoomFOV
   
   ScopeUI.Visible = true
end
--AddOnInput:ProcessInputActionEvent("ZoomInOut", Enum.KeyInputType.Pressed, ZoomIn)
Item:AddToggleAction("ZoomInOut", 0, ZoomIn, ZoomOut, AddOn.KeyToUse, Enum.Key.GamePad_Button4)


------------------------스폰 시 초기화 (줌아웃)-----------------------------

