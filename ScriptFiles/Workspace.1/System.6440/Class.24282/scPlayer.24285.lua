

--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


sc_Player = {}
sc_Player.__index = sc_Player


local SnowBallModule = require(Workspace.System.Class.scSnowBallModule)
local SnowCrystalModule = require(Workspace.System.Class.scSnowCrystalsModule)
local IcicleModule = require(Workspace.System.Class.scIcicleModule)
local SnowBallRollingModule = require(Workspace.System.Class.scSnowBallRollingModule)
local DamageModule = require(ScriptModule.DefaultModules.DamageManager)



function sc_Player.new(player, weapon, object_path)
    local t = setmetatable({}, sc_Player)
    
    t.HP = 100
    t.PlayerID = player:GetPlayerID()
    t.State = 0     -- 0:"Common" , 1:"Ready" , 2:"WaitReady" , 3:"InGame" , 4:"Reward" , 10:"Dead"
    
    t.Weapon = weapon
    t.weapons = {SnowBallModule.new(object_path[1]), IcicleModule.new(object_path[2]), SnowCrystalModule.new(object_path[3]), SnowBallRollingModule.new(object_path[4])}

    -- 투사체 발사 변수
    t.FireBulletNum = 0
    t.StartPos = Vector.new(0,0,0)
    t.LookForward=Vector.new(0,0,0)
    
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



--# 목적 : 캐릭터 상태
function sc_Player:CheckPlayerState(strState)
    if self.State == 2 and strState == "WaitReady" then
        return true
    else
        return false
    end
end


function sc_Player:SetPlayerState(strState)
    if strState == "WaitReady" then
        self.State = 2
    elseif strState == "Dead" then
        self.State = 10
    else
        self.State = 0
    end
end



--!---------------------------- 캐릭터 상황 별 효과 ------------------------------
--# 목적 : 
function sc_Player:StateAction()
    local character= Game:GetPlayer(self.PlayerID):GetCharacter()

    if self.State == 2 then
        while self.State == 2 do
            character:AddForce( Vector.new(0, 0, 50*5000) )
            wait(2)
        end
    end
end



--!---------------------------- 아이템 획득/사용 처리 ------------------------------
--# ===== 아이템 착용
function sc_Player:EquipItem(player)
    player:GiveItem(self.Weapon)
    player:EquipInventoryItem(1)
end


--# ===== 아이템 착용 해제
function sc_Player:unEquipItem(player)
    player:DeleteItem(i)
end





--# 목적 : 아이템을 획득하면 인벤토리에 추가하는처리
function sc_Player:GetItem(ItemNum, forX, forY)
    local bulletcnt = self.weapons[ItemNum]:GetItem(forX, forY)

    return bulletcnt
end



--!---------------------------- 기능 ------------------------------
--# 목적 : 발사 요청 스크립트 
function sc_Player:PreFire(ItemNum, stX, stY, stZ, forX, forY, forZ)
    --self.weapons[ItemNum]:Initialize(self.PlayerID)
    self.FireBulletNum = ItemNum
    self.StartPos = Vector.new(stX, stY, stZ)
    self.LookForward = Vector.new(forX, forY, forZ)
end


--# 목적 : 아이템 발사 
function sc_Player:Fire()
    local player = Game:GetPlayer(self.PlayerID)
    local forw = self.LookForward
    print(self.FireBulletNum)
    local IsCanFire = self.weapons[self.FireBulletNum]:UseItem(1)

    Game:BroadcastEvent("BulletFire_sToc", self.PlayerID, self.FireBulletNum, forw.X, forw.Y, forw.Z)
    self.weapons[self.FireBulletNum]:BulletSystem(player , self.StartPos , self.LookForward)

end





--!---------------------------- 기능 ------------------------------
function sc_Player:RollingStart()
    self.weapons[1]:RollingInit(self.PlayerID)
end


function sc_Player:Rolling(waitTime, forX, forY)
    self.weapons[1]:RollingScaleUp(self.PlayerID, waitTime, forX, forY)
end


function sc_Player:RollingThrow(forX, forY, forZ)
    self.weapons[1]:RollingThrow(self.PlayerID, forX, forY, forZ)
end


return sc_Player;

