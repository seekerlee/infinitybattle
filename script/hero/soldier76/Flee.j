library Flee initializer init requires SpellEffectEvent, TimerUtils, UnitDex

    globals
        private constant integer AB_CODE_FLEE = 'A00Y'
        private constant integer AB_CODE_MISS = 'A00Z'
    endglobals

    private function onBuffEnd takes nothing returns nothing
        local unit u = GetUnitById(GetTimerData(GetExpiredTimer()))
        call UnitRemoveAbility(u, AB_CODE_MISS)
        call SetUnitVertexColor(u, 255, 255, 255, 255)
        call SetUnitPathing( u, true )
        call ReleaseTimer(GetExpiredTimer())
        set u = null
    endfunction

    private function onCast takes nothing returns boolean
        local unit u = GetTriggerUnit()
        local timer t = NewTimerEx(GetUnitId(u))
        
        call TimerStart(t, 12.0, false, function onBuffEnd)
        call SetUnitPathing( u, false )
        call UnitAddAbility(u, AB_CODE_MISS)
        call SetUnitAbilityLevel(u, AB_CODE_MISS, GetUnitAbilityLevel(u, AB_CODE_FLEE))
        call BlzUnitHideAbility(u, AB_CODE_MISS, true)
        call SetUnitVertexColor(u, 255, 255, 255, 128)

        set t = null
        set u = null
        return false
    endfunction

    private function init takes nothing returns nothing
        local integer i = 1
        loop
            exitwhen i > 10
            call BlzSetAbilityTooltip(AB_CODE_FLEE, "冲刺(|cffffcc00B|r) - [|cffffcc00等级 " + I2S(i) + "|r]", i - 1)
            call BlzSetAbilityExtendedTooltip(AB_CODE_FLEE, "增加80%的移动速度，可以让英雄随意穿梭于人群，并且有" + I2S(15 + 7 * (i - 1)) + "%概率闪避敌人的攻击。", i - 1)
            set i = i + 1
        endloop
        call RegisterSpellEffectEvent(AB_CODE_FLEE, function onCast)
    endfunction
endlibrary
