

--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


cc_Player = {}
cc_Player.__index = cc_Player

local SnowBallModule = require(Workspace.System.Class.ccSnowBallModule)
local SnowCrystalModule = require(Workspace.System.Class.ccSnowCrystalsModule)
local IcicleModule = require(Workspace.System.Class.ccIcicleModule)
local DamageModule = require(ScriptModule.DefaultModules.DamageManager)



function cc_Player.new(playerID, object_path)
    local t = setmetatable({}, cc_Player)
    
    t.HP = 100
    t.PlayerID = playerID
    t.weapons = {SnowBallModule.new(object_path[1]), IcicleModule.new(object_path[2]), SnowCrystalModule.new(object_path[3])}
--[[
    for i=1, #weapon_module do
        table.insert(t.weapons, weapon_module[i].new(object_path[i]) )
    end
]]--
    
    return t
end



--# 목적 : 아이템 발사
function cc_Player:Fire(playerID, num, forX, forY, forZ)
    
    self.weapons[num]:FireObject(playerID, forX, forY, forZ)
end


--# 목적 : 투사체 피격
function cc_Player:HitMyPlayer(character, index)
    print(tostring(character.Name) .. tostring(index))
    local weaponDamage = self.weapons[index]:GetDamage()
    Camera:PlayCameraShake(0.5, 2)
    DamageModule:ApplyDamage(character, weaponDamage)
    
end





return cc_Player;






