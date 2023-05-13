
local toy = Script.Parent.Parent





--!---------------------------- 아이템 장착시 연결 함수 ------------------------------
local function EquipItem(Player)
    local character = LocalPlayer:GetRemotePlayer():GetCharacter()
    
    if target == nil or not target:IsMyCharacter() then;    return;    end;
    toy:SetIsEquip(true)
    
end
toy.EquipEvent:Connect(EquipItem)

-------------------------아이템 해제시 연결 함수--------------------------------
local function UnEquipItem(Player)
    local player = LocalPlayer:GetRemotePlayer()
    toy:SetIsEquip(false)


   --Input:DeactiveGroup("GunInput")
end
toy.UnEquipEvent:Connect(UnEquipItem)


