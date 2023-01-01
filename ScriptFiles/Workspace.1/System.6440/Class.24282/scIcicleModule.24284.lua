
--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


sc_Icicle = {}
sc_Icicle.__index = sc_Icicle

--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sc_Icicle.new(object)
    local t = setmetatable({}, sc_Icicle)
    
    
    t.WeaponObject = object
    t.InvenIndex = 2
    
    t.OneTurnBulletCount = 30
    t.NowBulletCount = 0
    
    return t
end


--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sc_Icicle:GetBulletCount(player)
    return self.NowBulletCount
end




--!---------------------------- 아이템 획득/사용 처리 ------------------------------
--# 목적 : 아이템을 획득하면 인벤토리에 추가하는처리
--? 내용 : 아이템을 획득하는 처리
function sc_Icicle:GetItem(player)
    if (self.NowBulletCount) <= 0 then;
        player:GiveItem(Item)
        player:EquipInventoryItem(self.InvenIndex)
    end

    self.NowBulletCount = self.NowBulletCount + self.OneTurnBulletCount
end



--# 목적 : 아이템을 사용하는 처리
function sc_Icicle:UseItem(player)
    if (self.NowBulletCount) >= 1 then
        self.NowBulletCount = self.NowBulletCount - 1
        return true
    else
        self.NowBulletCount = 0
        player:GetCharacter():DetachObject(self.WeaponObject)
    end
end



return sc_Icicle;

