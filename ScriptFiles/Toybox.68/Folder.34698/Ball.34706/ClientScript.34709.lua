
local cor = nil
local object = Script.Parent


--! ------------------------------ 실행 ------------------------------





--! ------------------------------ 실 ------------------------------
function Script:Run()
    local Direction = LocalPlayer:GetCameraForward()
    local rotSpeed = 3
    local moveSpeed = 25

    print(Direction)

    if cor == nil then
        local dir_location = Vector.new(Direction.X, Direction.Y, 0)
        local dir_rot = Vector.new(-Direction.Z, -Direction.X, 0)
        
        object.Track:AddLocalRot("Rot", dir_rot*360, rotSpeed)
        object.Track:PlayTransformTrack("Rot", Enum.TransformPlayType.Repeat, InfinityPlay)
    
        cor = coroutine.create(function()
            while true do
                local pos = object.Location + dir_location * moveSpeed
            
                object.Location = pos
                print(rot)
                wait(0.05)
            end
            cor = nil
        end)
        coroutine.resume(cor)
    end
    
end
--! ------------------------------  ------------------------------





