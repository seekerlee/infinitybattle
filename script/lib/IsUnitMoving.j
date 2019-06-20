library IsUnitMoving initializer init requires UnitDex

    globals
        real unitMovingEvent = 0
        integer moveEventUnitId

        private boolean array udg_UnitMoving
        private real array udg_UnitMovingX
        private real array udg_UnitMovingY
        private integer array udg_UMovNext
        private integer array udg_UMovPrev
        private real udg_UnitMovementInterval= 1.0
        private boolean array udg_IsUnitPreplaced
    endglobals

    private function IsUnitMovementTracked takes integer i returns boolean
        return udg_UMovPrev[i] != 0 or udg_UMovNext[0] == i
    endfunction

    private function UnitMovementRegister takes nothing returns boolean
        local integer i = GetIndexedUnitId()
        // TODO add requirement
        if not IsUnitMovementTracked(i) then
            set udg_UMovPrev[udg_UMovNext[0]] = i
            set udg_UMovNext[i] = udg_UMovNext[0]
            set udg_UMovNext[0] = i
            set udg_UnitMovingX[i] = GetUnitX(GetUnitById(i))
            set udg_UnitMovingY[i] = GetUnitY(GetUnitById(i))
        endif
        return false
    endfunction

    private function UnitMovementUnregisterEx takes integer unitid returns boolean
        if IsUnitMovementTracked(unitid) then
            set udg_UnitMoving[unitid] = false
            set udg_UMovNext[udg_UMovPrev[unitid]] = udg_UMovNext[unitid]
            set udg_UMovPrev[udg_UMovNext[unitid]] = udg_UMovPrev[unitid]
            set udg_UMovPrev[unitid] = 0
        endif
        return false
    endfunction

    private function UnitMovementUnregister takes nothing returns boolean
        return UnitMovementUnregisterEx(GetIndexedUnitId())
    endfunction
    
    private function RunUnitMovementEvent takes integer i, real e returns nothing
        if e == 1.00 then
            set udg_UnitMoving[i] = true
        else
            set udg_UnitMoving[i] = false
        endif
        set moveEventUnitId = i
        set unitMovingEvent = e
        set unitMovingEvent = 0.00
    endfunction

    //===========================================================================
    // This function runs periodically to check if units are actually moving.
    // 
    private function UnitMovementTracker takes nothing returns nothing
        local integer i = 0
        local integer n
        local real x
        local real y
        loop
            set i = udg_UMovNext[i]
            exitwhen i == 0
            set x = GetUnitX(GetUnitById(i))
            set y = GetUnitY(GetUnitById(i))
            if x != udg_UnitMovingX[i] or y != udg_UnitMovingY[i] then
                set udg_UnitMovingX[i] = x
                set udg_UnitMovingY[i] = y
                if not udg_UnitMoving[i] then
                    if GetUnitTypeId(GetUnitById(i)) != 0 then
                        call RunUnitMovementEvent(i, 1.00)
                    else
                        call UnitMovementUnregisterEx(i)
                        set i = udg_UMovPrev[i] //avoid skipping checks
                    endif
                endif
            elseif udg_UnitMoving[i] then
                call RunUnitMovementEvent(i, 2.00)
            endif
        endloop
    endfunction

    //===========================================================================
    private function init takes nothing returns nothing
        local integer i = 0

        set i=0
        loop
            exitwhen ( i > 1 )
            set udg_UnitMoving[i]=false
            set i=i + 1
        endloop

        set i=0
        loop
            exitwhen ( i > 1 )
            set udg_UnitMovingX[i]=0
            set i=i + 1
        endloop
        
        set i=0
        loop
            exitwhen ( i > 1 )
            set udg_UnitMovingY[i]=0
            set i=i + 1
        endloop
        
        set i=0
        loop
            exitwhen ( i > 1 )
            set udg_UMovNext[i]=0
            set i=i + 1
        endloop

        set i=0
        loop
            exitwhen ( i > 1 )
            set udg_UMovPrev[i]=0
            set i=i + 1
        endloop

        set i=0
        loop
            exitwhen ( i > 1 )
            set udg_IsUnitPreplaced[i]=false
            set i=i + 1
        endloop

        call RegisterUnitIndexEvent(Filter(function UnitMovementRegister), EVENT_UNIT_INDEX)
        call RegisterUnitIndexEvent(Filter(function UnitMovementUnregister), EVENT_UNIT_DEINDEX)
        call TimerStart(CreateTimer(), udg_UnitMovementInterval, true, function UnitMovementTracker)
    endfunction

endlibrary
