
local WaitTime = 0.1
local FrameTime = 0.0



--!---------------------------- 데이터 세팅 ------------------------------
Game:AddReplicateValue("CtrlMoveForward", false, Enum.ReplicateType.Changed, 0)
Game:AddReplicateValue("CtrlMoveRight", false, Enum.ReplicateType.Changed, 0)





function EquipItem(player)
    player:GiveItem(Toybox.SnowFight)
    player:EquipInventoryItem(1)
end







--!---------------------------- 처리 ------------------------------
function GetBulletItem(player, index)
    local playerID = player:GetPlayerID()
    local bulletcnt = g_PlayerList[ tostring(playerID) ]:GetItem(player, index)
    
    Game:SendEventToClient(playerID, "BulletCountUpdate_sToc", index, bulletcnt)
end
Game:ConnectEventFunction("GetBulletItem_cTos", GetBulletItem)












--!---------------------------- 공 굴리기 처리 ------------------------------
-- function ServerMainTimer()
--     FrameTime

--     if g_Player:GetWeaponIndex() == 1 then
--         if cor1 == nil then
--             cor1 = coroutine.create(function()
--                 StandardTime = time()
--                 while true do
--                     WaitTime = time() - StandardTime
-- --* 눈덩이 커지는 로직
--                     if SnowBallState == 2 then
--                         if WaitTime > MAX_ROLLINGTIME then
--                             RollingUI.Visible = false
--                             local forward = LocalPlayer:GetCameraForward()
--                             Game:SendEventToServer("RollingThrow_cTos", forward.X, forward.Y, forward.Z)
--                             break;
--                         else
                            
--                             RollingSystem(WaitTime)
--                             if not Is_RollingKey then
--                                 local forward = LocalPlayer:GetCameraForward()
--                                 Game:SendEventToServer("RollingThrow_cTos", forward.X, forward.Y, forward.Z)
--                                 break;
--                             end
--                         end

-- --* 굴리기인지 던지기인지 판별
--                     elseif SnowBallState == 1 then
--                         if WaitTime > MAX_INPUTTIME then
--                             RollingUI.ProgressBar:SetPercent(0)
--                             RollingUI.Visible = true
--                             WaitTime = 0
--                             StandardTime = time()
--                             SnowBallState = 2
--                             --g_Player:PreFire()
--                             Game:SendEventToServer("RollingSystemStart_cTos")
--                         else
--                             if not Is_RollingKey then
--                                 local character = LocalPlayer:GetRemotePlayer():GetCharacter()
--                                 character:ChangeAnimState("Throw")
--                                 break;
--                             end
--                         end

--                     else;   return; end;
--                     wait(0.05)
--                 end
--                 --::Continue::
--                 Init_SnowBallRolling()
--                 cor1 = nil
--             end)

--             coroutine.resume(cor1)
--         end
--     end




--     Game:AddTimeEvent("TimeCheck", WaitTime, ServerMainTimer)
-- end
--Game:AddTimeEvent("TimeCheck", WaitTime, ServerMainTimer)


