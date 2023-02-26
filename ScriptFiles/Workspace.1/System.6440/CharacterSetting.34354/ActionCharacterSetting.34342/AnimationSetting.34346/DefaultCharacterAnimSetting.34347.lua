
--! ------------------------------ 애니메이션 변수 설정 ------------------------------
local Object = Script.Parent --Script의 부모 오브젝트(AnimationSetting)를 Object 변수에 할당해요.
local IdleName = Object.Idle
local AnimStateMachineSetting = Game:AddAnimStateMachineSetting("ActionCharacterAnim") --캐릭터에 사용될 애니메이션 상태머신 설정을 추가해요.

local AnimState = nil
local character = nil

local nowAnimState = nil
local prevAnimState = nil


local function GetIdleRandom()
    return math.random(5, 20)
end

AnimStateMachineSetting.IsStand = true;
AnimStateMachineSetting.IdleChangeCount = 0
AnimStateMachineSetting.CheckIdle = GetIdleRandom()


--! ------------------------------ AnimStateMachine 설정 ------------------------------
local function AnimStateMachineOnUpdate(AnimStateMachine, ElapsedTime)
    if AnimStateMachine == nil then;    return; end;

    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then;        return;    end;
    
    RemotePlayer = LocalPlayer:GetRemotePlayer()
    if RemotePlayer == nil then;        return;    end;
    if RemotePlayer:GetCharacter() ~= character then;        return;    end;

    if character ~= nil and character:GetCurAnimState() ~= nil then

        if AnimStateMachine.IsStand and character:GetCurAnimState().Name ~= IdleName then
            AnimStateMachine.IdleChangeCount = AnimStateMachine.IdleChangeCount + ElapsedTime
        end
        
        --특정 상태 체크
        CheckActionState(character:GetCurAnimState().Name)
    end
    
    if ChangeAnimation(nowAnimState, character:GetCurAnimState().Name) then    
        prevAnimState = nowAnimState
        nowAnimState = character:GetCurAnimState().Name
    end
end
AnimStateMachineSetting.OnUpdate:Connect(AnimStateMachineOnUpdate)





--! ------------------------------ 애니메이션 전이 추가 ------------------------------
--캐릭터의 이동 속도를 반환하는 함수에요.
local function Idle_Run_BlendFunction(AnimStateMachine)
    if AnimStateMachine == nil then;        return 0;    end;
    
    character = AnimStateMachine:GetOwnerCharacter()
    if character == nil then;        return 0;    end;

    --print( character:GetMoveSpeed() )
   return character:GetMoveSpeed()
end


--* 멈춤 -> 움직임
local function Move_Condition(AnimStateMachine)
    if AnimStateMachine == nil then;        return false;    end;
    character = AnimStateMachine:GetOwnerCharacter()
    
    if character == nil then;        return false;    end;
   return character:GetMoveSpeed() > 0
end


--* 움직임 -> 멈춤
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


--* 특정 상태 -> 점프
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


--* 점프 중 -> 착지
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


--* 착지 -> 행동
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


--* 서있음 -> 대기
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








--! ------------------------------ 애니메이션 추가 ------------------------------
local function AnimStateAdd()
    --Stand
    AnimState = AnimStateMachineSetting:AddAnimState("Stand", Object.Stand, InfinityPlay)

    --Idle
    AnimState = AnimStateMachineSetting:AddAnimState("Idle", Object.Idle, 1) 
    AnimState:SetNeedReplicate(true)
    --Move
    AnimState = AnimStateMachineSetting:AddBlendAnimState("Move", Idle_Run_BlendFunction, InfinityPlay)
    
    --Walk
    AnimState:AddBlendAnimation(0.0, Object.Walk, 0.6)
    AnimState:AddBlendAnimation(150.0, Object.Walk)
    
    --Run
    AnimState:AddBlendAnimation(400.0, Object.Run)
    
    --FastRun
    AnimState:AddBlendAnimation(1200.0, Object.Run, 1.75)


--# 추가 애니메이션
    --JumpStart
    AnimState = AnimStateMachineSetting:AddAnimState("JumpStart", Object.Jump)
    
    --JumpLoop
    AnimState = AnimStateMachineSetting:AddAnimState("JumpLoop", Object.Fall, InfinityPlay)
    
    --JumpEnd
    AnimState = AnimStateMachineSetting:AddAnimState("JumpEnd", Object.Land)
    
    --Sit
    AnimState = AnimStateMachineSetting:AddAnimState("Sit", Object.Sit, InfinityPlay)
    AnimState:SetNeedReplicate(true)
    
    AnimState = AnimStateMachineSetting:AddAnimState("Throw", Object.Throw, 0.5)
    AnimState:SetNeedReplicate(true)
    --AnimState = AnimStateMachineSetting:AddBlendAnimState("Throw", Idle_Run_BlendFunction)
    --AnimState:AddBlendAnimation(0.0, Object.Throw, 0,0)
    
    --Climb
    AnimState = AnimStateMachineSetting:AddBlendAnimState("Climb", Idle_Run_BlendFunction, InfinityPlay)
    AnimState:AddBlendAnimation(0.0, Object.Climb, 0.0)
    AnimState:AddBlendAnimation(150.0, Object.Climb)
    AnimState:SetNeedReplicate(true)
end





--! ------------------------------ 애니메이션 전이 추가 ------------------------------
local function AnimBlendAdd()
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
    
    AnimStateMachineSetting:AddAnimTransition("Move", "Throw", Stand_Condition)
    AnimStateMachineSetting:AddAnimTransition("Stand", "Throw", 0.5)
    AnimStateMachineSetting:AddAnimTransition("Throw", "Stand", 0.9)
    AnimStateMachineSetting:AddAnimTransition("Throw", "Move", Move_Condition)
end





--! ------------------------------ 애니메이션 초기화 ------------------------------
AnimStateAdd()

AnimBlendAdd()




--! ------------------------------  ------------------------------
--애니메이션을 설정해요.
AnimStateMachineSetting:SetStartState("Stand") --애니메이션 상태머신이 활성화 될 때 해당 애니메이션 상태(Idle)를 설정할 수 있어요.
Game:SetCharacterAnimStateMachine(Object, AnimStateMachineSetting) --애니메이션 상태머신을 사용 할 캐릭터(Object)를 설정해요.

