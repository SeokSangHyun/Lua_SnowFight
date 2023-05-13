
local toy = Script.Parent.Parent




--!---------------------------- 아이템 장착시 연결 함수(값 초기화) ------------------------------
local function EquipItem(player)
    --toy:SetEquipPlayerID(player:GetPlayerID())
--[[
   Delay = false
   FirstDelay = true
   IsFire = false
   Body.IsReload = false
]]--
end
toy.EquipEvent:Connect(EquipItem)





--!---------------------------- 아이템 장착해제 시 처리함수 ------------------------------
local function UnEquipItem(player)
   -- toy:SetEquipPlayerID(nil)
end
toy.UnEquipEvent:Connect(UnEquipItem)










