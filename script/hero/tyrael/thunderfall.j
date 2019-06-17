scope Template initializer Init

    globals
        private weathereffect weather
        
        //
        private constant integer KEY_UNIT = 0
        //
        private player g_enumParamPlay
        private integer g_abilityLvlTianqian = 0
        private constant integer ID_TIANQIAN = 'A009'
    endglobals
        
    private function spellIdMatch takes nothing returns boolean
      return (GetSpellAbilityId()=='A00E')
    endfunction
    
    private function NotAlly takes nothing returns boolean
        return IsUnitAliveBJ(GetFilterUnit()) and IsPlayerEnemy(GetOwningPlayer(GetFilterUnit()), g_enumParamPlay)
    endfunction
    
    
    private function doTianqian takes unit target returns nothing
    
        local xecast xc = xecast.createBasicA('A009', OrderId("thunderbolt"), g_enumParamPlay )
        if (g_abilityLvlTianqian == 0) then
            set xc.level = 1
        else
            set xc.level = g_abilityLvlTianqian
        endif
        
        call xc.castOnTarget( target )

    endfunction
    
    private function doThunder takes nothing returns nothing
        
        call doTianqian(GetEnumUnit() )
    endfunction
    
    private function dianliao takes nothing returns nothing
        local timer castTimer = GetExpiredTimer()
        local unit u = LoadUnitHandle(timerParams, GetHandleId(castTimer), KEY_UNIT)
        local group g = CreateGroup()
        local group gdaomei
        
        set g_enumParamPlay = GetOwningPlayer(u)
        set g_abilityLvlTianqian = GetUnitAbilityLevel(u, ID_TIANQIAN)
        //call QueueUnitAnimation(u, "stand victory")
        call SetUnitAnimation(u, "attack")
        
        call GroupEnumUnitsInRange(g, GetLocationX(GetUnitLoc(u)), GetLocationY(GetUnitLoc(u)), 900, Filter(function NotAlly))
        // set gdaomei = GetRandomSubGroup(CountUnitsInGroup(g) / 4, g)
        set gdaomei = GetRandomSubGroup(3, g)
        
        call ForGroup(gdaomei, function doThunder)
        
        call DestroyGroup(gdaomei)
        call DestroyGroup(g)
        set gdaomei = null
        set g = null
        set castTimer = null
        set u = null
        set g_enumParamPlay = null
        set g_abilityLvlTianqian = 0
    endfunction
    
    private function onSpellCast takes nothing returns nothing
        local unit u = GetTriggerUnit()
        local timer castTimer = CreateTimer()
        local integer tid = GetHandleId(castTimer)
        local effect lighteff
        
        call SaveTimerHandle(unitParams, GetHandleId(u), KEY_SPELL_THUNDERFALL_TIMER, castTimer)
        
        //call SetUnitAnimationByIndex(u, 2)
        //call QueueUnitAnimation(u, "stand victory")
        call SaveUnitHandle(timerParams, tid, KEY_UNIT, u)
        call TimerStart(castTimer, 0.3, true, function dianliao)
        
        set lighteff = AddSpecialEffectTarget( "Abilities\\Spells\\Orc\\LightningShield\\LightningShieldTarget.mdl" , u, "origin")
        call SaveEffectHandle(unitParams, GetHandleId(u), KEY_SPELL_THUNDERFALL_EFFECT, lighteff)
        // weather
        call EnableWeatherEffect( weather, true )
        
        set lighteff = null
        set u = null
        set castTimer = null
    endfunction
    
    
    private function onSpellCastEnd takes nothing returns nothing
        local unit u = GetTriggerUnit()
        local integer timerId = GetHandleId(LoadTimerHandle(unitParams, GetHandleId(u), KEY_SPELL_THUNDERFALL_TIMER))
        call DestroyTimer(LoadTimerHandle(unitParams, GetHandleId(u), KEY_SPELL_THUNDERFALL_TIMER))
        call DestroyEffect(LoadEffectHandle(unitParams, GetHandleId(u), KEY_SPELL_THUNDERFALL_EFFECT))
        
        // clear hash table
        call FlushChildHashtable( unitParams, GetHandleId(u) )
        call FlushChildHashtable( timerParams, timerId)
        call EnableWeatherEffect( weather, false )
        set u = null
    endfunction

    private function Init takes nothing returns nothing
        local trigger tCast = CreateTrigger()
        local trigger tCastEnd = CreateTrigger()
        
        call TriggerAddCondition(tCast, Condition( function spellIdMatch) )
        call TriggerAddAction(tCast,    function onSpellCast)
        call TriggerRegisterAnyUnitEventBJ( tCast, EVENT_PLAYER_UNIT_SPELL_CAST )
        
        call TriggerAddCondition(tCastEnd, Condition( function spellIdMatch) )
        call TriggerAddAction(tCastEnd,    function onSpellCastEnd)
        call TriggerRegisterAnyUnitEventBJ( tCastEnd, EVENT_PLAYER_UNIT_SPELL_ENDCAST )
        set weather = AddWeatherEffect( GetEntireMapRect(), 'RAhr' )
        
        set tCast = null
        set tCastEnd = null
    endfunction

endscope