
--! ------------------------------ Body_Reload Server ------------------------------
local Item = Script.Parent.Parent 
local Body = Script.Parent

local IsReload = false
local EquipPlayerID = nil

local Delay = false
local FirstDelay = true
local IsFire = false

local InputDelay = Body.InputDelay
local FireAmount = Body.FireAmount
local Count = 1
local MaxBullet = Body.MaxBullet
local InitBullet = Body.InitBullet

local DelayCheck = 0
local FireLocation = Vector.new(0, 0, 0)
local FireDir = Vector.new(0, 0, 0)

Item.IsEnableFire = true
Item.IsEnableReload = true





--! ------------------------------ 아이템 장착/해제 ------------------------------
--# ===== 아이템 장착 시 처리
local function EquipSetting(player)
    EquipPlayerID = player:GetPlayerID()
    print(EquipPlayerID)
end
Item.EquipEvent:Connect(EquipSetting)


--# ===== 아이템 장착 해제 시 처리
local function UnEquipSetting(player)
    EquipPlayerID = nil
end
Item.UnEquipEvent:Connect(UnEquipSetting)




--! ------------------------------ 기타 기능 ------------------------------

local function TogleStart(player, location, direction)
    
end

--Item:AddToggleAction("CheckAction", Body.FireRate, TogleStart, EndClick)

---------------------라이플 재장전 함수-------------------------
local function OnReloadGun(player)
    local equiObject = player:GetEquipItem("EquipSlot_1")
    
    if EquipPlayerID == nil or not equiObject:IsValidValue("Body") then
       return
    end
    
    local body = equiObject.Body
    local SubBullet = body.ReloadBullet - body.InitBullet 

    -----------------만약 현재 총알 + 재장전 총알 수가 기준을 넘을경우 처리----------------------
    if body.InitBullet + body.ReloadBullet > body.ReloadBullet then
        if (body.MaxBullet <= SubBullet) or (body.MaxBullet - SubBullet <0) then
            body.InitBullet = body.InitBullet + body.MaxBullet
            body.MaxBullet = 0
        else
            body.InitBullet = body.InitBullet + SubBullet
            body.MaxBullet = body.MaxBullet - SubBullet  
        end  
        
    ------------------그외 CurBullet가 0일 경우 처리-----------------------
    else
        if (body.MaxBullet < SubBullet) or (body.MaxBullet - SubBullet <0) then
            body.InitBullet = body.InitBullet + body.MaxBullet
            body.MaxBullet = 0
        else
            body.InitBullet = body.InitBullet + body.ReloadBullet
            body.MaxBullet = body.MaxBullet - body.ReloadBullet
        end
    end

    local playerID = player:GetPlayerID()
    body.IsReload = false

    Item:SendEventToClient(playerID, "SetBulletUI", body.MaxBullet, body.InitBullet)
end



----------------------------------총알 발사 (왼쪽 클릭)---------------------------------------
local function StartClick(player, playerLocation , playerDir)
   if EquipPlayerID == nil then
       return
   end

   local playerID = player:GetPlayerID()    
   local playerCharacter = player:GetCharacter()
   FireLocation = Vector.new(playerLocation.X, playerLocation.Y, playerLocation.Z)
   FireDir = Vector.new(playerDir.X, playerDir.Y, playerDir.Z)

--* 예외처리
    if nil == player or playerID ~= EquipPlayerID then
        return false
    end
    if IsFire then;        return false;    end;

--* 세팅
    IsFire = true

    return true
end
Item:AddAction("Fire", 0.5, StartClick)







--! ------------------------------ Update 기능 ------------------------------
local function Update(updateTime)
    if EquipPlayerID ~= nil and IsFire then
        local player = Game:GetPlayer(EquipPlayerID)
        Item:FireBullet(player, 1, FireLocation, FireDir)
        IsFire = false
    
        Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.MaxBullet, Body.InitBullet)
    
        
    end
end
Body.OnUpdateEvent:Connect(Update)


