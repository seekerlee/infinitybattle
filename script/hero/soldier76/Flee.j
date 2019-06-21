library Flee initializer init requires SpellEffectEvent, TimerUtils, UnitDex

    globals
        private constant integer AB_CODE_FLEE = 'A00Y'
        private constant integer AB_CODE_MISS = 'A00Z'
    endglobals

    private function onBuffEnd takes nothing returns nothing
        local unit u = GetUnitById(GetTimerData(GetExpiredTimer()))
        call UnitRemoveAbility(u, AB_CODE_MISS)
        call SetUnitVertexColor(u, 255, 255, 255, 255)
        call ReleaseTimer(GetExpiredTimer())
        set u = null
    endfunction

    private function onCast takes nothing returns boolean
        local unit u = GetTriggerUnit()
        local timer t = NewTimerEx(GetUnitId(u))
        call TimerStart(t, 12.0, false, function onBuffEnd)
        call UnitAddAbility(u, AB_CODE_MISS)
        call SetUnitAbilityLevel(u, AB_CODE_MISS, GetUnitAbilityLevel(u, AB_CODE_FLEE))
        call BlzUnitHideAbility(u, AB_CODE_MISS, true)
        call SetUnitVertexColor(u, 255, 255, 255, 128)
        set t = null
        set u = null
        return false
    endfunction

    private function init takes nothing returns nothing
        call RegisterSpellEffectEvent(AB_CODE_FLEE, function onCast)
    endfunction
endlibrary
