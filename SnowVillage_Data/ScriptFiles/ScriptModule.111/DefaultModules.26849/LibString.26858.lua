------------------------------------------------------------------------------------------------------------
-- 문자열과 관련된 기능을 제공합니다.
-- 영어 외의 문자열을 다룰때는 utf8 라이브러리를 같이 사용해야 합니다
-- utf8.offset(s, n) : 문자열 s 의 n 번째 시작 바이트를 리턴합니다
-- utf8.len(s) : 문자열 s 의 길이를 리턴합니다
------------------------------------------------------------------------------------------------------------



-- 한글이 3바이트로 되어 있어 subtext를 만들어 사용해요
string.subtext = function(src_string, start_idx, end_idx)
    local start_utf8_idx = utf8.offset(src_string, start_idx)

    if end_idx == nil then
        return string.sub(src_string, start_utf8_idx)
    end
    
    local end_utf8_idx = utf8.offset(src_string, end_idx + 1) - 1

    return string.sub(src_string, start_utf8_idx, end_utf8_idx)
end



-- 한글이 3바이트로 되어 있어 findtext를 만들어 사용해요
string.findtext = function(src_string, separator, from)
    local result_utf8_separator_from, result_utf8_separator_to = string.find( src_string, separator, utf8.offset(src_string, from) )

    if result_utf8_separator_from == nil then
        return nil, nil, result_utf8_separator_from, result_utf8_separator_to
    end
     
    local cur_idx = from
    local result_separator_from = nil
    local result_separator_to = nil
    local src_len = utf8.len(src_string)

    while true do
        local utf_from = utf8.offset(src_string, cur_idx)
        local utf_to = utf8.offset(src_string, cur_idx + 1) - 1
     
        if utf_from == result_utf8_separator_from then
            result_separator_from = cur_idx
        end
        
        if utf_to == result_utf8_separator_to then
            result_separator_to = cur_idx
        end   
        
        cur_idx = cur_idx + 1
        
        if (result_separator_from and result_separator_to) or (cur_idx == (src_len + 1))then
            break
        end  
    end 
      
    return result_separator_from, result_separator_to, result_utf8_separator_from, result_utf8_separator_to
end



-- 한글이 3바이트로 되어 있어 reversetext를 만들어 사용해요
string.reversetext = function(src_string)
    local src_utf8_len = utf8.len(src_string)
    
    if src_utf8_len == nil then
        return src_string
    end
    
    local result = ""
    
    for idx = src_utf8_len , 1, -1 do
        result = result .. string.subtext(src_string, idx, idx)
    end
    
    return result
end



-- 문자열을 특정 문자를 기준으로 잘라요.
string.split = function(src_string, separator)
    local result = { }
    local from = 1
    local separator_from, separator_to, separator_utf8_from, separator_utf8_to = string.findtext( src_string, separator, from )
    
    
    if separator_utf8_from == nil then
        table.insert( result, src_string)
        return result
    end
    
    
    while separator_utf8_from do
        if from <= (separator_from - 1)  then
            table.insert( result, string.subtext( src_string, from , separator_from - 1) )
        end
        from = separator_to + 1
        separator_from, separator_to, separator_utf8_from, separator_utf8_to = string.findtext( src_string, separator, from )
    end
    
    table.insert( result, string.subtext( src_string, from ) )
    return result
    
end



-- 문자열의 특정 인덱스부터 일정 개수 만큼의 문자열을 삭제해요
string.remove = function(src_string, start_idx, remove_cnt)
    local src_utf8_len = utf8.len(src_string)    
    
    if (start_idx > src_utf8_len) or (start_idx < 1) then
        return src_string
    end
    
    local postfix = nil
    local result_string = nil
    
    if ( (start_idx + remove_cnt) <= src_utf8_len ) then
        postfix = string.subtext(src_string, start_idx + remove_cnt)
    end
    
    if start_idx == 1 then
        result_string = postfix
    else
        if postfix ~= nil then
            result_string = string.subtext(src_string, 1, start_idx -1) .. postfix
        else
            result_string = string.subtext(src_string, 1, start_idx -1)
        end
    end
    
    return result_string
end



-- 이 문자열의 원하는 위치에 문자열 삽입해요
string.insert = function(src_string, insert_string, insert_idx)
    local src_utf8_len = utf8.len(src_string)
   
    if (insert_idx < 1) then
        insert_idx = 1
    end
    
    if insert_idx == 1 then
        return insert_string.. string.subtext(src_string, insert_idx)
    elseif (insert_idx > src_utf8_len) then
        return string.subtext(src_string, 1, src_utf8_len) ..insert_string
    else
        return string.subtext(src_string, 1, insert_idx -1) ..insert_string.. string.subtext(src_string, insert_idx)
    end
  
end



-- 특정 문자열을 원하는 문자열로 대체해요
string.replace = function(src_string, old_string, new_string)
    local result_string = src_string
    local search_start_idx = 1

    while true do
        local start_idx, end_idx, start_utf8_idx, end_utf8_idx = string.findtext(result_string, old_string, search_start_idx )
        
        if start_utf8_idx == nil then
            break
        end

        local postfix = string.subtext(result_string, end_idx + 1)
        result_string = string.subtext(result_string, 1, (start_idx - 1)) .. new_string .. postfix

        search_start_idx = -1 * utf8.len(postfix)
    end

    return result_string
end



-- 두 문자열의 크기를 비교해요 ( option에 true를 넣으면 대소문자 구분 안함)
string.compare = function(src_string, comp_string, option)
    local result_src_string = ""
    local result_comp_string = ""
    local src_utf8_len = utf8.len(src_string)
    local comp_utf8_len = utf8.len(comp_string)

    if option == true then
        for idx = 1 , src_utf8_len do
           local str_char = string.subtext(src_string, idx, idx)
           local str_char_len = string.len(str_char) 
                
           if str_char_len == 1 then
               result_src_string = result_src_string .. string.upper(str_char)
           else
               result_src_string = result_src_string .. str_char
           end 
        end
          
        for idx = 1 , comp_utf8_len do        
           local comp_char = string.subtext(comp_string, idx, idx)
           local comp_char_len = string.len(comp_char) 

           if comp_char_len == 1 then
               result_comp_string = result_comp_string .. string.upper(comp_char)
           else
               result_comp_string = result_comp_string .. comp_char
           end 
        end
    else
        result_src_string = src_string
        result_comp_string = comp_string
    end
                         
    -- 반환값이 0이면 두 문자열이 동일, -1이면 src 문자열보다 비교하는 문자열이 더 뒤에 있는 경우, 1은 비교하는 문자열이 앞에 있는 경우
    if result_src_string == result_comp_string then
        return 0 
    elseif result_src_string < result_comp_string then
        return -1
    else
        return 1  
    end
end



-- 이 문자열 인스턴스가 지정한 문자로 시작하는지를 확인해요
string.startswith = function(src_string, comp_string)
    local comp_utf8_len = utf8.len(comp_string)
    return string.subtext(src_string, 1, comp_utf8_len) == comp_string
end



-- 이 문자열 인스턴스의 끝부분과 지정한 문자가 일치하는지를 확인해요
string.endswith = function(src_string, comp_string)
    local comp_utf8_len = utf8.len(comp_string)
    local src_utf8_len = utf8.len(src_string)
    
    return comp_string == "" or (string.subtext(src_string, src_utf8_len - comp_utf8_len + 1) == comp_string)
end



-- 이 문자열내의 문자 위치 가져와요
string.indexof = function(src_string, comp_string, start_idx)
    local src_utf8_len = utf8.len(src_string)
    
    if start_idx == nil then
        start_idx = 1
    end
    
    if start_idx > src_utf8_len then
        return nil
    end
    
    local result_idx = string.findtext(src_string, comp_string, start_idx)
    return result_idx
end



-- 이 문자열내의 문자 위치 가져와요 (뒤에서부터 시작)
string.lastindexof = function(src_string, comp_string)
    local src_utf8_len = utf8.len(src_string)
    local reverse_str = string.reversetext(src_string)
                
    return src_utf8_len - string.findtext(reverse_str, comp_string, 1) + 1
end



-- 이 문자열에 해당 문자열이 있는지 확인해요
string.contains = function(src_string, comp_string)
    local from, to, utf8_from, utf8_to = string.findtext(src_string, comp_string, 1)
    return utf8_from ~= nil
end



-- 앞쪽, 뒤쪽 공백을 모두 제거해요
string.trim =function(src_string)
    return string.gsub(src_string, "^%s*(.-)%s*$", "%1")
end



-- 앞쪽 공백을 모두 제거해요
string.trimstart = function(src_string)
    return string.gsub(src_string, "^%s*(.-)$", "%1")
end



-- 뒤쪽 공백을 모두 제거해요
string.trimend = function(src_string)
    return string.gsub(src_string, "^(.-)%s*$", "%1")
end

return setmetatable({}, string) 
