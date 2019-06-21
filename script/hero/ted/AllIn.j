library AllIn initializer init requires SpellEffectEvent, RegisterPlayerUnitEvent, UnitDex, TimerUtils, PlayerUtils, GroupUtils

    globals
        private constant integer AB_CODE_ALLIN = 'A013'
        private constant integer BUF_CODE_ALLIN = 'B006'
        private constant real AB_DUR_ALLIN = 15.1
        private constant integer GOLD_REWARD = 100

        private constant string BOUNTY_ART = "UI\\Feedback\\GoldCredit\\GoldCredit.mdl"
        private real array allDurBonus
    endglobals

    
    private function playGold takes nothing returns boolean
        if IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) then
            call DestroyEffect(AddSpecialEffectTarget(BOUNTY_ART, GetFilterUnit(), "head"))
        endif
        return false
    endfunction

    private function rewardGold takes nothing returns nothing
        local User p = User.first
 
        loop // only loop through players that are playing
            exitwhen p == User.NULL
            //GroupEnumUnitsOfPlayer               takes group whichGroup, player whichPlayer, boolexpr filter returns nothing
            call GroupEnumUnitsOfPlayer(ENUM_GROUP, p.toPlayer(), Filter(function playGold))
            call SetPlayerState(p.toPlayer(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p.toPlayer(), PLAYER_STATE_RESOURCE_GOLD) + GOLD_REWARD)
            set p = p.next
        endloop
    endfunction

    struct allIn extends array
        private boolean isAllin
        private timer bufTimer
        private unit caster

        public static method ActionUnitDeath takes nothing returns boolean
            local unit u = GetDyingUnit()
            local thistype this = GetUnitId(u)
            if isAllin then
                call SetHeroInt(this.caster, GetHeroInt(this.caster, false) + 10, true)
                call ReleaseTimer(this.bufTimer)
                set this.bufTimer = null
                call rewardGold()
            endif

            set u = null
            
            set this.isAllin = false
            set this.caster = null
            return false
        endmethod

        public static method onBufEnd takes nothing returns boolean
            local thistype this = GetTimerData(GetExpiredTimer())

            set this.isAllin = false
            call SetPlayerState(GetOwningPlayer(this.caster), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(this.caster), PLAYER_STATE_RESOURCE_GOLD) - GOLD_REWARD)
            call DestroyEffect(AddSpecialEffectTarget(BOUNTY_ART, this.caster, "head"))

            call ReleaseTimer(GetExpiredTimer())
            set this.bufTimer = null
            set this.caster = null
            return false
        endmethod

        public static method onCast takes nothing returns boolean
            local thistype this = thistype[GetUnitId(GetSpellTargetUnit())]
            if this.isAllin then
                // if this.bufTimer != null then
                call ReleaseTimer(this.bufTimer)
            endif

            set this.isAllin = true
            set this.caster = GetSpellAbilityUnit()
            set this.bufTimer = NewTimerEx(this)
            call TimerStart(this.bufTimer, AB_DUR_ALLIN, false, function thistype.onBufEnd)

            
            // local ability ab = GetSpellAbility()

            // call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_INITIAL_DAMAGE_ESH5, GetUnitAbilityLevel(casterU, AB_CODE_ALLIN) - 1, 1.0)

            // set ab = null
            return false
        endmethod

    endstruct



    private function init takes nothing returns nothing
        call RegisterSpellEffectEvent(AB_CODE_ALLIN, function allIn.onCast)
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_DEATH, function allIn.ActionUnitDeath)
    endfunction
endlibrary
