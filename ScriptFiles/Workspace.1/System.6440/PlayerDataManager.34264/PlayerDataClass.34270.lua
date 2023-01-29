-----------------------------------------------------------------------------------------------------
--서버에 저장되는 유저데이터 클래스
-----------------------------------------------------------------------------------------------------

local PlayerDataClass = {}
PlayerDataClass.__index = PlayerDataClass

-----------------------------------------------------------------------------------------------------
--서버에 저장할 데이터를 추가해요. (데이터 이름, 초기값, 동기화 여부, 로드후 호출할 함수, 값 변경시 호출할 함수)
--로드후 호출할 함수(dataLoadCallback)의 인자에 player가 있어야 한다.
--값 변경시 호출할 함수(changeCallback)의 인자에 player가 있어야 한다. changeCallback는 테이블에선 사용 불가!!!
function PlayerDataClass:AddValue(dataName, initValue, isSync, dataLoadCallback, changeCallback)
    local self = setmetatable({}, PlayerDataClass)    
    
    self._DataName = dataName
    self._InitValue = initValue
    self._IsSync = isSync
    self._DataLoadCallback = dataLoadCallback
    self._ChangeCallback = changeCallback
    self._SaveCallback = nil
    self._FirstLoginCallbackList = {}
    
    table.insert(PlayerDataList, self)
    
    return self
end

--서버에 저장할 테이블 데이터를 추가해요. (데이터 이름, 초기값, 로드후 호출할 함수)
--(테이블은 동기화, ChangeCallback가 의미가 없으므로 별도 함수로 추가해야한다.)
function PlayerDataClass:AddTableValue(dataName, initValue, dataLoadCallback)
    return PlayerDataClass:AddValue(dataName, initValue, false, dataLoadCallback, nil)
end

-----------------------------------------------------------------------------------------------------
--저장전에 호출할 함수를 추가해요.
--호출 함수(callback)의 인자에 player가 있어야 한다. 
function PlayerDataClass:AddSaveCallback(callback)
    self._SaveCallback = callback
end

-----------------------------------------------------------------------------------------------------
--첫 접속시 호출할 함수를 추가해요.
--호출 함수(callback)의 인자에 player와 value가 있어야 한다. 
function PlayerDataClass:AddFirstLoginCallbackList(callback)
    table.insert(self._FirstLoginCallbackList, callback)
end

-----------------------------------------------------------------------------------------------------
--서버에 저장된 데이터를 로드하고, 값이 없으면 초기값(InitValue)를 할당한다.
function PlayerDataClass:Load(player)
    local dataKey = self._DataName .. "_" .. PlayerDataVer
    local loadValue = Game:GetSavedUserGameData(player:GetPlayerID(), dataKey) 
    
    --서버에 저장된 데이터가 없을 경우 초기값 할당   
    if loadValue == nil then            
        loadValue = self._InitValue            
        --printc(self._DataName .. " LoadData : nil")
        
        --초기값인 경우, 콜백 함수 호출 (이 단계에선 아직 변수 선언전이므로 loadValue를 전달)
        for i = 1, #self._FirstLoginCallbackList do
            if self._FirstLoginCallbackList[i] ~= nil then
                self._FirstLoginCallbackList[i](player, loadValue)
            end
        end
    end    
    
    return loadValue
end

------------------------------------------------------------------------------------------------------
--동기화 여부(IsSync)에 따른 변수 선언        
function PlayerDataClass:Declaration(player, loadValue)
    local isTableData = (type(loadValue) == "table")
    local isNilValue = (loadValue == nil)
    
    --동기화 여부 설정시, 테이블 데이터가 아니면 
    if self._IsSync and not isTableData then
        if not isNilValue then
            player:AddReplicateValue(self._DataName, loadValue, Enum.ReplicateType.Changed, 0)            
            --printc("AddReplicateValue Complete - player. " .. self._DataName .. " = " .. player[self._DataName])
            return
        else  
            printc("초기값이 nil이면 AddReplicateValue를 사용할 수 없습니다. : " .. self._DataName)
            return
        end
    end
    
    --이외는 일반 변수로 선언  
    player[self._DataName] = loadValue
    --printc("Declaration Common Value - player. " .. self._DataName .. " = " .. player[self._DataName])
end

------------------------------------------------------------------------------------------------------
--서버 데이터 로드 끝나면 콜백 함수 호출
function PlayerDataClass:InvokeDataLoadCallback(player)
    if self._DataLoadCallback ~= nil then      
        self._DataLoadCallback(player)
    end
end

------------------------------------------------------------------------------------------------------
--값 변경시 이벤트 처리
function PlayerDataClass:AddChangeCallback(player)    
    if self._ChangeCallback ~= nil then
        player:ConnectChangeEventFunction(self._DataName, function(obj, value)        
            self._ChangeCallback(player)
        end)
    end
end

------------------------------------------------------------------------------------------------------
--서버에 데이터 저장
function PlayerDataClass:Save(player)
    if not player.IsEndServerDataLoad then
        return
    end
    
    --저장전에 호출할 함수 있는지 확인
    if self._SaveCallback ~= nil then
        self._SaveCallback(player)
    end

    local dataKey = self._DataName .. "_" .. PlayerDataVer
    local value = player[self._DataName]    
    Game:SaveUserGameData(player:GetPlayerID(), dataKey, value)  
end

------------------------------------------------------------------------------------------------------
--데이터를 초기값(InitValue)으로 초기화
function PlayerDataClass:Reset(player)
    player[self._DataName] = self._InitValue
    --printc(self._DataName .. " Reset!")
end

------------------------------------------------------------------------------------------------------
return PlayerDataClass