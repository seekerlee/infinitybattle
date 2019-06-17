scope KeepAlive initializer Init

    globals
        private constant integer KEY_UNIT = 0
        private constant integer ABLITY_KEEPLIVE = 'A00I'
        private constant real TIME_INTERVAL = 0.5
        private constant real PERCENT_LIFE_RESTORE = 40.0
        private trigger trig_checkLife = null
        private unit u_berserker = null // there can be only one berserker in game
    endglobals

    private function isLiving takes nothing returns boolean
        return IsUnitAliveBJ(u_berserker)
    endfunction
    
    private function lifeFormular takes real percent_current returns real
        //local real addpercent = 3.5 * (1 - percent_current / 50) * TIME_INTERVAL
        
        return 5 * (1 - percent_current / PERCENT_LIFE_RESTORE) * TIME_INTERVAL
    endfunction
    
    private function ActionCheckAndBuff takes nothing returns nothing
        local real lifePercent = GetUnitLifePercent(u_berserker)
        if (lifePercent < PERCENT_LIFE_RESTORE) then
            call SetUnitLifePercentBJ(u_berserker, lifePercent + lifeFormular(lifePercent))
        endif
    endfunction
    
    private function Action takes nothing returns nothing
        
        local trigger trig_checkLife = CreateTrigger()
        set u_berserker = GetTriggerUnit()
        
        call TriggerRegisterTimerEventPeriodic( trig_checkLife, TIME_INTERVAL )
        call TriggerAddCondition(trig_checkLife, Condition(function isLiving))
        call TriggerAddAction(trig_checkLife, function ActionCheckAndBuff)
        
        call DestroyTrigger(GetTriggeringTrigger())
        
        set trig_checkLife = null
    endfunction

    private function Requirement takes nothing returns boolean
        return GetLearnedSkill() == ABLITY_KEEPLIVE
    endfunction
    
    private function Init takes nothing returns nothing
    
        local trigger t = CreateTrigger()
        
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition(t, Condition(function Requirement))
        call TriggerAddAction(t, function Action)
        
        set t = null
        
    endfunction

endscope