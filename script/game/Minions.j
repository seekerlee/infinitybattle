library Minions initializer init requires Table, TimerUtils, RegisterPlayerUnitEvent, GroupUtils, UnitDex

globals

    private group masterGroup
    private Table Master2SlaveGroup
    private group slaveGroup
    private Table slaveOption
    // if too far
    constant key MOVE
    constant key MOVEINSTANT
    constant key KILL
    // tmp
    private real x
    private real y
    private integer oid
endglobals

private interface Iminion
    method onMasterDie takes nothing returns nothing defaults nothing
    method onMasterPointOrder takes nothing returns nothing defaults nothing
    method onMasterTargetOrder takes nothing returns nothing defaults nothing
    method onSlaveDie takes nothing returns nothing defaults nothing
endinterface

module defaultBehavior
    method onMasterDie takes nothing returns nothing
        call KillUnit(this.slave)
    endmethod
    
    method onSlaveDie takes nothing returns nothing
        call this.destroy()
    endmethod
    
endmodule

module d3Behavior
    private boolean slaveReviveOn = true

    // slave must be a hero
    method onMasterDie takes nothing returns nothing
        set this.slaveReviveOn = false
        call KillUnit(this.slave)
        set this.slaveReviveOn = true
    endmethod
    
    static method stand takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer td = GetTimerData(t)
        local unit u = GetUnitById(td)
        call SetUnitLifePercentBJ(u, 100)
        call SetUnitInvulnerable(u, false)
        call PauseUnit(u, false)
        call SetUnitAnimation(u, "birth")
        
        call ReleaseTimer(t)
        set t = null
        set u = null
    endmethod
    
    method onSlaveDie takes nothing returns nothing
        local location loc
        local timer t
        if not slaveReviveOn then
            return
        endif
        set loc = GetUnitLoc(this.slave)
        set t = NewTimer()
        call ReviveHero(this.slave, GetLocationX(loc), GetLocationY(loc), false)
        call PauseUnit(this.slave, true)
        call SetUnitAnimation(this.slave, "death")
        call SetUnitInvulnerable(this.slave, true)
        call SetWidgetLife(this.slave, 1)
        call SetTimerData(t, GetUnitUserData(this.slave))
        call TimerStart(t, this.restTime, false, function thistype.stand)
        
        call RemoveLocation(loc)
        set loc = null
        set t = null
    endmethod
endmodule

module gotoTargetBehavior

    private boolean gotoPaused = false // prevent from master spamming order

    private static method resetPause takes nothing returns nothing
        local integer i = GetTimerData(GetExpiredTimer())
        set thistype(i).gotoPaused = false
        call ReleaseTimer(GetExpiredTimer())
    endmethod

    method onMasterPointOrder takes nothing returns nothing
    
        local location loc
        local timer t 
        if gotoPaused then
            return
        endif
        set this.gotoPaused = true
        set loc = GetRandomLocInRect(GetRectFromCircleBJ(Location(x, y), this.attackRange))
        //local integer masterOrder = oid
        if OrderId("move") == oid then
            call IssuePointOrderLoc(this.slave, "move", loc)
        else
            call IssuePointOrderLoc(this.slave, "attack", loc)
        endif
        set t = NewTimerEx(this)

        call TimerStart(t, 3, false, function thistype.resetPause)

        call RemoveLocation(loc)
        set loc = null
        set t = null
    endmethod
    
    method onMasterTargetOrder takes nothing returns nothing
        local location widLoc = Location(GetWidgetX(GetOrderTarget()), GetWidgetY(GetOrderTarget()))
        local location loc = GetRandomLocInRect(GetRectFromCircleBJ(widLoc, this.attackRange))
        local integer masterOrder = GetIssuedOrderId()
        if OrderId("move") == masterOrder then
            call IssuePointOrderLoc(this.slave, "move", loc)
        else
            call IssuePointOrderLoc(this.slave, "attack", loc)
        endif
        call RemoveLocation(widLoc)
        call RemoveLocation(loc)
        set loc = null
        set widLoc = null
    endmethod
endmodule

struct minionBase extends Iminion

    readonly unit master = null
    readonly unit slave = null
    
    readonly real followRange = 2000.0
    readonly real attackRange = 500.0 // should be < followRange
    private integer followPossibility = 20
    private real followInterval = 2.0
    
    private integer tooFarAction = MOVEINSTANT // default
    
    private timer followTimer
    
    static method create takes unit master, unit slave, real followInterval, integer followPossibility returns minionBase
        local thistype m = thistype.allocate()
        local group masterSlaves
        
        set m.master = master
        set m.slave = slave
        set m.followInterval = followInterval
        set m.followPossibility = followPossibility
        
        if not IsUnitInGroup(master, masterGroup) then // check if add twice
            // new master create his slave group
            call GroupAddUnit(masterGroup, master)
            set Master2SlaveGroup.group[GetHandleId(master)] = CreateGroup()
        endif
        
        if not IsUnitInGroup(slave, slaveGroup) then
            call GroupAddUnit(slaveGroup, slave)
        endif
        
        set masterSlaves = Master2SlaveGroup.group[GetHandleId(master)]
        if not IsUnitInGroup(slave, masterSlaves) then
            call GroupAddUnit(masterSlaves, slave)
        endif
        
        set slaveOption[GetHandleId(slave)] = m
        
        call m.onCreate()
        
        set masterSlaves = null
        return m
    endmethod
    
    private method onCreate takes nothing returns nothing
        set this.followTimer = NewTimer()
        call SetTimerData(this.followTimer, this)
        call TimerStart(this.followTimer, this.followInterval, true, function thistype.follow)
    endmethod
    
    private static method follow takes nothing returns nothing
        local thistype this = GetTimerData(GetExpiredTimer()) // load timer's data.
        
        local integer luck = GetRandomInt(0, 99)
        local location loc = GetRandomLocInRect(GetRectFromCircleBJ(GetUnitLoc(this.master), this.attackRange))
        if IsUnitInRange( this.master, this.slave, this.attackRange) then
            if (luck < this.followPossibility) then
                if 0 == GetUnitAbilityLevel(this.slave, 'Aatk') then
                    call IssuePointOrderLoc(this.slave, "move", loc)
                else
                    call IssuePointOrderLoc(this.slave, "attack", loc)
                endif
            endif
        elseif IsUnitInRange( this.master, this.slave, this.followRange) then
            call IssuePointOrderLoc(this.slave, "smart", loc)
        else // too far, default instant move
            if (this.tooFarAction == MOVE) then
                call IssuePointOrderLoc(this.slave, "smart", loc)
            elseif this.tooFarAction == KILL then
                call KillUnit(this.slave)
            else
                call SetUnitX(this.slave, GetLocationX(loc))
                call SetUnitY(this.slave, GetLocationY(loc))
            endif
        endif
        
        set loc = null
    endmethod
    
    private method onDestroy takes nothing returns nothing
        
        local group masterTeam = Master2SlaveGroup.group[GetHandleId(this.master)]
        call slaveOption.remove(GetHandleId(this.slave))
        call GroupRemoveUnit(slaveGroup, this.slave)
        // 2. remove from master's team
        call GroupRemoveUnit(masterTeam, this.slave)
        // 3. check master has any slave, if none remove master from master group
        if CountUnitsInGroup(masterTeam) == 0 then
            call Master2SlaveGroup.remove(GetHandleId(this.master))
            call DestroyGroup(masterTeam)
            call GroupRemoveUnit(masterGroup, this.master)
        endif
        
        //
        call ReleaseTimer(this.followTimer)
        set this.master = null
        set this.slave = null
        set masterTeam = null
    endmethod
endstruct

private function notifyMasterDie takes nothing returns nothing
    local unit slave = GetEnumUnit()
    local Iminion m = slaveOption[GetHandleId(slave)]
    call m.onMasterDie()
    set slave = null
endfunction

private function notifySlaveDie takes unit slave returns nothing
    local Iminion m = slaveOption[GetHandleId(slave)]
    call m.onSlaveDie()
    set slave = null
endfunction

private function notifyPointOrder takes nothing returns nothing
    local unit slave = GetEnumUnit()
    local Iminion m = slaveOption[GetHandleId(slave)]
    call m.onMasterPointOrder()
    set slave = null
endfunction

private function notifyTargetOrder takes nothing returns nothing
    local unit slave = GetEnumUnit()
    local Iminion m = slaveOption[GetHandleId(slave)]
    call m.onMasterTargetOrder()
    set slave = null
endfunction

private function checkDeath takes nothing returns boolean
    local group team
    if IsUnitInGroup(GetDyingUnit(), masterGroup) then
        set team = Master2SlaveGroup.group[GetHandleId(GetDyingUnit())]
        call ForGroup(team, function notifyMasterDie)
        set team = null
    elseif IsUnitInGroup(GetDyingUnit(), slaveGroup) then
        call notifySlaveDie(GetDyingUnit())
    endif
    return false
endfunction



private function EnablePointOrderTrig takes boolean enable returns nothing
    if enable then
        call EnableTrigger(GetAnyPlayerUnitEventTrigger(EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER))
    else
        call DisableTrigger(GetAnyPlayerUnitEventTrigger(EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER))
    endif
endfunction

private function EnableTargetOrderTrig takes boolean enable returns nothing
    if enable then
        call EnableTrigger(GetAnyPlayerUnitEventTrigger(EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER))
    else
        call DisableTrigger(GetAnyPlayerUnitEventTrigger(EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER))
    endif
endfunction

private function checkPointOrder takes nothing returns boolean
    local group team
    if IsUnitInGroup(GetOrderedUnit(), masterGroup) then
        set x = GetOrderPointX()
        set y = GetOrderPointY()
        set oid = GetIssuedOrderId() // TODO: only move/attack
        set team = Master2SlaveGroup.group[GetHandleId(GetOrderedUnit())]
        call EnablePointOrderTrig(false)
        call ForGroup(team, function notifyPointOrder)
        call EnablePointOrderTrig(true)
        set team = null
    endif
    return false
endfunction

private function checkTargetOrder takes nothing returns boolean
    local group team
    if IsUnitInGroup(GetOrderedUnit(), masterGroup) then
        set team = Master2SlaveGroup.group[GetHandleId(GetOrderedUnit())]
        call EnableTargetOrderTrig(false)
        call ForGroup(team, function notifyTargetOrder)
        call EnableTargetOrderTrig(true)
        set team = null
    endif
    return false
endfunction

private function init takes nothing returns nothing
    
    call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_DEATH, function checkDeath)
    call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, function checkPointOrder)
    call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, function checkTargetOrder)
    
    set Master2SlaveGroup = Table.create()
    set slaveOption = Table.create()
    set masterGroup = CreateGroup()
    set slaveGroup = CreateGroup()
    
endfunction

endlibrary