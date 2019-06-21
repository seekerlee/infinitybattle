library TriditionCraft initializer init requires GroupUtils, SpellEffectEvent, TimerUtils, UnitDex
    
    globals
        private constant integer AB_CODE_TC = 'A00P'
        private constant integer UNIT_CODE_GHO = 'u000'
        private constant real SPAWN_RANGE = 0.0
    endglobals
    
    private function killU takes nothing returns nothing
        call KillUnit(GetEnumUnit())
    endfunction

    private function AngleBetweenPoints takes real x1, real y1, real x2, real y2 returns real
        return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
    endfunction

    struct triditionCraft extends array
        private group weiG
        private real targetX
        private real targetY

        public static method onBufEnd takes nothing returns boolean
            local thistype this = GetTimerData(GetExpiredTimer())

            call ForGroup(this.weiG, function killU)

            call ReleaseGroup(this.weiG)
            call ReleaseTimer(GetExpiredTimer())
            set this.weiG = null
            return false
        endmethod

        public static method onPositioned takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            local integer i = 0
            local integer size = BlzGroupGetSize(this.weiG)
            local unit u
            loop
                exitwhen i == size
                set u = BlzGroupUnitAt(this.weiG, i)
                call SetUnitFacingTimed(u, AngleBetweenPoints(GetUnitX(u), GetUnitY(u), this.targetX, this.targetY), 0.5)
                set i = i + 1
            endloop

            call ReleaseTimer(GetExpiredTimer())
            set u = null
        endmethod

        public static method onCast takes nothing returns boolean
            local thistype this = thistype[GetUnitId(GetSpellTargetUnit())]
            local timer t = NewTimerEx(this)
            local timer tFacing = NewTimerEx(this)
            local integer i = 0
            local unit u

            set this.targetX = GetUnitX(GetSpellTargetUnit())
            set this.targetY = GetUnitY(GetSpellTargetUnit())
            set this.weiG = NewGroup()
            loop
                exitwhen i == 9
                // call GroupAddUnit(this.weiG, CreateUnit(GetOwningPlayer(GetSpellAbilityUnit()), UNIT_CODE_GHO, GetRandomReal(targetX - SPAWN_RANGE, targetX + SPAWN_RANGE) , GetRandomReal(targetY - SPAWN_RANGE, targetY + SPAWN_RANGE), 0.0))
                set u = CreateUnit(GetOwningPlayer(GetSpellAbilityUnit()), UNIT_CODE_GHO, this.targetX, this.targetY, 0.0)
                call GroupAddUnit(this.weiG, u)
                set i = i + 1
            endloop
            call GroupImmediateOrder(this.weiG, "holdposition")

            call TimerStart(t, 10.0, false, function thistype.onBufEnd)
            call TimerStart(tFacing, 0.03, false, function thistype.onPositioned)

            set t = null
            set tFacing = null
            set u = null
            return false
        endmethod

    endstruct

    private function init takes nothing returns nothing
        call RegisterSpellEffectEvent(AB_CODE_TC, function triditionCraft.onCast)
    endfunction
endlibrary
