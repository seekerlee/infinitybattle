library HelixRockets initializer init requires SpellEffectEvent, Knockback, GroupUtils, xecast
    
    globals
        private constant integer BUF_ID_BASH = 'B003'
        private constant integer AB_ID_ROCKET = 'A00V'
        private constant integer AB_ID_CLAP = 'A00U'
    endglobals

    struct fallback
        private unit u
        private real targetX
        private real targetY

        private static method do takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            call Knockback(this.u, 200.0, Atan2(GetUnitY(this.u) - this.targetY, GetUnitX(this.u) - this.targetX), 0.2)

            call ReleaseTimer(GetExpiredTimer())
            set this.u = null
            call this.destroy()
        endmethod

        static method onCast takes nothing returns boolean
            local thistype this = thistype.allocate()
            local timer t = NewTimerEx(this)
            set this.u = GetTriggerUnit()
            set this.targetX = GetSpellTargetX()
            set this.targetY = GetSpellTargetY()

            call TimerStart(t, 0.0, false, function thistype.do)
            set t = null
            return false
        endmethod
    endstruct

    private function castClap takes nothing returns nothing
        local xecast xc = GetTimerData( GetExpiredTimer() )
        call xc.castImmediate()
        call ReleaseTimer(GetExpiredTimer())
    endfunction

    private function onHit takes nothing returns boolean
        local integer lvl = GetUnitAbilityLevel(udg_DamageEventTarget, BUF_ID_BASH)
        local timer t
        local real x1
        local real y1
        local real x2
        local real y2
        local integer size
        local integer i = 0
        local unit u
        local xecast xc
        if lvl == 0 then
            return false
        endif
        call UnitRemoveAbility(udg_DamageEventTarget, BUF_ID_BASH)

        set xc = xecast.createA()
        set xc.abilityid    = AB_ID_CLAP
        set xc.orderstring  = "thunderclap"
        set xc.level = GetUnitAbilityLevel(udg_DamageEventSource, AB_ID_ROCKET)
        set xc.owningplayer = GetOwningPlayer(udg_DamageEventSource)
        set xc.sourcex = GetUnitX(udg_DamageEventTarget)
        set xc.sourcey = GetUnitY(udg_DamageEventTarget)
        set t = NewTimerEx(xc)
        call TimerStart(t, 0.0, false, function castClap)

        call GroupUnitsInArea(ENUM_GROUP, GetUnitX(udg_DamageEventTarget), GetUnitY(udg_DamageEventTarget), 200.)
        set size = BlzGroupGetSize(ENUM_GROUP)
        loop
            exitwhen i == size
            set u = BlzGroupUnitAt(ENUM_GROUP, i)
            if IsUnitEnemy(u, GetOwningPlayer(udg_DamageEventSource)) and (not IsUnitType(u, UNIT_TYPE_STRUCTURE)) and (not IsUnitType(u, UNIT_TYPE_DEAD)) then
                set x1 = GetUnitX(udg_DamageEventSource)
                set y1 = GetUnitY(udg_DamageEventSource)
                set x2 = GetUnitX(u)
                set y2 = GetUnitY(u)
                call Knockback(u, 200.0, Atan2(y2 - y1, x2 - x1), 0.2)
                call SetUnitAnimation(u, "death")
            endif
            set i = i + 1
        endloop
        set t = null
        return false
    endfunction

    private function onAbAdded takes nothing returns boolean
        local xecast xe = xeEventeDummy
        local ability ab
        if xe.abilityid == AB_ID_CLAP then
            set ab = BlzGetUnitAbility(xeTriggerUnit, AB_ID_CLAP)
            call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_AOE_DAMAGE, 0, 100.0)
            set ab = null
        endif
        return false
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        //local trigger tClapped = CreateTrigger()
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition(t, Condition(function onHit))

        //call TriggerRegisterVariableEvent( tClapped, "xeDummyAbilityAddedEvent", EQUAL, 1.00 )
        //call TriggerAddCondition(tClapped, Condition(function onAbAdded))
        
        set t = null
        // set tClapped = null
        // init_body
        call RegisterSpellEffectEvent(AB_ID_ROCKET, function fallback.onCast)
    endfunction
endlibrary
