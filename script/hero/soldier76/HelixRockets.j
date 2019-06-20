library HelixRockets initializer init requires SpellEffectEvent, Knockback, GroupUtils, xecast
    
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

    private function onHit takes nothing returns boolean
        local integer lvl = GetUnitAbilityLevel(udg_DamageEventTarget, 'BPSE')
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
        call UnitRemoveAbility(udg_DamageEventTarget, 'BPSE')

        set xc = xecast.createA()
        set xc.abilityid    = 'A00U'
        set xc.orderstring  = "thunderclap"
        set xc.level = 1
        set xc.owningplayer = GetOwningPlayer(udg_DamageEventSource)
        call xc.castInPoint(GetUnitX(udg_DamageEventTarget), GetUnitY(udg_DamageEventTarget))

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
        
        return false
    endfunction

    private function onAbAdded takes nothing returns boolean
        local xecast xe = xeEventeDummy
        local ability ab
        if xe.abilityid == 'A00U' then
            set ab = BlzGetUnitAbility(xeTriggerUnit, 'A00U')
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
        call RegisterSpellEffectEvent('A00V', function fallback.onCast)
    endfunction
endlibrary
