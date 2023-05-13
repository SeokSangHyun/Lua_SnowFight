-- Body_Charge Server --

local Item = Script.Parent.Parent 
local Body = Script.Parent

local EquipPlayerID = nil
local Delay = false
local FirstDelay = true
local ChargingReady = true
local FireCheck = false
local IsFire = false

local InputDelay = Body.InputDelay
local FireAmount = Body.FireAmount
local Count = 1
local ChargingDelay = Body.ChargingDelay
local ChargingTic = Body.ChargingTic
local ChargingBullet = Body.ChargingBullet

local DelayCheck = 0
local FireLocation = Vector.new(0, 0, 0)
local FireDir = Vector.new(0, 0, 0)

Item.IsEnableFire = true

---------------------------아이템 장착시 연결 함수--------------------------------
local function EquipItem(player)
   EquipPlayerID = player:GetPlayerID()
end
Item.EquipEvent:Connect(EquipItem)

-----------------------------------아이템 장착해제 시 처리함수------------------------------------
local function UnEquipItem(player)
    EquipPlayerID = nil
    Delay = false
    FirstDelay = true
    IsFire = false
end
Item.UnEquipEvent:Connect(UnEquipItem)

------------------------라이플 발사 종료------------------------------------
local function EndClick(player , playerLocation , playerDir)
   Count = 1
   Delay = false
   FirstDelay = true
   IsFire = false
   Item:SendEventToClient(EquipPlayerID, "PreFire", false)
   
   if FireCheck then
       FireCheck = false
       local charging = coroutine.create(function()

           local i = 0
           while i < ChargingDelay do
               if FireCheck then
                   ChargingReady = true
                   return
               end
               i = i + 0.1
               wait(0.1)
           end

           wait(ChargingDelay)
           if EquipPlayerID == nil then
            ChargingReady = true
                return
           end
           Game:SendEventToClient(EquipPlayerID, "Charging")
            while true do

                if FireCheck or EquipPlayerID == nil then
                    ChargingReady = true
                    return
                end

                Body.InitBullet = Body.InitBullet + ChargingBullet
                if Body.InitBullet > Body.MaxBullet then
                    Body.InitBullet = Body.MaxBullet
                    Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.InitBullet)
                    ChargingReady = true
                    return
                end
                Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.InitBullet)
                wait(ChargingTic)   
           end
       end)
       if ChargingReady then
           ChargingReady = false           
           coroutine.resume(charging)
       end
   end
   Item:SendEventToClient(player:GetPlayerID(), "EndClick")
end

local function TogleStart(player, location, direction)
end

Item:AddToggleAction("CheckAction", Body.FireRate, TogleStart, EndClick)

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
       return false
   end

    if Delay then
        return false    
    end

    if playerCharacter:IsDie() then
        return false    
    end

    if IsFire then
        return
    end

    if Item.IsEnableFire == false then
        return
    end
    
    if FirstDelay then
        Delay = true
    end

    IsFire = true
    FireCheck = true    

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
                    Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.InitBullet)
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
                Item:SendEventToClient(EquipPlayerID, "SetBulletUI", Body.InitBullet)
                local player = Game:GetPlayer(EquipPlayerID)
                Item:FireBullet(player, FireLocation, FireDir)
                Count = Count + 1
                IsFire = false
            end
        end
    end
end
Body.OnUpdateEvent:Connect(Update)


------------------------------충전기를 이용한 충전처리------------------------------------
local function ChargingServer(player, charging)
   if EquipPlayerID == nil then
       return
   end

   if player:GetPlayerID() ~= EquipPlayerID then
       return
   end

   if Body.InitBullet + charging > Body.MaxBullet then
       Body.InitBullet = Body.MaxBullet
   else
       Body.InitBullet = Body.InitBullet + charging
   end
   
   Item:SendEventToClient(player:GetPlayerID(), "SetBulletUI", Body.InitBullet)
end
Item:ConnectEventFunction("ChargingServer", ChargingServer)



