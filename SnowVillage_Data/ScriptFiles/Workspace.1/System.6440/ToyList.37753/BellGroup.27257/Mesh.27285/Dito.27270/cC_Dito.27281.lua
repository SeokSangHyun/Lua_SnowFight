
cC_Dito = {}


cC_Dito.__index = cC_Dito
-- '.'을 사용하면 함수 매개변수에 자동으로 self가 추가됨
-- ':'을 사용하면 self 인자를 추가해주어야함


function cC_Dito.new()
    local t = setmetatable({}, cC_Dito)
    
    t.toy = Script.Parent
    t.children = {t.toy.LargeGear, t.toy.SmallGear}
    
    return t
end



function cC_Dito.AnimSmallGear(self)
    Game:SendEventToServer("AnimSmallGear")
end


function cC_Dito.AnimLargeGear(self)
    Game:SendEventToServer("AnimLargeGear")
end




local ditoobj = cC_Dito.new()
ditoobj.AnimLargeGear()

