------------------------------------------------------------------------------------------------------------
-- 테이블과 관련된 기능을 제공합니다.
------------------------------------------------------------------------------------------------------------

-- 테이블의 구성 요소를 모두 출력해요
table.print = function(src_table)
   for i, e in pairs(src_table) do    
       if type(e) == "table" then
           table.print(e)
       else
          print(i,e) 
       end
   end
end



-- 테이블의 요소들을 섞어요
table.suffle = function(src_table)
    local to_idx = 0
    
    for i, e in ipairs(src_table) do
        to_idx = to_idx + 1
    end
  
    while(to_idx > 1) do
        local from_idx = math.random(to_idx - 1)
        src_table[from_idx], src_table[to_idx] =  src_table[to_idx], src_table[from_idx]
        to_idx = to_idx - 1
    end
end



-- 테이블의 요소 개수를 반환해요 
table.count = function(src_table)
    local result = 0
    
    for i, e in pairs(src_table) do        
        result = result + 1
    end
    
    return result
end



-- 테이블의 해당 키의 값들을 반환해요
table.findbykey = function(src_table, key)
    local result = {}
    
    for i, e in pairs(src_table) do        
        if type(e) == 'table' then
            local inner = table.findbykey(e, key)
            
            if (#inner > 0) then
                table.insert(result, table.findbykey(e, key))
            end
        else   
            if i == key then            
                table.insert(result, e)         
            end
        end
    end
   
    return result
end



-- 테이블의 값 각각에 적용할 함수를 인자로 넣어 적용해요
table.foreach = function(src_table, predicate)  
    for i, e in pairs(src_table) do
        if type(e) == "table" then
            table.foreach(e,predicate)
        else
            local outval = predicate(e)  
            
            if outval then
                src_table[i] = outval     
            end   
        end 
    end
end



-- find 함수의 재귀 함수에요
local function find_func(src_table, predicate, out_table) 
    for i, e in pairs(src_table) do
        if type(e) == "table" then
            find_func(e, predicate, out_table)
        else
            local bol = predicate(e)  
        
            if bol then
                table.insert(out_table, e)
            end
        end
    end
end



-- 해당 조건을 만족하는 테이블의 값 들을 반환해요
table.find = function(src_table, predicate)   
    local out_table = {}  
    find_func(src_table, predicate, out_table)
       
    return out_table
end



-- 해당 조건을 만족하는 값과 대응되는 테이블의 key를 반환해요 (앞에서 부터 체크)
table.findindex = function(src_table, predicate)
    for i, e in pairs(src_table) do
        if type(e) == "table" then
            local bol = table.findindex(e,predicate)
            if bol ~= nil then
                return i
            end
        else
            local bol = predicate(e)  
            
            if bol then
               return i
            end
        end  
    end   
    return nil
end



-- 해당 조건을 만족하는 값과 대응되는 테이블의 key를 반환해요 (뒤에서 부터 체크)
table.findlastindex = function(src_table, predicate)
    local result;
    for i, e in pairs(src_table) do
        if type(e) == "table" then
            local bol = table.findlastindex(e,predicate)
            if bol ~= nil then
                result = i
            end
        else
            local bol = predicate(e)  
            
            if bol then
                result = i
            end       
        end
    end    
    return result
end



-- 특정 값에 해당하는 테이블의 key를 반환해요 (앞에서 부터 체크)
table.indexof = function(src_table, value)
    for i, e in pairs(src_table) do
        if type(e) == "table" then
            local bol = table.indexof(e,value)
            if bol ~= nil then
                return i
            end
        else
            if e == value then
                return i
            end
        end
    end
    return nil
end



-- 특정 값에 해당하는 테이블의 key를 반환해요 (뒤에서 부터 체크)
table.lastindexof = function(src_table, value)
    local result;
    for i, e in pairs(src_table) do        
        if type(e) == "table" then
            local bol = table.indexof(e,value)
            if bol ~= nil then
                result = i
            end
        else  
            if e == value then
                result = i
            end
        end
    end
    
    return result
end



-- 테이블의 요소 순서를 반대로 바꿔요
table.reverse = function(src_table)
    local table_nokeylen = 0
    local result_table = {}
    
    for i, e in pairs(src_table) do
        if type(i) == "string" then
            result_table[i] = e
        else
            table.insert(result_table, e)
        end
    end
    
    for i, e in ipairs(result_table) do
       table_nokeylen = table_nokeylen + 1
    end
    
    local reverse_maxcnt = math.floor(table_nokeylen / 2)

    for key = 1, reverse_maxcnt do
       result_table[key], result_table[table_nokeylen + 1 - key] =  result_table[table_nokeylen + 1 - key], result_table[key]
    end
    
    return result_table
end



-- 테이블에서 특정 키들를 제거해요
table.removerange = function(src_table, remove_keys)            
    for i, e in pairs(remove_keys) do
        for j, t in pairs(src_table) do
            if type(t) == "table" then
                table.removerange(t,remove_keys)
            end  

            if type(e) == "string" then          
                if e == j then
                    src_table[e] = nil
                    break
                end
            else
                if e == j then
                    table.remove(src_table, e)
                    break
                end
            end
        end
    end
end



-- 내림차순으로 정렬 비교 함수에요
local function descend_comp(a,b)
    local a_str = a[1]
    local b_str = b[1]
    
    if type(a_str) == "number" then
         a_str = tostring(a_str)
    end
    
    if type(b_str) == "number" then
         b_str = tostring(b_str)
    end
    
    return a_str > b_str
end



-- 오름차순 정렬 비교 함수에요
local function ascend_comp(a,b)
    local a_str = a[1]
    local b_str = b[1]
    
    if type(a_str) == "number" then
         a_str = tostring(a_str)
    end
    
    if type(b_str) == "number" then
         b_str = tostring(b_str)
    end
    
    return a_str < b_str
end



-- 테이블을 내림차순으로 정렬해요
table.descendsort = function(src_table)            
    local result_table = {}
    local remain_table = {}
    
    for i, e in pairs(src_table) do
        if type(i) == "number" then        
            if type(e) == "table" then
                table.insert(remain_table, e)
            else
                local inner_table = {}
        
                table.insert(inner_table, src_table[i])
                table.insert(result_table, inner_table)
            end
        else 
            remain_table[i] = e
        end
    end
    
    table.sort(result_table, function(a, b) return descend_comp(a,b) end)
    
    for i, e in pairs(remain_table) do
        if type(i) == "number" then
            table.insert(result_table, e)
        else
            result_table[i] = e
        end
    end
    
    return result_table
end



-- 테이블을 오름차순으로 정렬해요
table.ascendsort = function(src_table)            
    local result_table = {}
    local remain_table = {}
    
    for i, e in pairs(src_table) do
        if type(i) == "number" then        
            if type(e) == "table" then
                table.insert(remain_table, e)
            else
                local inner_table = {}
       
                table.insert(inner_table, src_table[i])
                table.insert(result_table, inner_table)
            end
        else 
            remain_table[i] = e
        end
    end
    
    table.sort(result_table, function(a, b) return ascend_comp(a,b) end)
    
    for i, e in pairs(remain_table) do
        if type(i) == "number" then
            table.insert(result_table, e)
        else
            result_table[i] = e
        end
    end
    
    return result_table
end



-- 테이블의 키 값들을 반환해요
table.keys = function(src_table)            
    local result = {}
    for i, e in pairs(src_table) do
        table.insert(result, i)
    end
    
    return result
end

return setmetatable({}, table)