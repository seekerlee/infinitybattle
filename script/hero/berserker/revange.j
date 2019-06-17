scope Revange initializer Init

    globals
        private constant integer ID_ABILITY = 'A00J'
        private constant integer ID_ABILITY_BUFF = 'A00K'
        private constant integer ID_ABILITY_BUFF2 = 'A00M'
        private constant real PERCENT_LIFE_RESTORE = 40.0
        
        //public constant integer TYPE_COMMAND_AURA = 0
        public constant integer ID_COMMAND_AURA = '(I)h'//'AEar'// command: 'A00L', laoniu 'AOae'
    endglobals
         
       
       
    private function Requirement takes nothing returns boolean
        return 0 < GetUnitAbilityLevel(udg_DamageEventTarget, ID_ABILITY)
    endfunction
    
    private function addBuff takes unit u returns nothing
    
        local xecast   xc = xecast.create()

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
        local integer luck = GetRandomInt(1, 100)
        if (abliLvl == 1) and luck > 6 then
            return
        elseif (abliLvl == 2) and luck > 9 then
            return
        elseif (abliLvl == 3) and luck > 12 then
            return
        elseif (abliLvl == 4) and luck > 15 then
            return 
        endif
        
        call addBuff(udg_DamageEventTarget)
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition(t, Condition(function Requirement))
        call TriggerAddAction(t, function Action)
        
        set t = null
    endfunction

endscope