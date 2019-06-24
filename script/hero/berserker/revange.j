scope Revange initializer Init

    globals
        private constant integer ID_ABILITY = 'A00J'
        private constant integer ID_ABILITY_BUFF = 'A00K'
        private constant integer ID_ABILITY_BUFF2 = 'A00M'
    endglobals
         
       
    private function addBuff takes unit u returns nothing
    
        local xecast xc = xecast.create()
        set xc.abilityid    = ID_ABILITY_BUFF
        set xc.orderstring  = "bloodlust"
        set xc.owningplayer = GetOwningPlayer(u)
        call xc.castOnTarget(u)
        
        set xc.abilityid    = ID_ABILITY_BUFF2
        set xc.orderstring  = "innerfire"
        set xc.owningplayer = GetOwningPlayer(u)
        call xc.castOnTarget(u)
        
        call xc.destroy()
        
    endfunction
    
    private function Action takes nothing returns nothing
        local integer abliLvl = GetUnitAbilityLevel(udg_DamageEventTarget, ID_ABILITY)
        local real luck = GetRandomReal(0, 100.0)
        // call SetHeroLevel(udg_DamageEventTarget, 100, true) // test

        set luck = luck - 6 - (abliLvl - 1) * 1.66 // 6 - 15
        
        if luck < 0 then
            call addBuff(udg_DamageEventTarget)
        endif
    endfunction

    private function Requirement takes nothing returns boolean
        if 0 < GetUnitAbilityLevel(udg_DamageEventTarget, ID_ABILITY) then
            call Action()
        endif
        return false
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition(t, Condition(function Requirement))
        
        set t = null
    endfunction

endscope