------------------------------------------------------------------------------------------------------------
--캐릭터 스폰시 이름 HUD를 추가하는 스크립트에요.
------------------------------------------------------------------------------------------------------------

local IsUsePlayerNameHUD = Script.IsUsePlayerNameHUD
local IsUseScreenUI = Script.IsUseScreenUI
local PlayerNameUI = HUD.PlayerNameUI --HUD에 있는 PlayerNameUI 오브젝트를 PlayerNameUI 변수에 할당해요.
PlayerNameUI.Visible = false --PlayerNameUI를 비활성화해요.



----------------------------------------------------------------------------------------------------------
local function AddHUD(character) --OnSpawnCharacter로 연결된 함수는 character 인자가 고정적으로 들어가요.
    local UIName ="Name"
    
    local nameHUD = character:GetPlayerHUD(UIName)
    if nameHUD ~= nil then
        return --hud가 중복으로 추가되지 않게 해요.
    end
      

    local ui = nil
    if IsUseScreenUI then
        ui = character:AddPlayerHUD(UIName, PlayerNameUI, Enum.UIDisplayType.Screen) --캐릭터에 PlayerNameUI를 Screen 타입의 HUD로 추가해요.
    else
        ui = character:AddPlayerHUD(UIName, PlayerNameUI, Enum.UIDisplayType.Billboard) --캐릭터에 PlayerNameUI를 Billboard 타입의 HUD로 추가해요.
    end
    
    if ui ~= nil then
        ui.Text:SetText(character.Name) --추가한 hud에 캐릭터의 이름을 표시해요.
        ui.Text:SetTextColor(Color.new(255, 255, 255, 255)) --추가한 hud의 글자 색상을 변경해요.
        ui.Visible = true --추가한 hud를 비활성화해요.
    end
end

if IsUsePlayerNameHUD then
    Game.OnSpawnCharacter:Connect(AddHUD) --Game에 캐릭터가 생성되면 호출되는 함수를 연결해요.
end
