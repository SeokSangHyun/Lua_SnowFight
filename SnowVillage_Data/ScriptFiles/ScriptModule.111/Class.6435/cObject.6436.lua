
--! 해당 클래스는 모든 객체에 공통으로 사용되는 클래스입니다.
--# 안에 있는 프로퍼티들은 
--? 내용
--    오브젝트래퍼런스, 타입을 설정함


cC_Object = {}
cC_Object.__index = cC_Object


function cC_Object.new()
    local t = setmetatable({}, cC_Object)
    
    
    t.object = nil
    t.Name = ""
    t.Type = "none"
    
    return t
end


function cC_Object:hello()
    print("AA")
end



return cC_Object;

