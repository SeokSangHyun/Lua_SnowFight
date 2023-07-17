------------------------------------------------------------------------------------------------------------
-- 시간과 관련된 기능을 제공합니다.
------------------------------------------------------------------------------------------------------------
local TimeUtil = {}

--시간 테이블을 만들 수 있습니다.-------------------------------------------------------------------------
function TimeUtil.new(year,month,day,hour,minute,second)
    if year == nil then
       return DateTime.new()
    elseif hour == nil then
       return DateTime.new(year,month,day)
    else
       return DateTime.new(year,month,day,hour,minute,second)
    end
end

--시간 포맷을 설정 할 수 있습니다.-------------------------------------------------------------------------
function TimeUtil.ToString(datetime, dateformat)
   return datetime:ToString(dateformat)
end

--다음 해인지 체크 할 수 있습니다.-------------------------------------------------------------------------
function TimeUtil.IsChangedYear(systemDate, compareDate)
   return IsChangedYear(systemDate,compareDate)
end

--다음 월인지 체크 할 수 있습니다.--------------------------------------------------------------------------
function TimeUtil.IsChangedMonth(systemDate, compareDate)
   return IsChangedMonth(systemDate,compareDate)
end

--다음 날인지 체크 할 수 있습니다.--------------------------------------------------------------------------
function TimeUtil.IsChangedDay(systemDate, compareDate)
   return IsChangedDay(systemDate,compareDate)
end

--다음 주인지 체크 할 수 있습니다.---------------------------------------------------------------------------
function TimeUtil.IsChangedWeek(systemDate, compareDate)
   return IsChangedWeek(systemDate,compareDate)
end

--두 날짜의 차이 년, 월, 일, 시간, 분, 초를 얻을 수 있습니다.----------------------------------------------------
function TimeUtil.GetCompareYear(systemDate, compareDate)
   return GetCompareYear(systemDate,compareDate)
end

function TimeUtil.GetCompareMonth(systemDate, compareDate)
   return GetCompareMonth(systemDate,compareDate)
end

function TimeUtil.GetCompareDay(systemDate, compareDate)
   return GetCompareDay(systemDate,compareDate)
end

function TimeUtil.GetCompareHour(systemDate, compareDate)
   return GetCompareHour(systemDate,compareDate)
end

function TimeUtil.GetCompareMinute(systemDate, compareDate)
   return GetCompareMinute(systemDate,compareDate)
end

function TimeUtil.GetCompareSec(systemDate, compareDate)
   return GetCompareSec(systemDate,compareDate)
end

--ostime을 Date로 변환 해줍니다. ------------------------------------------------------------------------------
function TimeUtil.ToDateTime(ostime)
   return ToDateTime(ostime)
end

--Date를 ostime로 변환 해줍니다. ------------------------------------------------------------------------------
function TimeUtil.ToOsTime(indate)
   return ToOsTime(indate)
end

--올해 기준 경과일을 반환 해줍니다. ---------------------------------------------------------------------------
function TimeUtil.GetDayOfYear(indate)
   return GetDayOfYear(indate)

end

--올해 기준 주차를 ostime로 변환 해줍니다. --------------------------------------------------------------------
function TimeUtil.GetWeekOfYear(indate)
   return GetWeekOfYear(indate)
end

--이번 주 기준으로 요일 번호 반환 합니다.----------------------------------------------------------------------
function TimeUtil.GetNumberOfWeek(indate)
   return GetNumberOfWeek(indate)
end

return TimeUtil