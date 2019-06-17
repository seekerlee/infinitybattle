library AddUnSummon initializer init

    function Trig_addsummonskillConditions takes nothing returns boolean
        return GetLearnedSkillBJ() == 'A001'
    endfunction

    function Trig_addsummonskillActions takes nothing returns nothing
        // init skeleken group
        local integer pid = GetPlayerId(GetTriggerPlayer())
        local unit uu = GetTriggerUnit()
        
        if ggg_SkeletonGroupForPlayer == null then
            set ggg_SkeletonGroupForPlayer = InitHashtable()
        endif
        // 1 check hashtable exist group udg_g_SkeletonGroupForPlayer
        if not HaveSavedHandle(ggg_SkeletonGroupForPlayer, pid, ggg_CATEGORY_SKELETON) then
            call SaveGroupHandle(ggg_SkeletonGroupForPlayer, pid, ggg_CATEGORY_SKELETON, CreateGroup())
        endif
        
        if not HaveSavedHandle(ggg_SkeletonGroupForPlayer, pid, ggg_CATEGORY_SKELETON_MASTER) then
            call SaveUnitHandle(ggg_SkeletonGroupForPlayer, pid, ggg_CATEGORY_SKELETON_MASTER, uu)
        endif
        // add unsummon skill
        if (GetUnitAbilityLevel(uu, 'A004') == 0) then
            call UnitAddAbility(uu, 'A004')
        endif
        
        set uu = null
        
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_HERO_SKILL )
        call TriggerAddCondition(t, Condition(function Trig_addsummonskillConditions))
        call TriggerAddAction(t, function Trig_addsummonskillActions)

        set t = null
    endfunction
endlibrary
