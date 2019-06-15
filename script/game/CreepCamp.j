library CreepCamp initializer Init requires Table, TimerUtils, RegisterPlayerUnitEvent, GroupUtils, UnitDex, UniqueList, Seconds

    module BaseRespawn// extends secWatch
        
        // private integer cooldownSecond = 9999

        method onSecond takes integer sec returns nothing
            if ModuloInteger(sec, cooldownSec) == 0 and this.shouldSpawn() then
                call this.spawn()
            endif
        endmethod

        method BaseRespawnInit takes nothing returns nothing
            //local thistype c = thistype.allocate()
            call registerSecond(this)
        endmethod

    endmodule

    module SpawnTarget
        readonly rect targetRect
        private static integer tmpPlayId = 0

        method setTargetRect takes rect target returns nothing
            set this.targetRect = target
        endmethod

        private static method isSpawnUnit takes nothing returns boolean
            return IsUnitAliveBJ(GetFilterUnit()) and GetPlayerId( GetOwningPlayer(GetFilterUnit()) ) == tmpPlayId
        endmethod

        method CountSpawnUnitInTargetRect takes nothing returns integer
            set tmpPlayId = this.playerId
            call GroupEnumUnitsInRect(ENUM_GROUP, this.targetRect, Condition(function thistype.isSpawnUnit))
            return BlzGroupGetSize(ENUM_GROUP)
        endmethod
    endmodule

    struct simpleRespawn extends secWatch
        private integer cooldownSec = 999

        readonly rect spawnRect
        readonly integer playerId = PLAYER_NEUTRAL_AGGRESSIVE
        
        private integer typeCount = 0
        private integer array types[10]
        private integer array counts[10]

        implement BaseRespawn

        private stub method shouldSpawn takes nothing returns boolean
            return true
        endmethod

        private stub method afterSpawn takes nothing returns nothing
            return
        endmethod

        private method spawn takes nothing returns nothing
            local integer i = 0
            loop
                exitwhen i == typeCount
                call CreateNUnitsAtLoc( this.counts[i], this.types[i], Player(this.playerId), GetRectCenter(spawnRect), bj_UNIT_FACING )
                call this.afterSpawn()
                set i = i + 1
            endloop
        endmethod

        static method create takes rect r, integer cdsecond returns thistype
            local thistype this = thistype.allocate()
            set this.spawnRect = r
            set this.cooldownSec = cdsecond
            call this.BaseRespawnInit()
            return this
        endmethod

        method addCreepType takes integer typeId, integer count returns nothing
            set this.types[typeCount] = typeId
            set this.counts[typeCount] = count
            set typeCount = typeCount + 1
        endmethod

        method setPlayerId takes integer playerId returns nothing
            set this.playerId = playerId
        endmethod

        method countUnitInSpawnArea takes real range, boolexpr filter returns integer
            call GroupEnumUnitsInArea(ENUM_GROUP, GetRectCenterX(this.spawnRect), GetRectCenterY(this.spawnRect), range, filter)
            return BlzGroupGetSize(ENUM_GROUP)
        endmethod

    endstruct


    private function Init takes nothing returns nothing
    
    endfunction
endlibrary
