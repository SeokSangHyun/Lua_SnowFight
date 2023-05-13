-----------------------------------------------------------------------------------------------------
--서버에 저장할 유저데이터를 관리하는 매니저 (클라 처리용)
-----------------------------------------------------------------------------------------------------

local System = Script.Parent

ClientUserData = {} --클라용 테이블 데이터 리스트

IsEndClientDataLoad = false --로딩 완료 여부 초기화

------------------------------------------------------------------------------------------------------
local EndLoadCallbackList = {} --데이터 로드가 완전히 끝났을 때 호출할 클라 함수(PlayerDataClass의 DataLoadCallback와는 별개임)

--서버 데이터 로드 완전히 끝나면 호출할 콜백 함수 추가
function AddEndLoadCallbackList(callBack)
    table.insert(EndLoadCallbackList, callBack)
end

--서버 데이터 로드 완전히 끝나면 콜백 함수 호출
local function InvokeEndLoadCallbackList()
    for i = 1, #EndLoadCallbackList do
        if EndLoadCallbackList[i] ~= nil then      
            EndLoadCallbackList[i]()
        end
    end
    
    IsEndClientDataLoad = true
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
--테이블의 값을 바꿔주는 함수
--이 함수로 값을 바꿔줘야 서버or클라로 값이 전달됨. (테이블에 직접 접근해서 변경하지 말것!) 
function ChangeTableValue(dataName, ...)
    _G["ChangeTableValue_" .. dataName](...)
end

------------------------------------------------------------------------------------------------------
--서버에서 유저 데이터 로드 완료시 호출되는 함수
local function EndLoadData()    
    printc("EndLoadData")
    
    EndLoading() 
    
    --콜백 리스트 호출
    InvokeEndLoadCallbackList()
end
Game:ConnectEventFunction("EndLoadData", EndLoadData)