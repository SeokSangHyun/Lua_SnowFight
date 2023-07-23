


--!---------------------------- 상태 별 UI 처리 ------------------------------
--# 목적 : 로비 (처음 진입 시 UI 세팅)
function Init_LobbyUI()
    UIRoot.LobbyUI.Visible = true
    UIRoot.ReadyUI.Visible = false
    UIRoot.MainUI.Visible = false
    UIRoot.RewardUI.Visible = false
    

    local ui = UIRoot.LobbyUI
    ui.F_AskPopupPanel.Visible = false
    ui.F_ListPopupPanel.Visible = false
    ui.F_NoticePanel.Visible = true
end



--# 목적 : 준비 (처음 진입 시 UI 세팅)
function Init_ReadyUI()
    UIRoot.LobbyUI.Visible = false
    UIRoot.ReadyUI.Visible = true
    UIRoot.MainUI.Visible = false
    UIRoot.RewardUI.Visible = false
    
    local ui = UIRoot.ReadyUI
    ui.F_NoticePanel.Visible = true
end





--# 목적 : 게임 진입시 (처음 진입 시 UI 세팅)
function Init_GameUI()
    UIRoot.LobbyUI.Visible = false
    UIRoot.ReadyUI.Visible = false
    UIRoot.MainUI.Visible = true
    UIRoot.RewardUI.Visible = false


    local player = LocalPlayer:GetRemotePlayer()
    local ui = UIRoot.MainUI
    if player.PlayState == 2 then
        ui.BulletHUD.Visible = true
        ui.F_PlayLog.Visible = true
        ui.F_WarLog.Visible = true
        ui.F_Timer.Visible = true
        ui.F_RollingGuage.Visible = true
        ui.F_Death.Visible = true
        

        ui.F_Death.Visible = false
        ui.F_RollingGuage.Visible = false
        ui.F_NoticePanel.Visible = false
    else
        ui.BulletHUD.Visible = false
        ui.F_PlayLog.Visible = false
        ui.F_WarLog.Visible = false
        ui.F_Timer.Visible = false
        ui.F_RollingGuage.Visible = false
        ui.F_Death.Visible = false

        ui.F_Death.Visible = false
        ui.F_RollingGuage.Visible = false
        ui.F_NoticePanel.Visible = false
    end
end



--# 목적 : 리워드 상태 진입시 (처음 진입 시 UI 세팅)
function Init_RewardUI()
    UIRoot.LobbyUI.Visible = false
    UIRoot.ReadyUI.Visible = false
    UIRoot.MainUI.Visible = false
    UIRoot.RewardUI.Visible = true
    
    
    Toggle_StormButton(false)
end



