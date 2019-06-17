library Unsummon initializer init


    private function Trig_unsummon_Conditions takes nothing returns boolean
        if ( not ( GetSpellAbilityId() == 'A004' ) ) then
            return false
        endif
        return true
    endfunction

    private function Trig_unsummon_Actions takes nothing returns nothing
        // prepare
        local integer playId = GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit()))
        local group tmpG = LoadGroupHandle(ggg_SkeletonGroupForPlayer, playId, ggg_CATEGORY_SKELETON)
        if (tmpG != null) then
            if (IsUnitInGroup(GetSpellTargetUnit(), tmpG)) then
                call KillUnit( GetSpellTargetUnit() )
                return
            endif
        endif
        // warn
        call PauseUnit(GetSpellAbilityUnit(), true)
        call IssueImmediateOrder(GetSpellAbilityUnit(), "stop")
        call PauseUnit(GetSpellAbilityUnit(), false)
        call DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "|cffffcc00you can only unsummon your slaves|r")
        set tmpG = null
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_SPELL_CAST )
        call TriggerAddCondition( t, Condition( function Trig_unsummon_Conditions ) )
        call TriggerAddAction( t, function Trig_unsummon_Actions )
        set t = null
    endfunction
endlibrary



//===========================================================================
function InitTrig_unsummon takes nothing returns nothing
endfunction

