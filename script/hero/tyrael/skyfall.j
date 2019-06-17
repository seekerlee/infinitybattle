scope skyfall initializer init
    globals
        private hashtable timerArgs = InitHashtable()
        private integer KEY_X = 0
        private integer KEY_Y = 1
        private integer KEY_U = 3
        private string EFF = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl"
        //private string EFF = "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl"
        //
        private hashtable timerArgsFall = InitHashtable()
        //
        private constant integer FLY_HEIGHT = 2000
        private constant integer FLY_RATE = 8000
        private constant real FLYING_TIME = 0.8
        private constant real UPDONW_TIME = I2R(FLY_HEIGHT) / I2R(FLY_RATE)
    endglobals

    private function damageEarth takes unit u, real x, real y returns nothing
        local xecast xc //CreateA so we don't have to destroy the object after the cast.
     
        set xc  = xecast.createA()
        call SetUnitAnimation(u, "attack") // Let's focus on the look of the item cast for a second...
        //==============================================
        // Here, we do assignments:
        //
        set xc.abilityid    = 'A00B'
        set xc.level        = 1 //GetUnitAbilityLevel(u, 'A005' ) //* Same level as trigger ability
        set xc.orderstring  = "stomp"                     //* The order is polymorph
        set xc.owningplayer = GetOwningPlayer(u)              //* The owning player, determines targets and bounty credits
       
        call xc.castInPoint( x, y )

        set u = null
    endfunction
    
    
    private function spellIdMatch takes nothing returns boolean
        return GetSpellAbilityId()=='A00A'
    endfunction
    
    private function falldowned takes nothing returns nothing
        local timer fallTimer = GetExpiredTimer()
        local integer tidFall = GetHandleId(fallTimer)
        
        local real targetX = LoadReal(timerArgsFall, tidFall, KEY_X)
        local real targetY = LoadReal(timerArgsFall, tidFall, KEY_Y)
        local unit bird = LoadUnitHandle(timerArgsFall, tidFall, KEY_U)
        call SetUnitPathing( bird, true )
        call SetUnitInvulnerable(bird, false)
        
        call damageEarth(bird, targetX, targetY)
        
        call SetUnitAnimationByIndex(bird, 4)
        //call SetUnitAnimation(bird, "attack")
        
        call DestroyEffect(AddSpecialEffect(EFF, targetX, targetY))
        call FlushChildHashtable(timerArgs, tidFall)
        call DestroyTimer(fallTimer)
        
        set bird = null
        set fallTimer = null
    endfunction
    
    private function falldown takes nothing returns nothing
        local timer flyTimer = GetExpiredTimer()
        local integer tid = GetHandleId(flyTimer)
        local unit bird = LoadUnitHandle(timerArgs, tid, KEY_U)
        local real targetX = LoadReal(timerArgs, tid, KEY_X)
        local real targetY = LoadReal(timerArgs, tid, KEY_Y)
        //
        local timer fallTimer = CreateTimer()
        local integer tidFall = GetHandleId(fallTimer)
        
        call DestroyTimer(flyTimer)
        call SetUnitPathing( bird, false ) // turn off collision
        call SetUnitPosition(bird, targetX, targetY)
        call SetUnitFlyHeight(bird, 0, FLY_RATE)
        
        
        call FlushChildHashtable(timerArgs, tid)
        
        call SaveReal(timerArgsFall, tidFall, KEY_X, targetX)
        call SaveReal(timerArgsFall, tidFall, KEY_Y, targetY)
        call SaveUnitHandle(timerArgsFall, tidFall, KEY_U, bird)
        call TimerStart(fallTimer, UPDONW_TIME, FALSE, function falldowned)
        
        set flyTimer = null
        set bird = null
        
    endfunction
    
    private function onSpellCastSuccess takes nothing returns nothing
        local unit u = GetTriggerUnit()
        local unit targetU = GetSpellTargetUnit()
        local real targetX = GetLocationX(GetUnitLoc(targetU))
        local real targetY = GetLocationY(GetUnitLoc(targetU))
        local timer flyTimer = CreateTimer()
        local integer tid = GetHandleId(flyTimer)
        
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", GetLocationX(GetUnitLoc(u)), GetLocationY(GetUnitLoc(u))))
        
        call SetUnitInvulnerable(u, true)
        call IssueTargetOrder( u, "attack", targetU )
        
        call UnitAddAbility(u, XE_HEIGHT_ENABLER)
        call UnitRemoveAbility(u, XE_HEIGHT_ENABLER)
        call SetUnitFlyHeight(u, FLY_HEIGHT, FLY_RATE)
        
        call SaveReal(timerArgs, tid, KEY_X, targetX)
        call SaveReal(timerArgs, tid, KEY_Y, targetY)
        call SaveUnitHandle(timerArgs, tid, KEY_U, u)
        
        call TimerStart(flyTimer, UPDONW_TIME + FLYING_TIME, FALSE, function falldown)
        
        set targetU = null
        set u = null
        set flyTimer = null
    endfunction
    
    
    private function init takes nothing returns nothing
        local trigger tCastSuccess = CreateTrigger()
        
        call TriggerAddCondition(tCastSuccess, Condition( function spellIdMatch) )
        call TriggerAddAction(tCastSuccess,    function onSpellCastSuccess)
        call TriggerRegisterAnyUnitEventBJ( tCastSuccess, EVENT_PLAYER_UNIT_SPELL_CAST )
        set tCastSuccess = null
        
    endfunction

endscope