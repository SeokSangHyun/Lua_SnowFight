--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 

sRollingModule = {}
sRollingModule.__index = sRollingModule



--!---------------------------- 초기화 ------------------------------
--# 목적 : 생성시 정보 초기화
function sRollingModule.new(playerID, object)
    local t = setmetatable({}, sRollingModule)
    
    t.WeaponObject = Game:CreateSyncObject(object, Vector.new(0, 0, 0))
    t.playerID = playerID    
    t.StartScale = Vector.new(0, 0, 0)

    t.Cor = nil
    t.RolllAct = false
    
    return t
end




--!---------------------------- 무기 시스템 처리 ------------------------------
--# 목적 : 기본 세팅 값
function sRollingModule:Initialize()
    local player = Game:GetPlayer(self.playerID)
    local pos = player:GetCharacter().Location+ Vector.new(0,0,50)

    self.WeaponObject.Enable = true
    self.RolllAct = false
    self.WeaponObject.Location = pos
    self.StartScale = Vector.new(1.0, 1.0, 1.0)
   
    
--충돌
    self.WeaponObject.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Ignore)
    self.WeaponObject.HitCollider.Collision.OnBeginOverlapEvent:Connect( function(ball, target)
        --print(tostring(self.RolllAct) .. target)
        if not self.RolllAct then;    return;    end;
        --print(tostring(self.RolllAct) .. target.Name)
        if target == nil or not target:IsCharacter() then;    return;    end;
        print(target)
            
        local playerID = target:GetPlayerID()
        if self.playerID == playerID then;    return;    end;
        
        --self.RolllAct = false
        self.Cor = nil
        GameManager:HitCharacter_Rolling(self.playerID, self.WeaponObject)
    end)
end






function sRollingModule:ResetRolling()

        self.RolllAct = false
        self.WeaponObject.SFX_Broken:Play()
        
        wait(2)
        
        self.WeaponObject.Enable = false
        self.WeaponObject.Location = Vector.new(0, 0, 0)
        self.WeaponObject.HitCollider.Location = Vector.new(0, 0, 0)
        
end






--# 목적 : 초기화 검사
function sRollingModule:RollingScaleUp(waittime, forX, forY)
    local player = Game:GetPlayer(self.playerID)
    local pos = player:GetCharacter().Location
    local scale = 0.3
    local RollingScale = Vector.new( self.StartScale.X + scale*waittime , self.StartScale.Y + scale*waittime , self.StartScale.Z + scale*waittime )

    self.WeaponObject.Location = pos + Vector.new(forX*250, forY*250, 20)
    self.WeaponObject.Scale = RollingScale
end




--# 목적 : 아이템을 사용하는 처리
function sRollingModule:RollingThrow(forX, forY, forZ)
    local player = Game:GetPlayer(self.playerID)
    local pos = player:GetCharacter().Location
    local target_pos = pos + Vector.new(forX*1000, forY*1000, 0)
    --print(pos)
    --print(target_pos)
    self.WeaponObject:MoveToLocation(target_pos)
    self.WeaponObject.HitCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
    --self.WeaponObject:RunPlay(forZ, forX, forY)
    
    self.Cor = coroutine.create(function()
        self.RolllAct = true
        while self.RolllAct do
            self.WeaponObject.HitCollider.Location = self.WeaponObject.Location + Vector.new(0, 0, 20)
            if self.WeaponObject:GetPathFollowingStatus() <= 0 then
                break;
            end
            
            wait(0.1)
        end
        
        self:ResetRolling()
    end)
    coroutine.resume(self.Cor)
    
end





function sRollingModule:DisActive()
    self.WeaponObject.Enable = true
    self.WeaponObject.Location = Vector.new(0,0,-100)
end



return sRollingModule;








