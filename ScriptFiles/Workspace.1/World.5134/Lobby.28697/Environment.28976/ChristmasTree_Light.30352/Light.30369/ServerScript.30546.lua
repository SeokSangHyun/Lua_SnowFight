------------------------------------------------------------------------------------------------------------
--스위치 동작을 처리하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

-- 스위치 충돌 처리 (On) 

local Trigger = Script.Parent.Parent.Switch.Box    --충돌 오브제
local LightOn = false

local function Collision(self, target)  -- 충돌하면 Light On
    if target ~= nil and target:IsCharacter() then
        --if LightOn then return end  -- 중복 충돌 방지
        if not LightOn then
            LightOn = true
            Game:BroadcastEvent("LightToggle", true)  --모든 Client의 LightToggle 함수 실행
        else
            LightOn = false     
            Game:BroadcastEvent("LightToggle", false)
        end
    end
end
Trigger.Collision.OnBeginOverlapEvent:Connect(Collision)

--------------------------------------------------------------------------------------

-- 새로 들어온 클라이언트와 현재 트리의 라이트 OnOff 상태 동기화 시키기 위한 처리

local function ReturnSwitchStatus(player)
    --Game:SendEventToClient(player:GetName(), "UpdateLightStats", LightOn)
end
Game:ConnectEventFunction("ReturnSwitchStatus", ReturnSwitchStatus)

