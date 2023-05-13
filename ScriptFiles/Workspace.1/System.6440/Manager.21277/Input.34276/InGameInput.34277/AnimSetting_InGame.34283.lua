--[[
--! ------------------------------ 애니메이션 세팅 ------------------------------

local Object = Script.Parent --Script의 부모 오브젝트(AnimationSetting)를 Object 변수에 할당해요.
local IdleName = Object.Idle
local AnimStateMachineSetting = Game:AddAnimStateMachineSetting("ArcherCharacterAnim") --캐릭터에 사용될 애니메이션 상태머신 설정을 추가해요.


local function GetIdleRandom()
    return math.random(5, 20)
end

AnimStateMachineSetting.IsStand = true;
AnimStateMachineSetting.IdleChangeCount = 0
AnimStateMachineSetting.CheckIdle = GetIdleRandom()


------------------------------------------------------------------------------------------------------------
-- 캐릭터의 애니메이션 스테이트 머신을 설정해요
local function AnimStateMachineOnUpdate(AnimStateMachine, ElapsedTime)

    if AnimStateMachine == nil then
        return
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return
    end
    
    RemotePlayer = LocalPlayer:GetRemotePlayer()
    if RemotePlayer == nil then
        return
    end
    if RemotePlayer:GetCharacter() ~= character then
        return
    end

    if character ~= nil and character:GetCurAnimState() ~= nil then
        if AnimStateMachine.IsStand and character:GetCurAnimState().Name ~= IdleName then
            AnimStateMachine.IdleChangeCount = AnimStateMachine.IdleChangeCount + ElapsedTime
        end
    end
end

AnimStateMachineSetting.OnUpdate:Connect(AnimStateMachineOnUpdate)


------------------------------------------------------------------------------------------------------------
--캐릭터의 이동 속도를 반환하는 함수에요.
local function Idle_Run_BlendFunction(AnimStateMachine)
    if AnimStateMachine == nil then
        return 0
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return 0
    end

   return character:GetMoveSpeed()
end



------------------------------------------------------------------------------------------------------------
--단일 애니메이션을 플레이하는 애니메이션 상태를 추가해요. 

--Stand
local AnimState = AnimStateMachineSetting:AddAnimState("Stand", Object.Bow_Stand, InfinityPlay) 

--Idle
AnimState = AnimStateMachineSetting:AddAnimState("Idle", Object.Bow_Stand, 1) 
AnimState:SetNeedReplicate(true)

--Move
AnimState = AnimStateMachineSetting:AddBlendAnimState("Move", Idle_Run_BlendFunction, InfinityPlay)

--Walk
AnimState:AddBlendAnimation(0.0, Object.Bow_Walk, 0.6)
AnimState:AddBlendAnimation(150.0, Object.Bow_Walk)

--Run
AnimState:AddBlendAnimation(400.0, Object.FPS_Run)

--FastRun
AnimState:AddBlendAnimation(1200.0, Object.FPS_Run, 1.75)

--JumpStart
AnimState = AnimStateMachineSetting:AddAnimState("JumpStart", Object.Bow_Jump)

--JumpLoop
AnimState = AnimStateMachineSetting:AddAnimState("JumpLoop", Object.Bow_Fall, InfinityPlay)

--JumpEnd
AnimState = AnimStateMachineSetting:AddAnimState("JumpEnd", Object.Bow_Land)

--Shot
AnimState = AnimStateMachineSetting:AddAnimState("BowShot", Object.Bow_Shot, 1)
AnimState:SetNeedReplicate(true)

--ShotReady
AnimState = AnimStateMachineSetting:AddAnimState("BowShotReady", Object.Bow_Ready, 1)
AnimState:SetNeedReplicate(true)

--ShotEnd
AnimState = AnimStateMachineSetting:AddAnimState("BowShotEnd", Object.Bow_End, 1)
AnimState:SetNeedReplicate(true)

--Sit
AnimState = AnimStateMachineSetting:AddAnimState("Sit", Object.Sit, InfinityPlay)
AnimState:SetNeedReplicate(true)

--Climb
AnimState = AnimStateMachineSetting:AddBlendAnimState("Climb", Idle_Run_BlendFunction, InfinityPlay)
AnimState:AddBlendAnimation(0.0, Object.Climb, 0.0)
AnimState:AddBlendAnimation(150.0, Object.Climb)
AnimState:SetNeedReplicate(true)


------------------------------------------------------------------------------------------------------------
--애니메이션 상태 전이시 확인할 조건 함수에요.
local function Move_Condition(AnimStateMachine)
    if AnimStateMachine == nil then
        return false
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return false
    end

   return character:GetMoveSpeed() > 0
end

local function Stand_Condition(AnimStateMachine)

    if AnimStateMachine == nil then
        return false
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return false
    end

   if not Move_Condition(AnimStateMachine) then
       if not AnimStateMachine.IsStand then
           AnimStateMachine.IsStand = true
           AnimStateMachine.CheckIdle = GetIdleRandom()
       end
   else
       AnimStateMachine.IsStand = false
       AnimStateMachine.IdleChangeCount = 0
   end
   return not Move_Condition(AnimStateMachine)
end

local function JumpStart_Condition(AnimStateMachine)
    if AnimStateMachine == nil then
        return false
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return false
    end

   return character:IsFly()
end

local function JumpEnd_Condition(AnimStateMachine)
    if AnimStateMachine == nil then
        return false
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return false
    end

   return not character:IsFly()
end

local function JumpEndToRunCondition(AnimStateMachine)
    if AnimStateMachine == nil then
        return false
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return false
    end

   return 300 < Idle_Run_BlendFunction(AnimStateMachine)
end

local function IdleCheck_Condition(AnimStateMachine)

    if AnimStateMachine == nil then
        return false
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return false
    end

    if AnimStateMachine.IsStand and AnimStateMachine.IdleChangeCount >= AnimStateMachine.CheckIdle then
        AnimStateMachine.IdleChangeCount = 0
        AnimStateMachine.CheckIdle = GetIdleRandom()
        return true
    end
    return false
end


local function BowReady_Condition(AnimStateMachine)
    if AnimStateMachine == nil then
        return false
    end
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then
        return false
    end

   return not character:IsFly()
end




------------------------------------------------------------------------------------------------------------
--애니메이션 상태 전이를 추가해요.
AnimStateMachineSetting:AddAnimTransition("Stand", "Move", Move_Condition)
AnimStateMachineSetting:AddAnimTransition("Move", "Stand", Stand_Condition)
AnimStateMachineSetting:AddAnimTransition("Move", "JumpStart", JumpStart_Condition)
AnimStateMachineSetting:AddAnimTransition("Stand", "JumpStart", JumpStart_Condition)
AnimStateMachineSetting:AddAnimTransition("JumpStart", "JumpLoop", 0.9)
AnimStateMachineSetting:AddAnimTransition("JumpLoop", "JumpEnd", JumpEnd_Condition)
AnimStateMachineSetting:AddAnimTransition("JumpEnd", "JumpStart", JumpStart_Condition, 0.3)
AnimStateMachineSetting:AddAnimTransition("JumpEnd", "Move", JumpEndToRunCondition, 0.1)
AnimStateMachineSetting:AddAnimTransition("JumpEnd", "Stand", 0.9)
AnimStateMachineSetting:AddAnimTransition(EmotionAnimState, "Move", Move_Condition)
AnimStateMachineSetting:AddAnimTransition(EmotionAnimState, "JumpStart", JumpStart_Condition)
AnimStateMachineSetting:AddAnimTransition("Stand", "Idle", IdleCheck_Condition)
AnimStateMachineSetting:AddAnimTransition("Idle", "Stand")
AnimStateMachineSetting:AddAnimTransition("Idle", "Move", Move_Condition)
AnimStateMachineSetting:AddAnimTransition("Idle", "JumpStart", JumpStart_Condition)
AnimStateMachineSetting:AddAnimTransition("BowShotReady", "Idle")
AnimStateMachineSetting:AddAnimTransition("Idle", "BowShot")

------------------------------------------------------------------------------------------------------------
--애니메이션을 설정해요.
AnimStateMachineSetting:SetStartState("BowShotReady") --애니메이션 상태머신이 활성화 될 때 해당 애니메이션 상태(Idle)를 설정할 수 있어요.
Game:SetCharacterAnimStateMachine(Object, AnimStateMachineSetting) --애니메이션 상태머신을 사용 할 캐릭터(Object)를 설정해요.

]]--