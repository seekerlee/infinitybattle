scope SummonLeoric initializer init
    globals
        // handle id, key -> value
        private hashtable summoningLeric = InitHashtable()
        private integer MASTER_KEY = 0
        private integer LOC_KEY = 1
        // unit -> timerId
        private hashtable unit2timer = InitHashtable()
        // xi xue Abilities\Spells\Items\VampiricPotion\VampPotionCaster.mdl
        // xi lan Abilities\Spells\Other\Drain\ManaDrainTarget.mdl
        // Abilities\Spells\Other\Stampede\StampedeMissileDeath.mdl
        // lv quan Objects\Spawnmodels\NightElf\EntBirthTarget\EntBirthTarget.mdl
        // hun chu Objects\Spawnmodels\Undead\UndeadDissipate\UndeadDissipate.mdl
        // Objects\Spawnmodels\Human\HumanLargeDeathExplode\HumanLargeDeathExplode.mdl
        // Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl
        // Abilities\Spells\Undead\RaiseSkeletonWarrior\RaiseSkeleton.mdl
    endglobals

    
    struct minionLeoric extends minionBase
        private real restTime = 10.0
        implement d3Behavior
        implement gotoTargetBehavior
    endstruct
    

    private function spellIdMatch takes nothing returns boolean
      return (GetSpellAbilityId()=='A006')
    endfunction

    private function onSpellCastEnd takes nothing returns nothing
        local unit u = GetTriggerUnit()
        local timer tt = LoadTimerHandle(unit2timer, 0, GetHandleId(u))
        
        call DestroyTimer(tt)        
        
        call RemoveSavedHandle(summoningLeric, GetHandleId(tt), MASTER_KEY)
        call RemoveSavedHandle(unit2timer, 0, GetHandleId(u))
        
        set u = null
        set tt = null
        
    endfunction
    
    private function onSpellCastSuccess takes nothing returns nothing
        local unit u = GetTriggerUnit()
        local timer tt = LoadTimerHandle(unit2timer, 0, GetHandleId(u))
        local location Loc = LoadLocationHandle(summoningLeric, GetHandleId(tt), LOC_KEY)
        local unit leoric = FirstOfGroup(GetUnitsOfPlayerAndTypeId(GetTriggerPlayer(), 'U00A'))
                
        if (leoric != null) then
            call PauseUnit(GetSpellAbilityUnit(), true)
            call IssueImmediateOrder(GetSpellAbilityUnit(), "stop")
            call PauseUnit(GetSpellAbilityUnit(), false)
            if (IsUnitAliveBJ(leoric)) then
                call SetUnitPositionLocFacingLocBJ(leoric, Loc, GetUnitLoc(u))
                call SetUnitAnimation(leoric, "birth")
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", leoric, "origin"))
            else
                //call ReviveHeroLoc(leoric, Loc, true)
                call ReviveHero(leoric, GetLocationX(Loc), GetLocationY(Loc), true)
                call SetUnitAnimation(leoric, "birth")
            endif
        else
            // call ReviveHeroLoc(leoric, Loc, true)
            set leoric = CreateUnitAtLoc(GetTriggerPlayer(), 'U00A', Loc, 0)
            call SetUnitAnimation(leoric, "birth")
            call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", leoric, "origin"))
        endif
        
        
        call minionLeoric.create(u, leoric, 5, 100)
        call RemoveLocation(Loc)
        call RemoveSavedHandle(summoningLeric, GetHandleId(tt), LOC_KEY)
        set u = null
        set Loc = null
        set tt = null
        set leoric = null
    endfunction
    
    private function playSummoning takes nothing returns nothing
        local integer tid = GetHandleId(GetExpiredTimer())
        local location Loc = LoadLocationHandle(summoningLeric, tid, LOC_KEY)
        local unit uu = LoadUnitHandle(summoningLeric, tid, MASTER_KEY)
        // local integer randomInt = GetRandomInt(0, 99)
        local location randomLoc = GetRandomLocInRect(GetRectFromCircleBJ(Loc, 100))
        local location randomLoc1 = GetRandomLocInRect(GetRectFromCircleBJ(Loc, 100))
        local location randomLoc2 = GetRandomLocInRect(GetRectFromCircleBJ(Loc, 100))
    
        if Loc == null then
            return
        endif
        if uu == null then
            return
        endif
        
        call SetUnitAnimation(uu, "spell")
        call SetWidgetLife(uu, GetWidgetLife(uu) * 0.95)
        call DestroyEffect(AddSpecialEffectLoc( "Abilities\\Spells\\Orc\\EarthQuake\\EarthQuakeTarget.mdl", Loc ))
        call DestroyEffect(AddSpecialEffectLoc( "Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl", randomLoc ))
        call DestroyEffect(AddSpecialEffectLoc( "Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl", randomLoc1 ))
        call DestroyEffect(AddSpecialEffectLoc( "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", randomLoc2 ))
                
        call RemoveLocation(randomLoc)
        call RemoveLocation(randomLoc1)
        call RemoveLocation(randomLoc2)
    
        set uu = null
        set Loc = null
        set randomLoc = null
        set randomLoc1 = null
        set randomLoc2 = null
    endfunction
    
    private function onSpellCh takes nothing returns nothing
        local unit u = GetTriggerUnit()
        
        local timer castedTimer = CreateTimer()
        local location targetLoc = PolarProjectionBJ(GetUnitLoc(u), 300, GetUnitFacing(u))
        call SaveTimerHandle(unit2timer, 0, GetHandleId(u), castedTimer)
        
        call SaveLocationHandle(summoningLeric, GetHandleId(castedTimer), LOC_KEY, targetLoc)
        call SaveUnitHandle(summoningLeric, GetHandleId(castedTimer), MASTER_KEY, u)
        call TimerStart(castedTimer, 0.3, true, function playSummoning)
        
        //call SetUnitAnimation(u, "spell")
        
        call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodPriest.mdl" , u, "chest"))
        call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl" , u, "chest"))
        call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodFootman.mdl" , u, "chest"))
        call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodKnight.mdl" , u, "chest"))
        call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodSorceress.mdl" , u, "chest"))
        
        set castedTimer = null
        set u = null
    endfunction
    
    private function init takes nothing returns nothing
        local trigger tCastSuccess = CreateTrigger()
        local trigger tCh = CreateTrigger()
        local trigger tCastDone = CreateTrigger()
        
        call TriggerAddCondition(tCastSuccess, Condition( function spellIdMatch) )
        call TriggerAddAction(tCastSuccess,    function onSpellCastSuccess)
        call TriggerRegisterAnyUnitEventBJ( tCastSuccess, EVENT_PLAYER_UNIT_SPELL_CAST )
        
        call TriggerAddCondition(tCh, Condition( function spellIdMatch) )
        call TriggerAddAction(tCh,    function onSpellCh)
        call TriggerRegisterAnyUnitEventBJ( tCh, EVENT_PLAYER_UNIT_SPELL_CHANNEL )
        
        call TriggerAddCondition(tCastDone, Condition( function spellIdMatch) )
        call TriggerAddAction(tCastDone,    function onSpellCastEnd)
        call TriggerRegisterAnyUnitEventBJ( tCastDone, EVENT_PLAYER_UNIT_SPELL_ENDCAST )
        
        set tCastSuccess = null
        set tCastDone = null
        set tCh = null
    endfunction

endscope