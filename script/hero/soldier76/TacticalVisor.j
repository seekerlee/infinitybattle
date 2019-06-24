library TacticalVisor initializer init requires TimerUtils, SpellEffectEvent

    globals
        // integer array fleeUnitId
        private constant integer AB_CODE_VISOR = 'A00X'
        private constant integer AB_CODE_CRITICAL = 'A00W'
        private constant integer AB_CODE_BASH = 'A010'
        
        private constant real RANGE_BONUS = 2500.0
        private constant real CHANCE_BUF = 80.0
        private constant real CHANCE_ORIGIN_BUF = 15.0
    endglobals

    private function onBuffEnd takes nothing returns nothing
        local integer i = 0
        local ability ab
        local unit u = GetUnitById(GetTimerData(GetExpiredTimer()))
        
        call UnitRemoveAbility(u, AB_CODE_BASH)
        if GetUnitAbilityLevel(u, AB_CODE_CRITICAL) > 0 then
            set ab = BlzGetUnitAbility(u, AB_CODE_CRITICAL)
            loop
                exitwhen i == 10 or ab == null
                call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_CHANCE_TO_CRITICAL_STRIKE, i, CHANCE_ORIGIN_BUF)
                set i = i + 1
            endloop
            set ab = null
        endif

        call ReleaseTimer(GetExpiredTimer())
        set u = null
    endfunction

    private function onCast takes nothing returns boolean
        local unit u = GetTriggerUnit()
        local timer t = NewTimerEx(GetUnitId(u))
        local ability ab
        local integer i = 0
        local boolean b = false
        call TimerStart(t, 20.0, false, function onBuffEnd)
        // TODO: 似乎无法叠加重击和暴击
        call UnitAddAbility(u, AB_CODE_BASH)
        call BlzUnitHideAbility(u, AB_CODE_BASH, true)

        if GetUnitAbilityLevel(u, AB_CODE_CRITICAL) > 0 then
            set ab = BlzGetUnitAbility(u, AB_CODE_CRITICAL)
            loop
                exitwhen i == 10 or ab == null
                set b = BlzSetAbilityRealLevelField(ab, ABILITY_RLF_CHANCE_TO_CRITICAL_STRIKE, i, CHANCE_BUF)
                set i = i + 1
            endloop
            set ab = null
        endif

        set t = null
        set u = null
        return false
    endfunction

    private function init takes nothing returns nothing
        call RegisterSpellEffectEvent('A00X', function onCast)
    endfunction
endlibrary
