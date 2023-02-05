-- Body_Reload Server --

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


---------------------------아이템 장착시 연결 함수(값 초기화)--------------------------------
local function EquipItem(player)
   EquipPlayerID = player:GetPlayerID()
   Delay = false
   FirstDelay = true
   IsFire = false
   Body.IsReload = false
end
Item.EquipEvent:Connect(EquipItem)

-----------------------------------아이템 장착해제 시 처리함수------------------------------------
local function UnEquipItem(player)
   EquipPlayerID = nil
end
Item.UnEquipEvent:Connect(UnEquipItem)

----------------------------------탄약 회복---------------------------------------
Game:ConnectEventFunction("ServerSupply",function(player)
   if player:GetPlayerID() ~= EquipPlayerID then
       return
   end

   Body.MaxBullet = MaxBullet
   Body.InitBullet = InitBullet
   Item:SendEventToClient(player:GetPlayerID(), "SetBulletUI", Body.MaxBullet, Body.InitBullet) 
end)

------------------------라이플 발사 종료------------------------------------
local function EndClick(player, location, direction)

   if EquipPlayerID == nil then
       return
   end   
  
   Count = 1
   Delay = false
   FirstDelay = true
   IsFire = false
   Item:SendEventToClient(EquipPlayerID, "PreFire", false)
   return true
end

local function TogleStart(player, location, direction)
    
end

Item:AddToggleAction("CheckAction", Body.FireRate, TogleStart, EndClick)

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

------------------------------재장전 가능한지 판단 여부---------------------------------
local function ReloadCheck(player, location, direction)
    
    local playerID = player:GetPlayerID()
    local character = player:GetCharacter()
    local equipItem = player:GetEquipItem("EquipSlot_1")
    
    if EquipPlayerID == nil or not equipItem:IsValidValue("Body") then
       return
    end
    
    local body = equipItem.Body

    if body.InitBullet == body.ReloadBullet or body.IsReload or body.MaxBullet < 1 then
        return
    end    

    if character:IsDie() then
       return
    end

    if Item.IsEnableReload == false then
        return
    end
    
    body.IsReload = true
    
    local reloadTime = body.ReloadTime
    if character:IsValidValue("Reload") and character.Reload ~= 0 then
       reloadTime = reloadTime - character.Reload
       if reloadTime < 0 then
           reloadTime = 0
       end
    end

   Item:SendEventToClient(playerID, "GunReloadUI", reloadTime)
   local i = 0
   while i < reloadTime do
           wait(0.05)
           i = i + 0.05
   end
   
    if not character:IsDie() then
       local endClick = coroutine.create(EndClick)
       coroutine.resume(endClick)
       OnReloadGun(player)
    else
       body.IsReload = false    
    end
end
--Item:ConnectEventFunction("GunReloadStart", ReloadCheck)
Item:AddAction("Reload", 0, ReloadCheck)

----------------------------------총알 발사 (왼쪽 클릭)---------------------------------------
local function StartClick(player , playerLocation , playerDir)
   if EquipPlayerID == nil then
       return
   end

   local playerID = player:GetPlayerID()    
   local playerCharacter = player:GetCharacter()
   FireLocation = Vector.new(playerLocation.X, playerLocation.Y, playerLocation.Z)
   FireDir = Vector.new(playerDir.X, playerDir.Y, playerDir.Z)

    if nil == player or playerID ~= EquipPlayerID then
        return false
    end
    
    if Count > FireAmount then
       return false
    end
    
   if Body.InitBullet <= 0 then
       ReloadCheck(player)
       return false
   end

    if Body.IsReload then
       return false
    end

   if Delay then
       return false    
    end

    if playerCharacter:IsDie() then
       return false    
    end

    if IsFire then
        return false
    end

    if Item.IsEnableFire == false then
        return false
    end

    if FirstDelay then
        Delay = true
    end
        
    IsFire = true

   return true
end
Item:AddAction("Fire", Body.FireRate, StartClick)


local function Update(updateTime)
    if EquipPlayerID ~= nil and IsFire then
        Item:SendEventToClient(EquipPlayerID, "PreFire", true)
            
        if Delay then
            DelayCheck = DelayCheck + updateTime
            if DelayCheck >= InputDelay then
                Delay = false
                FirstDelay = false
                Body.InitBullet = Body.InitBullet - 1
                if EquipPlayerID ~= nil then
                    Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.MaxBullet, Body.InitBullet)
                    local player = Game:GetPlayer(EquipPlayerID)
                    Item:FireBullet(player, FireLocation, FireDir)
                    Count = Count + 1
                    IsFire = false
                    DelayCheck = 0
                end
            end
        else
            if EquipPlayerID ~= nil then
                Body.InitBullet = Body.InitBullet - 1
                Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.MaxBullet, Body.InitBullet)
                local player = Game:GetPlayer(EquipPlayerID)
                Item:FireBullet(player, FireLocation, FireDir)
                Count = Count + 1
                IsFire = false
            end
        end
    end
end
Body.OnUpdateEvent:Connect(Update)

