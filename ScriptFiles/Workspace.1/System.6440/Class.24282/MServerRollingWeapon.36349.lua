--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 

sRollingModule = {}
sRollingModule.__index = sRollingModule



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sRollingModule.new(object)
    local t = setmetatable({}, sRollingModule)
    
    
    t.WeaponObject = object

    
    return t
end





--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sRollingModule:GetBulletCount(player)
    return self.NowBulletCount
end





--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sRollingModule:Initialize()
end


return sRollingModule;



--[[
sc_SnowBall = {}
sc_SnowBall.__index = sc_SnowBall

local Utility = require(ScriptModule.DefaultModules.Utility)

--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sc_SnowBall.new(object)
    local t = setmetatable({}, sc_SnowBall)
    
    t.WeaponObject = object
    t.BulletSpeed = object.BulletSpeed
    t.BulletDistance = object.BulletDistance
    t.InvenIndex = 1
    
    t.OneTurnBulletCount = 30
    t.NowBulletCount = 30
    
    --눈 굴리기 변수
    t.WeaponThrowObject = Game:CreateSyncObject(Toybox.Bullet.SnowBallRolling, Vector.new(0,0,-1000))
    t.StartScale = Vector.new(0, 0, 0)
    
    return t
end


--!---------------------------- Getter/Setter ------------------------------
--# 목적 : 
function sc_SnowBall:GetBulletCount(player)
    return self.NowBulletCount
end






--!---------------------------- 아이템 획득/사용 처리 ------------------------------
--# 목적 : 아이템을 획득하면 인벤토리에 추가하는처리
--? 내용 : 아이템을 획득하는 처리
function sc_SnowBall:GetItem(player)
    self.NowBulletCount = self.NowBulletCount + self.OneTurnBulletCount
    return self.NowBulletCount
end



--# 목적 : 아이템을 사용하는 처리
function sc_SnowBall:UseItem(num)
    if (self.NowBulletCount) >= 1 then
        self.NowBulletCount = self.NowBulletCount - 1
        --Game:SendEventToClient(player:GetPlayerID(), "BulletFire", player, self.InvenIndex)
        return true
    else
        self.NowBulletCount = 0
        --player:GetCharacter():DetachObject(self.WeaponObject)
        return false
    end
end



    





--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sc_SnowBall:RollingInit(playerID)
    local player = Game:GetPlayer(playerID)
    local pos = player:GetCharacter().Location+ Vector.new(0,0,20)
    --print(pos)

    self.WeaponThrowObject.Visible = true
    self.WeaponThrowObject.Location = pos
    self.StartScale = Vector.new(1.5,1.5,1.5)
end


--# 목적 : 초기화 검사
function sc_SnowBall:RollingScaleUp(playerID, waittime, forX, forY)
    local player = Game:GetPlayer(playerID)
    local pos = player:GetCharacter().Location 
    scale = Vector.new( self.StartScale.X + 0.23*waittime , self.StartScale.Y + 0.23*waittime , self.StartScale.Z + 0.23*waittime )

    self.WeaponThrowObject.Location = pos + Vector.new(forX*250, forY*250, 20)
    self.WeaponThrowObject.Scale = scale
end


--# 목적 : 아이템을 사용하는 처리
function sc_SnowBall:RollingThrow(playerID, forX, forY, forZ)
    local player = Game:GetPlayer(playerID)
    local pos = player:GetCharacter().Location
    local target_pos = pos + Vector.new(forX*1000, forY*1000, 0)
    --print(pos)
    --print(target_pos)
    self.WeaponThrowObject:MoveToLocation(target_pos)
    self.WeaponThrowObject:RunPlay(forZ, forX, forY)
end


--# 목적 : 종료 시 처리
function sc_SnowBall:FinishSystem()
end

return sc_SnowBall;
]]--





