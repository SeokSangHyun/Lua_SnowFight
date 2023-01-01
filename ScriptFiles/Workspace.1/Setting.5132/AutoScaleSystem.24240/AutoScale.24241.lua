
wait(1)
--! ------------------------------ 해상도 비율 계산 ------------------------------
Script.Parent.ScreenUI.Frame.Anchor = Enum.WidgetAnchorType.RightBottom
Script.Parent.ScreenUI.Frame.UIPosition = Vector.new( 0,0,0 )
Script.Parent.ScreenUI.Frame.Anchor = Enum.WidgetAnchorType.LeftTop

local dev_ScreenSize = Script.DevelopScreenSize
local now_ScreeSize = Script.Parent.ScreenUI.Frame.UIPosition



--! ------------------------------ 해상도 산정 ------------------------------
--# 목적 : now와 dev를 비교하는 함수
--? 내용 : dev환경에서 now의 변화량 비율을 계산
--?        비율이 작은쪽을 선택하여 모든 ScreenUI 에 있는 UI 조절
local rate = Vector.new( now_ScreeSize.X / dev_ScreenSize.X , now_ScreeSize.Y / dev_ScreenSize.Y, 0)
local ChangeRate = 1
local m_rate = 0
if rate.X < rate.Y then
    ChangeRate = rate.X    
else
    ChangeRate = rate.Y
end

--? 최소 , 최대 처리
if ChangeRate < 0.1 then
    ChangeRate = 0.1
end

local IsMobileTouchScreen = Input:IsMobileTouchScreen()

---------- ---------- ---------- UI 컴포넌트 검사 ---------- ---------- ----------
-- 1. UI 컴포넌트를 인자로 받아온다.
-- 2. Text 오브젝트일 경우 변경이 가능하도록함
---------- ---------- ---------- ---------- ---------- ---------- ----------
local function CheckUIObjectName(uiobj)
    local isFrame = string.find( uiobj.Name, "Panel" )
    local isButton = string.find( uiobj.Name, "BTN" )

    if isFrame ~= nil or isButton ~= nil then
        if IsMobileTouchScreen == true then
            m_rate = ChangeRate * 0.90
        else
            m_rate = ChangeRate
        end

        return true
--[[
    elseif isButton ~= nil then
        return true
]]--
    end
    return false
end



---------- ---------- ---------- UI Text 변경 ---------- ---------- ----------
-- 제귀 함수로 구성하였음
-- UI의 유연한 트리 구조에 적응할 수 있도록 n차 트리 검색을 시행함
-- UI 구조를 악의적으로 복잡하게 할 경우 성능상 문제가 발생할 수 있음
---------- ---------- ---------- ---------- ---------- ---------- ----------
function findUIComponent(root, uiwidgettype)
    --print(root.Name)
    local child = root:GetChildList()
    local b = false
    local index = 0

--* 종료 조건을 적어보자
    if #child <= 0 then
        if CheckUIObjectName( root ) then
            return true;
        else
            return false
        end
    else
            for childindex = 1, #child do
            
                    b = findUIComponent(child[childindex], uiwidgettype)
                    if b == true then
                        --child[childindex].UIPosition = Vector.new( child[childindex].UIPosition.X * ChangeRate , child[childindex].UIPosition.Y, 0)
                        child[childindex].UIScale = m_rate
                    end
                    
                    index = childindex
            end

            if index == #child then
                if CheckUIObjectName( root ) then
                    --child[childindex].UIPosition = Vector.new( child[childindex].UIPosition.X * ChangeRate , child[childindex].UIPosition.Y, 0)
                    root.UIScale = m_rate
                end
            end
    end

    return 
end



---------- ---------- ---------- UI 검색 ---------- ---------- ----------
-- 1. 월드트리 (Workspace)에서 ScreenUI를 검색합니다.
-- 2. 추후 SurfaceUI도 검색하도록 구성해야함
---------- ---------- ---------- ---------- ---------- ---------- ----------
local allui_list = {}
function SearchAllUIComponent()

    local objects = Game:FindObjects( Workspace, Enum.ObjectType.ScreenUI )
    local num

    for i = 1, #objects do
        findUIComponent(objects[i], Enum.UIWidgetType.None )
    end
    
end
SearchAllUIComponent()
