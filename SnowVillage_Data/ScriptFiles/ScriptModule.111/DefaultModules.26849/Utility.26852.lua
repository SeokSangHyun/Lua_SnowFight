------------------------------------------------------------------------------------------------------------
-- 게임에 필요한 여러 기능들을 제공하는 모듈 스크립트에요.
-- 스크립트의 양을 줄이고자 제공
------------------------------------------------------------------------------------------------------------



local Utility = {}



-- 두 벡터 사이의 거리를 실수로 반환하여 줍니다.
-- VecDistance(Vector1, Vector2)
function Utility:VecDistance(VecA, VecB)
   local Distance = math.sqrt( (VecB.X - VecA.X)^2 + (VecB.Y - VecA.Y)^2 + (VecB.Z - VecA.Z)^2 )
   return Distance
end



-- 지정된 Vector지점에서 원하는 지름만큼의 거리에서 플레이어의 캐릭터를 찾아 반환하여줍니다.
-- ScanPlayerCharacter(시작지점 Vector, 스캔할 지름)
function Utility:ScanPlayerCharacter(position, radius)
   local players = Game:GetAllPlayer()
   
   for i = 1, #players do
       local character = players[i]:GetCharacter()
       if character ~= nil then
           local charPosition = character.Location
           
           local distance = Utility:VecDistance(position, charPosition)
           if distance < radius then
               return character
           end
       end
   end

   return nil
end



-- 지정된 Vector 지점에서 원하는 지름만큼의 거리 내에 있는 모든 플레이어 캐릭터들을
-- 찾아서 반환합니다. 반환값은 테이블 형식입니다.
-- ScanPlayerCharacterList(시작지점 Vector, 스캔할 지름)
function Utility:ScanPlayerCharacterList(position, radius)
   local charList = {}
   local players = Game:GetAllPlayer()
   
   for i = 1, #players do
       local character = players[i]:GetCharacter()
       if character ~= nil then
           local charPosition = character.Location
           
           local distance = Utility:VecDistance(position, charPosition)
           if distance < radius then
               table.insert(charList, character)
           end
       end
   end
   return charList
end



-- 매개변수로 받은 오브젝트 리스트에서 지정된 Vector에서 지름 내의 오브젝트를 반환합니다.
-- ScanObject(스캔할 오브젝트 리스트, 시작지점 Vector, 스캔할 지름)
function Utility:ScanObject(objectList, position, radius)
   
   for k, v in pairs(objectList) do
       if v ~= nil then
           local objectPosition = v.Location
           
           local distance = Utility:VecDistance(position, objectPosition)
           if distance < radius then
               return v
           end
       end
   end

   return nil
end



-- 매개변수로 받은 오브젝트 리스트에서 지정된 Vector에서 지름 내의 모든 오브젝트를 반환합니다.
-- ScanObjectList(스캔할 오브젝트 리스트, 시작지점 Vector, 스캔할 지름)
function Utility:ScanObjectList(objectList, position, radius)
   local outList = {}
   
   for k, v in pairs(objectList) do
       if v ~= nil then
           local objectPosition = v.Location
           
           local distance = Utility:VecDistance(position, objectPosition)
           if distance < radius then
               table.insert(outList, v)
           end
       end
   end

   return outList
end



-- 매개변수로 받은 오브젝트 리스트에서 해당 이름의 오브젝트를 찾아서 반환합니다.
-- GetObject(찾을 오브젝트 리스트, 찾을 이름)
function Utility:GetObject(objectList, name)
   for k, v in pairs(objectList) do
       if v ~= nil and v.Name == name then
               return v
       end
   end
   return nil
end



-- 지정된 두 벡터 사이의 스칼라곱을 계산하여 반환합니다.
-- DotProduct(Vector1, Vector2)
function Utility:DotProduct(vec1, vec2)
   return vec1.X * vec2.X + vec1.Y * vec2.Y + vec1.Z * vec2.Z
end



-- 지정된 두 벡터 사이의 벡터곱을 계산하여 반환합니다.
-- GetCrossVector(Vector1, Vector2)
function Utility:GetCrossVector(vec1, vec2)
   return Vector.new(vec1.Y * vec2.Z - vec1.Z * vec2.Y, vec1.Z * vec2.X - vec1.X * vec2.Z, vec1.X * vec2.Y - vec1.Y * vec2.X)
end



-- 지정된 두 벡터 사이의 각도를 계산하여 반환합니다.
-- GetAngle(Vector1, Vector2)
function Utility:GetAngle(vec1, vec2)
   local dot = Utility:DotProduct(vec1, vec2)
   local angle = math.acos(dot)
end



-- 특정 오브젝트의 위아래 흔들림 연출을 하기위한 함수입니다.
-- ObjectWave(지정 오브젝트, 흔들릴 횟수, 흔들림 크기, 각 흔들림별 대기시간)
function Utility:ObjectWave(object, count, wavePower, waveWaitTime)
   local objectTransform = object.Transform
   local normalLocation = objectTransform.Location
   local getTop = objectTransform:GetTop()
   for i = 1, count do
       objectTransform.Location = Vector.new(normalLocation.X + getTop.X * math.random(-wavePower, wavePower), 
                                   normalLocation.Y + getTop.Y * math.random(-wavePower, wavePower),
                                   normalLocation.Z + getTop.Z * math.random(-wavePower, wavePower))
       object.Transform = objectTransform
       wait(waveWaitTime)
   end
   objectTransform.Location = normalLocation
   object.Transform = objectTransform
end



-- 지정된 오브젝트의 색깔을 원하는 색깔로 시간에 맞게 변화시킵니다.
-- SetColorLinear(색을 변화할 오브젝트, 원하는 색, 완료되기까지 걸리는 시간)
function Utility:SetColorLinear(object, resultColor, linearTime)
   local count = 0
   local objectColor = object:GetColor()
   local r = (resultColor.R - objectColor.R) / (linearTime * 10)
   local g = (resultColor.G - objectColor.G) / (linearTime * 10)
   local b = (resultColor.B - objectColor.B) / (linearTime * 10)

   while count < linearTime do
       count = count + 0.1
       wait(0.1)
       objectColor.R = objectColor.R + r 
       if objectColor.R >= resultColor.R then
           objectColor.R = resultColor.R
       end
       objectColor.G = objectColor.G + g 
       if objectColor.G >= resultColor.G then
           objectColor.G = resultColor.G 
       end
       objectColor.B = objectColor.B + b 
       if objectColor.B >= resultColor.B then
           objectColor.B = resultColor.B
       end
       object:SetColor(objectColor)
   end
end

return Utility



