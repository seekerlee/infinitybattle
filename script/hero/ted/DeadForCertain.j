library DeadForCertain initializer init requires SpellEffectEvent, TimerUtils, UnitDex

    globals
        // integer array fleeUnitId
        private constant integer AB_CODE_LIFE = 'A011'
        private constant integer AB_CODE_MISS = 'A012'
        private constant integer AB_CODE_DEAD = 'A00S'
    endglobals

    private function onBuffEnd takes nothing returns nothing
        local unit u = GetUnitById(GetTimerData(GetExpiredTimer()))

        call UnitRemoveAbility(u, AB_CODE_MISS)
        call UnitRemoveAbility(u, AB_CODE_LIFE)
        
        call ReleaseTimer(GetExpiredTimer())
        set u = null
    endfunction

    private function onCast takes nothing returns boolean
        local unit u = GetSpellTargetUnit()
        local timer t = NewTimerEx(GetUnitId(u))
        call TimerStart(t, 10.0, false, function onBuffEnd)

        call UnitAddAbility(u, AB_CODE_MISS)
        call BlzUnitHideAbility(u, AB_CODE_MISS, true)
        call UnitAddAbility(u, AB_CODE_LIFE)
        call BlzUnitHideAbility(u, AB_CODE_LIFE, true)
        
        set t = null
        set u = null
        return false
    endfunction

    private function init takes nothing returns nothing
        call RegisterSpellEffectEvent(AB_CODE_DEAD, function onCast)
    endfunction

endlibrary
