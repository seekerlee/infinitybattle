library Unsummon initializer init requires RegisterPlayerUnitEvent, Gaizhonggai

    private function Trig_unsummon_Actions takes nothing returns nothing
        // prepare
        local integer playId = GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit()))
        local group tmpG = skeletonGroups[GetUnitId(GetTriggerUnit())]
        if ( tmpG != null and IsUnitInGroup(GetSpellTargetUnit(), tmpG) ) then
            call KillUnit( GetSpellTargetUnit() )
        else 
            call PauseUnit(GetSpellAbilityUnit(), true)
            call IssueImmediateOrder(GetSpellAbilityUnit(), "stop")
            call PauseUnit(GetSpellAbilityUnit(), false)
            call DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "|cffffcc00you can only unsummon your slaves|r")
        endif
        // warn
        set tmpG = null
    endfunction

    private function Trig_unsummon_Conditions takes nothing returns boolean
        if ( GetSpellAbilityId() != 'A004' ) then
            return false
        endif
        call Trig_unsummon_Actions()
        return false
    endfunction

    private function init takes nothing returns nothing
        call RegisterAnyPlayerUnitEvent( EVENT_PLAYER_UNIT_SPELL_CAST, function Trig_unsummon_Conditions )
    endfunction

endlibrary
