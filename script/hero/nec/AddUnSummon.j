library AddUnSummon initializer init requires HeroSkillEvent
    private function addsummonskillActions takes nothing returns boolean
        // add unsummon skill
        if GetUnitAbilityLevel(GetLearningUnit(), 'A004') == 0 then
            call UnitAddAbility(GetLearningUnit(), 'A004')
        endif
        return false
    endfunction

    private function init takes nothing returns nothing
        call RegisterHeroSkillEvent('A001', function addsummonskillActions)
    endfunction
endlibrary
