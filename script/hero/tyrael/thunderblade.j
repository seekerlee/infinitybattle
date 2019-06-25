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
    
    private function Action takes nothing returns boolean
        local real luck = GetRandomReal(0, 99)
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

        if luck < 15.0 + (abilityLvl - 1) * 25.0 / 9.0  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        endif
        
        return false
    endfunction
    
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        local integer i = 1
        loop
            exitwhen i > 10
            call BlzSetAbilityTooltip(ID_TB, "被动天谴 - [|cffffcc00等级 " + I2S(i) + "|r]", i - 1)
            call BlzSetAbilityExtendedTooltip(ID_TB, "伤害敌人时有 "+ R2S(15.0 + (i - 1) * 25.0 / 9.0)+"% 几率对敌人释放当前等级的天谴技能。", i - 1)
            set i = i + 1
        endloop
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition(t, Condition(function Action))
        
        set t = null
    endfunction

endlibrary