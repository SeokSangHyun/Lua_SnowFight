------------------------------------------------------------------------------------------------------
--데이터 처리
------------------------------------------------------------------------------------------------------
local DataName = "IsFirstLogin"
local InitValue = true

------------------------------------------------------------------------------------------------------
--로드후 호출할 함수(DataLoadCallback)의 인자에 player가 있어야 한다.
local DataLoadCallback = function(player)
    printc(DataName .. " DataLoadCallback " .. tostring(player[DataName]))
    
    --데이터 로드 후 필요한 처리가 있다면 아래에 작성
    if player[DataName] then
        player[DataName] = false
    end
end

------------------------------------------------------------------------------------------------------
--값 변경시 호출할 함수(ChangeCallback)의 인자에 player가 있어야 한다.
local ChangeCallback = function(player)
    printc(DataName .. " ChangeCallback " .. tostring(player[DataName]))
    
    --값이 바뀔때 마다 필요한 처리가 있다면 아래에 작성 (ex : UI 갱신)
end

------------------------------------------------------------------------------------------------------
--서버에 저장할 데이터를 추가해요. (데이터 이름, 초기값, 동기화 여부, 로드후 호출할 함수, 값 변경시 호출할 함수)
FirstLoginClass = PlayerDataClass:AddValue(DataName, InitValue, true, DataLoadCallback, ChangeCallback)