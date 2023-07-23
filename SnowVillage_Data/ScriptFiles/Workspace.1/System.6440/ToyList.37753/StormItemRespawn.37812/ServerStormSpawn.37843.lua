
StormItemSpawner = Script

local IsSpawn = false
local IsGain = false


local Toy = Toybox.StormItem
local SpawnList = Script.Parent.SpawnList:GetChildList()




function StormItemSpawner:Spawn()
    if not IsSpawn and not IsGain then
        IsSpawn = true
    
        local index = math.random(1, #SpawnList)
        local SpawnPos = SpawnList[math.floor(index)].Location
        --local FXPos = Vector.new( math.random(-30000, 30000) , math.random(-30000, 30000) , 4000 )
        local FXPos = Vector.new( math.random(-3000, 3000) , math.random(-3000, 3000) , 4000 )
        
        local obj = Game:CreateSyncObject(Toy, SpawnPos)
        local fxObj = obj.PrevFX
        fxObj.Location = SpawnPos + FXPos
        
        Game:BroadcastEvent("AddNotice_sToc", "하늘에서 태풍의 결정이 곧 떨어집니다.", 1)
        
        
        local dist = Vector.new(obj.BoxCollider.Location.X - fxObj.Location.X, obj.BoxCollider.Location.Y - fxObj.Location.Y, obj.BoxCollider.Location.Z - fxObj.Location.Z)
        
        fxObj.Track:AddEmpty("Move", 5)
        fxObj.Track:AddLocalMove("Move", dist, 1.5, true)
        fxObj.Track:PlayTransformTrack("Move", Enum.TransformPlayType.Repeat , 1)
        
        local cor = coroutine.create(function(obj)
            wait(5+1.5)
            obj.BoxCollider.Spray:Play()
            obj.Sound.Sound:Play()
            Game:BroadcastEvent("StormItemSpawnComplete")
        end)
        coroutine.resume(cor, obj)
        
        
        --obj.BoxCollider.Collision:SetCharacterCollisionResponse(Enum.CollisionResponse.Overlap)
        obj.BoxCollider.Collision.OnCollisionEvent:Connect(function(self, target)
            if target == nil or not target:IsCharacter() then;    return;    end;
            
            local player = target:GetPlayer()
            GainOwner(player)
            Game:DeleteObject(self.Parent)
        end)
        
    end
end








