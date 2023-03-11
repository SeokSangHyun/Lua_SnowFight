

--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


cc_Player = {}
cc_Player.__index = cc_Player

local SnowBallModule = require(Workspace.System.Class.ccSnowBallModule)
local SnowCrystalModule = require(Workspace.System.Class.ccSnowCrystalsModule)
local IcicleModule = require(Workspace.System.Class.ccIcicleModule)
local SnowBallRollingModule = require(Workspace.System.Class.ccSnowBallRollingModule)
local DamageModule = require(ScriptModule.DefaultModules.DamageManager)



function cc_Player.new(playerID, object_path)
    local t = setmetatable({}, cc_Player)
    
    t.HP = 100
    t.PlayerID = playerID
    t.WeaponIndex = 1
    t.weapons = {SnowBallModule.new(object_path[1]), IcicleModule.new(object_path[2]), SnowCrystalModule.new(object_path[3]), SnowBallRollingModule.new(object_path[4]) }
--[[
    for i=1, #weapon_module do
        table.insert(t.weapons, weapon_module[i].new(object_path[i]) )
    end
]]--
    
    return t
end

--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 아이템 획득

function cc_Player:SetWeaponIndex(index); self.WeaponIndex = index;    end;
function cc_Player:GetWeaponIndex();  return self.WeaponIndex;    end;

function cc_Player:Set(playerID, num, forX, forY, forZ)
    Game:SendEventToServer( "WeaponFire_cTos", self.WeaponIndex, forward.X, forward.Y, forward.Z)
end



--!---------------------------- 입력 함수 ------------------------------
function cc_Player:ActionInput(bullet_index)
    self.WeaponIndex = bullet_index
end



--!---------------------------- 기능 ------------------------------
--# 목적 : 발사 요청 스크립트
function cc_Player:PreFire()
    local lookforward = LocalPlayer:GetCameraForward()

    Game:SendEventToServer( "RequestFire_cTos", self.WeaponIndex, lookforward.X, lookforward.Y, lookforward.Z)
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


--# 목적 : 아이템 발사
function cc_Player:RollingSystem(playerID, size)
    self.weapons[num]:Rolling()
end





return cc_Player;






