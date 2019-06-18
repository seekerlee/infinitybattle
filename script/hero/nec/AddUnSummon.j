library AddUnSummon initializer init requires RegisterPlayerUnitEvent

    function Trig_addsummonskillActions takes nothing returns nothing
        local unit uu = GetTriggerUnit()
        // add unsummon skill
        if (GetUnitAbilityLevel(uu, 'A004') == 0) then
            call UnitAddAbility(uu, 'A004')
        endif
        set uu = null
    endfunction

    function Trig_addsummonskillConditions takes nothing returns boolean
        if GetLearnedSkillBJ() == 'A001' then
            call Trig_addsummonskillActions()
        endif
        return false
    endfunction

    private function init takes nothing returns nothing
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_HERO_SKILL, function Trig_addsummonskillConditions)
    endfunction
endlibrary
