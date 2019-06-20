library SummonLeoric initializer init requires TimerUtils, UnitDex
    globals
        private constant integer AB_ID = 'A006'
        private constant integer UID_LEORIC = 'U00A'
        // xi xue Abilities\Spells\Items\VampiricPotion\VampPotionCaster.mdl
        // xi lan Abilities\Spells\Other\Drain\ManaDrainTarget.mdl
        // Abilities\Spells\Other\Stampede\StampedeMissileDeath.mdl
        // lv quan Objects\Spawnmodels\NightElf\EntBirthTarget\EntBirthTarget.mdl
        // hun chu Objects\Spawnmodels\Undead\UndeadDissipate\UndeadDissipate.mdl
        // Objects\Spawnmodels\Human\HumanLargeDeathExplode\HumanLargeDeathExplode.mdl
        // Abilities\\Spells\\Undead\\Unsummon\\UnsummonTarget.mdl
        // Abilities\Spells\Undead\RaiseSkeletonWarrior\RaiseSkeleton.mdl
    endglobals

    struct summonLeoric extends array
        timer effectTimer
        location targetLoc

        static method onSpellCastEnd takes nothing returns boolean
            local unit u
            local thistype this
            if GetSpellAbilityId() != 'A006' then 
                return false
            endif
            set u = GetTriggerUnit()
            set this = GetUnitId(u)
            
            call DestroyTimer(this.effectTimer)
            call RemoveLocation(this.targetLoc)
            
            set this.targetLoc = null
            set this.effectTimer = null
            call BJDebugMsg("end")
            return false
        endmethod
        
        static method onSpellEffect takes nothing returns boolean
            local unit u
            local unit leoric
            local thistype this
            if GetSpellAbilityId() != 'A006' then 
                return false
            endif
            set u = GetSpellAbilityUnit()
            set this = GetUnitId(u)
            set leoric = FirstOfGroup(GetUnitsOfPlayerAndTypeId(GetTriggerPlayer(), UID_LEORIC))
                    
            if (leoric != null) then
                if (IsUnitAliveBJ(leoric)) then
                    call BJDebugMsg("set position")
                    call SetUnitPositionLocFacingLocBJ(leoric, this.targetLoc, GetUnitLoc(u))
                    call SetUnitAnimation(leoric, "birth")
                    call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", leoric, "origin"))
                else
                    call ReviveHero(leoric, GetLocationX(this.targetLoc), GetLocationY(this.targetLoc), true)
                    call SetUnitAnimation(leoric, "birth")
                endif
            else
                set leoric = CreateUnitAtLoc(GetTriggerPlayer(), UID_LEORIC, this.targetLoc, 0)
                call SetUnitAnimation(leoric, "birth")
                call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl", leoric, "origin"))
            endif
            
            set u = null
            set leoric = null
            return false
        endmethod
        
        private static method playSummoning takes nothing returns nothing
            local thistype this = GetTimerData( GetExpiredTimer() )
            local unit uu = GetUnitById(this)
            local location randomLoc = GetRandomLocInRect(GetRectFromCircleBJ(this.targetLoc, 100))
            local location randomLoc1 = GetRandomLocInRect(GetRectFromCircleBJ(this.targetLoc, 100))
            local location randomLoc2 = GetRandomLocInRect(GetRectFromCircleBJ(this.targetLoc, 100))
        
            // if Loc == null then
            //     return
            // endif
            // if uu == null then
            //     return
            // endif
            
            call SetUnitAnimation(uu, "spell")
            call SetWidgetLife(uu, GetWidgetLife(uu) * 0.95)
            call DestroyEffect(AddSpecialEffectLoc( "Abilities\\Spells\\Orc\\EarthQuake\\EarthQuakeTarget.mdl", this.targetLoc ))
            call DestroyEffect(AddSpecialEffectLoc( "Objects\\Spawnmodels\\Human\\HumanLargeDeathExplode\\HumanLargeDeathExplode.mdl", randomLoc ))
            call DestroyEffect(AddSpecialEffectLoc( "Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl", randomLoc1 ))
            call DestroyEffect(AddSpecialEffectLoc( "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl", randomLoc2 ))
                    
            call RemoveLocation(randomLoc)
            call RemoveLocation(randomLoc1)
            call RemoveLocation(randomLoc2)
        
            set uu = null
            set randomLoc = null
            set randomLoc1 = null
            set randomLoc2 = null
        endmethod
        
        static method onSpellCh takes nothing returns boolean
            local unit u
            local thistype this
            if GetSpellAbilityId() != 'A006' then 
                return false
            endif
            set u = GetTriggerUnit()
            set this = thistype[GetUnitId(u)]
            set this.effectTimer = NewTimerEx(this)
            call BJDebugMsg("this.targetLoc")
            set this.targetLoc = PolarProjectionBJ(GetUnitLoc(u), 300, GetUnitFacing(u))
            
            call TimerStart(effectTimer, 0.3, true, function thistype.playSummoning)
            
            call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodPriest.mdl" , u, "chest"))
            call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl" , u, "chest"))
            call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodFootman.mdl" , u, "chest"))
            call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodKnight.mdl" , u, "chest"))
            call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodSorceress.mdl" , u, "chest"))
            
            set u = null
            return false
        endmethod
    endstruct

    private function init takes nothing returns nothing
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_CHANNEL, function summonLeoric.onSpellCh)
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_EFFECT, function summonLeoric.onSpellEffect)
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_ENDCAST, function summonLeoric.onSpellCastEnd)
    endfunction

endlibrary