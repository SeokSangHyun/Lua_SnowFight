

--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


sc_Player = {}
sc_Player.__index = sc_Player

local SnowBallModule = require(Workspace.System.Class.scSnowBallModule)
local SnowCrystalModule = require(Workspace.System.Class.scSnowCrystalsModule)
local IcicleModule = require(Workspace.System.Class.scIcicleModule)



function sc_Player.new(player, object_path)
    local t = setmetatable({}, sc_Player)
    
    t.HP = 100
    t.PlayerID = player:GetPlayerID()
    
    t.weapons = {SnowBallModule.new(object_path[1]), IcicleModule.new(object_path[2]), SnowCrystalModule.new(object_path[3])}
--[[
    for i=1, #weapon_module do
        table.insert(t.weapons, weapon_module[i].new(object_path[i]) )
    end
]]--
    
    return t
end


--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 무기 정보를 반환하는 정보
function sc_Player:GetAllBulletCount()
    local cnt_list = {}
    for i = 1 , #self.weapons do
        table.insert(cnt_list, self.weapons[i]:GetBulletCount())
    end
    
    return cnt_list
end







--!---------------------------- 아이템 획득/사용 처리 ------------------------------
--# 목적 : 아이템을 획득하면 인벤토리에 추가하는처리
function sc_Player:GetItem(player, ItemNum)
    self.weapons[ItemNum]:GetItem(player)

    --Game:DeleteObject(self)
end



--# 목적 : 아이템 발사
function sc_Player:Fire(player, num, forX, forY, forZ)
    local playerID = player:GetPlayerID()
    local AllPlayer = Game:GetAllPlayer()
    local bullet = self.weapons[num]:UseItem(player)

    for i = 1 , #AllPlayer do
        Game:SendEventToClient(AllPlayer[i]:GetPlayerID(), "BulletFire", playerID, num, forX, forY, forZ)

    end
end


return sc_Player;

