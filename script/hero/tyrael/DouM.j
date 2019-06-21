scope DouM initializer Init

    globals
        // The effect created on the target when it is being possessed:
        private constant string EFFECT = "Abilities\\Spells\\Items\\AIvi\\AIviTarget.mdl"
        // Which is attached to the targets:
        private constant string EFFECT_POSITION = "chest"
        
        private constant integer ID_DOUM = 'A00D'
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
        local integer abilityLvl = GetUnitAbilityLevel(GetTriggerUnit(), ID_DOUM)
        local integer abilityLvlTianqian = GetUnitAbilityLevel(GetTriggerUnit(), ID_TIANQIAN)
        if IsPlayerAlly(GetOwningPlayer(GetTriggerUnit()), GetOwningPlayer(GetEventDamageSource())) then
            return false
        endif
        if abilityLvlTianqian == 0 then
            return false
        endif
        if (abilityLvl == 1) and luck < 15  then
            call doTianqian(GetTriggerUnit(), GetEventDamageSource(), abilityLvlTianqian)
        elseif (abilityLvl == 2) and luck < 23  then
            call doTianqian(GetTriggerUnit(), GetEventDamageSource(), abilityLvlTianqian)
        elseif (abilityLvl == 3) and luck < 31  then
            call doTianqian(GetTriggerUnit(), GetEventDamageSource(), abilityLvlTianqian)
        elseif (abilityLvl == 4) and luck < 40  then
            call doTianqian(GetTriggerUnit(), GetEventDamageSource(), abilityLvlTianqian)
        endif
        return false
    endfunction
    
    private function Action takes nothing returns boolean
        local trigger t
        if (GetLearnedSkill() == ID_DOUM and GetLearnedSkillLevel() == 1) then
            set t = CreateTrigger()
            call TriggerRegisterUnitEvent( t, GetTriggerUnit(), EVENT_UNIT_DAMAGED )
            call TriggerAddCondition(t, Condition(function ActionRevenge))
            set t = null
        endif
        return false
    endfunction

    private function Init takes nothing returns nothing
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_HERO_SKILL, function Action)
    endfunction

endscope