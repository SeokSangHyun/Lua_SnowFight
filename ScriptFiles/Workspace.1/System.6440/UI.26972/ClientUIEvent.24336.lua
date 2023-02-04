


--UI
local AskPopup = Workspace.UI.Popup.F_AskPopupPanel
local ListPopup = Workspace.UI.Popup.F_ListPopupPanel




--!---------------------------- Widget 변경 ------------------------------
--# 목적 : 
local function BulletCountUpdate(index, count)
    local cnt_text = BulletButtonList[index].Img_TextBackground.T_Count
    cnt_text:SetText("x" .. count)
end
Game:ConnectEventFunction("BulletCountUpdate_sToc", BulletCountUpdate)




