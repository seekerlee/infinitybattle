scope KeepAlive initializer Init

    globals
        private constant integer KEY_UNIT = 0
        private constant integer ABLITY_KEEPLIVE = 'A00I'
        private constant real TIME_INTERVAL = 0.5
        private constant real PERCENT_LIFE_RESTORE = 40.0
        private trigger trig_checkLife = null
        private unit array u_keep
        private integer u_keep_count = 0
    endglobals

    private function lifeFormular takes real percent_current returns real
        //local real addpercent = 3.5 * (1 - percent_current / 50) * TIME_INTERVAL
        return 5 * (1 - percent_current / PERCENT_LIFE_RESTORE) * TIME_INTERVAL
    endfunction
    
    private function ActionCheckAndBuff takes nothing returns boolean
        local integer i = 0
        local unit u = null
        local real lifePercent
        loop
            exitwhen i == u_keep_count
            
            set u = u_keep[i]
            if IsUnitAliveBJ(u) then
                set lifePercent = GetUnitLifePercent(u)
                if (lifePercent < PERCENT_LIFE_RESTORE) then
                    call SetUnitLifePercentBJ(u, lifePercent + lifeFormular(lifePercent))
                endif
            endif

            set i = i + 1
        endloop

        return false
    endfunction
    
    private function Action takes nothing returns boolean
        if GetLearnedSkill() != ABLITY_KEEPLIVE then
            return false
        endif
        if trig_checkLife == null then
            set trig_checkLife = CreateTrigger()
            call TriggerRegisterTimerEventPeriodic( trig_checkLife, TIME_INTERVAL )
        endif
        if GetLearnedSkillLevel() == 1 then
            set u_keep[u_keep_count] = GetTriggerUnit()
            set u_keep_count = u_keep_count + 1
        endif
        call TriggerAddCondition(trig_checkLife, Condition(function ActionCheckAndBuff))
        return false
    endfunction

    private function Init takes nothing returns nothing
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_HERO_SKILL, function Action)
    endfunction

endscope