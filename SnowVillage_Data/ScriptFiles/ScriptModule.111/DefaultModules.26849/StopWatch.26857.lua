------------------------------------------------------------------------------------------------------------
-- 시간을 기록할 때 사용할 수 있는 모듈 스크립트에요.
------------------------------------------------------------------------------------------------------------



local StopWatch = {}
    
    
    
function StopWatch:new(ParentObject)
    if(ParentObject == nil) then
        print("StopWatch:new() ParentObject is nil")
        return
    end
    
    if(ParentObject.OnUpdateEvent == nil) then
        print("StopWatch:new() ParentObject has not OnUpdateEvent")
        return
    end
    
    local newObject = setmetatable({}, self)
    self.__index = self
          
    newObject:reset()
    
    local updateFunc = function(elapsedtime)
        newObject:update(elapsedtime)
    end    
      
    ParentObject.OnUpdateEvent:Connect(updateFunc)
       
    return newObject
end
    
        
                
function StopWatch:start()
    self._Start = true
end
   
        
                  
function StopWatch:update(elapsedTime)   
   if(self == nil) then
       print("StopWatch:update self nil")
       return
   end
      
   if(self._Start == false) then
       return
   end
    
   self._ElapsedTimeSec = self._ElapsedTimeSec + elapsedTime
        
   local naturalParts = math.floor( self._ElapsedTimeSec )
    
   self.Min = math.floor(naturalParts / 60)
   self.Min = math.min( self.Min, 99 )
   self.Sec = math.floor(naturalParts % 60)
   self.Sec = math.min( self.Sec, 99 )
   self.MilliSec = math.floor((self._ElapsedTimeSec - naturalParts)*100)
end
       
        
          
function StopWatch:stop()
    self._Start = false
end
        
        
        
function StopWatch:reset()
    self._Start = false
    self._ElapsedTimeSec = 0
    self.Min = 0
    self.Sec = 0
    self.MilliSec = 0
end
        
return StopWatch
