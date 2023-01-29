-----------------------------------------------------------------------------------------------------
--서버에 저장할 유저데이터를 관리하는 매니저
-----------------------------------------------------------------------------------------------------

local System = Script.Parent

PlayerDataClass = require(System.PlayerDataClass)
PlayerDataList = {}   --PlayerDataClass:AddValue로 추가한 데이터 리스트

PlayerDataVer = Config.PlayerDataVer --테스트용 값
local MinWaitTime = 2 --최소 대기 시간

------------------------------------------------------------------------------------------------------
local EndLoadCallbackList = {} --데이터 로드가 완전히 끝났을 때 호출할 서버 함수(PlayerDataClass의 DataLoadCallback와는 별개임)

--서버 데이터 로드 완전히 끝나면 호출할 콜백 함수 추가
function AddEndLoadCallbackList(callBack)
    table.insert(EndLoadCallbackList, callBack)
end

--서버 데이터 로드 완전히 끝나면 콜백 함수 호출
function InvokeEndLoadCallbackList(player)
    for i = 1, #EndLoadCallbackList do
        if EndLoadCallbackList[i] ~= nil then      
            EndLoadCallbackList[i](player)
        end
    end
    
    player.IsEndServerDataLoad = true
end

------------------------------------------------------------------------------------------------------
--센드이벤트에서 사용하는 이벤트 이름이 겹치지 않도록 자동 완성해주는 함수
function GetTableEventNameList(dataName)
    local temp =
    {
        Init_ServerToClient   = dataName .. "_Init_ServerToClient",   --서버에서 데이터를 불러온 뒤, 클라로 넘겨주기 위한 이벤트 이름
        Change_ServerToClient = dataName .. "_Change_ServerToClient", --서버에서 데이터를 변경한 뒤, 클라로 넘겨주기 위한 이벤트 이름
        Change_ClientToServer = dataName .. "_Change_ClientToServer", --클라에서 데이터를 변경한 뒤, 서버로 넘겨주기 위한 이벤트 이름
    }
    return temp
end

------------------------------------------------------------------------------------------------------
--이름에 해당하는 PlayerDataClass를 찾아서 반환
function FindPlayerData(findName)
    for i = 1, #PlayerDataList do
        if PlayerDataList[i]._DataName == findName then
            return PlayerDataList[i]
        end
    end

    printc(findName .. "를 PlayerData에서 찾을 수 없습니다.")
    return nil
end

------------------------------------------------------------------------------------------------------
--테이블의 값을 바꿔주는 함수 (테이블에 직접 접근해서 변경하지 말것!)
--이 함수로 값을 바꿔줘야 서버or클라로 값이 전달됨.
function ChangeTableValue(dataName, ...)
    _G["ChangeTableValue_" .. dataName](...)
end

------------------------------------------------------------------------------------------------------
--로딩이 끝난 뒤(TitleUI), 데이터 로드 시작
local function StartLoadData(player)    
    player.IsEndServerDataLoad = false --로딩 완료 여부 초기화
    wait(MinWaitTime)
    
    --유저 데이터 처리
    for i = 1, #PlayerDataList do
        local data = PlayerDataList[i]
    
        local loadValue = data:Load(player)  
        data:Declaration(player, loadValue)
                
        data:AddChangeCallback(player)  
    end
    
    --로드 완료 처리    
    Game:SendEventToClient(player:GetPlayerID(), "EndLoadData")
    
    --로드 다 끝나면 데이터별로 콜백 함수 호출
    for i = 1, #PlayerDataList do
        local data = PlayerDataList[i]
        data:InvokeDataLoadCallback(player)
    end
    
    --콜백 리스트 호출
    InvokeEndLoadCallbackList(player)
end
Game:ConnectEventFunction("StartLoadData", StartLoadData)

------------------------------------------------------------------------------------------------------
--플레이어 종료시 데이터 저장 처리
function SavePlayerData(player) 
    for i = 1, #PlayerDataList do
        local data = PlayerDataList[i]
        data:Save(player)
    end
    
    printc("End SavePlayerData")
end
Game.OnLeavePlayer:Connect(SavePlayerData)

------------------------------------------------------------------------------------------------------
--모든 데이터를 초기값으로 초기화
function ResetPlayerData(player)
    for i = 1, #PlayerDataList do
        local data = PlayerDataList[i]
        data:Reset(player)
    end
    
    printc("ResetPlayerData")
end
Game:ConnectEventFunction("ResetPlayerData", ResetPlayerData)