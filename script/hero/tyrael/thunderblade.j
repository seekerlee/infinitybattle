scope thunderblade initializer Init

    globals
        // The effect created on the target when it is being possessed:
        private constant string EFFECT = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl"
        // Which is attached to the targets:
        private constant string EFFECT_POSITION = "chest"
        
        private constant integer ID_TB = 'A00C'
        private constant integer ID_TIANQIAN = 'A009'
    endglobals
        
    private function Requirement takes nothing returns boolean
        return (GetLearnedSkill() == ID_TB and GetLearnedSkillLevel() == 1)
    endfunction
    
    private function doTianqian takes unit source, unit target, integer abilvl returns nothing
    
        local xecast xc = xecast.createA()
        
        set xc.abilityid    = 'A009'
        set xc.level        = abilvl
        set xc.orderstring  = "thunderbolt" 
        set xc.owningplayer = GetOwningPlayer(source)
       
        call xc.castOnTarget( target )

    endfunction
    
    private function ActionRevenge takes nothing returns nothing
        local integer luck = GetRandomInt(0, 99)
        local integer abilityLvl = GetUnitAbilityLevel(udg_DamageEventSource, ID_TB)
        local integer abilityLvlTianqian = GetUnitAbilityLevel(udg_DamageEventSource, ID_TIANQIAN)
        if udg_IsDamageSpell then
            return
        endif
        if abilityLvlTianqian == 0 or abilityLvl == 0 then
            return
        endif
        if IsPlayerAlly(GetOwningPlayer(udg_DamageEventTarget), GetOwningPlayer(udg_DamageEventSource)) then
            return
        endif
        if (abilityLvl == 1) and luck < 15  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        endif
        if (abilityLvl == 2) and luck < 23  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        endif
        if (abilityLvl == 3) and luck < 31  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        endif
        if (abilityLvl == 4) and luck < 40  then
            call doTianqian(udg_DamageEventSource, udg_DamageEventTarget, abilityLvlTianqian)
        endif
    endfunction
    
    private function Action takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddAction(t, function ActionRevenge)
        
        set t = null
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition(t, Condition(function Requirement))
        call TriggerAddAction(t, function Action)
        
        set t = null
    endfunction

endscope