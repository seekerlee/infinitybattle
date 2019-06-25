library HeroSkillEvent requires RegisterPlayerUnitEvent, Table
 
//============================================================================
private module M
    
    static Table tb
    
    static method onSkill takes nothing returns nothing
        call TriggerEvaluate(.tb.trigger[GetLearnedSkill()])
    endmethod
 
    private static method onInit takes nothing returns nothing
        set .tb = Table.create()
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_HERO_SKILL, function thistype.onSkill)
    endmethod
endmodule
 
//============================================================================
private struct S extends array
    implement M
endstruct
 
//============================================================================
function RegisterHeroSkillEvent takes integer abil, code onSkill returns nothing
    if not S.tb.handle.has(abil) then
        set S.tb.trigger[abil] = CreateTrigger()
    endif
    call TriggerAddCondition(S.tb.trigger[abil], Filter(onSkill))
endfunction
 
endlibrary