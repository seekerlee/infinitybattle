library Thunderblade initializer Init

    globals
        
        private constant integer ID_TB = 'A00C'
        private constant integer ID_TIANQIAN = 'A009'
    endglobals
    
    private function doTianqian takes unit source, unit target, integer abilvl returns nothing
    
        local xecast xc = xecast.createA()
        
        set xc.abilityid    = 'A009'
        set xc.level        = abilvl
        set xc.orderstring  = "thunderbolt" 
        set xc.owningplayer = GetOwningPlayer(source)
       
        call xc.castOnTarget( target )

    endfunction
    
    private function ActionRevenge takes nothing returns boolean
        local integer luck = GetRandomInt(0, 99)
        local integer abilityLvl = GetUnitAbilityLevel(udg_DamageEventSource, ID_TB)
        local integer abilityLvlTianqian = GetUnitAbilityLevel(udg_DamageEventSource, ID_TIANQIAN)
        // if udg_IsDamageSpell then
        //     return
        // endif
        if abilityLvlTianqian == 0 or abilityLvl == 0 then
            return false
        endif
        if IsPlayerAlly(GetOwningPlayer(udg_DamageEventTarget), GetOwningPlayer(udg_DamageEventSource)) then
            return false
        endif
        if (abilityLvl == 1) and luck < 15  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        elseif (abilityLvl == 2) and luck < 23  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        elseif (abilityLvl == 3) and luck < 31  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        elseif (abilityLvl == 4) and luck < 40  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        endif
        return false
    endfunction
    
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition(t, Condition(function ActionRevenge))
        
        set t = null
    endfunction

endlibrary