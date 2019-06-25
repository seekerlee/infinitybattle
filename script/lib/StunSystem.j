library StunSystem uses Table

//********************************************************************************
//              Stun - Version 1.2.0.0 - By iAyanami aka Ayanami
// https://www.hiveworkshop.com/threads/system-stun.196749/
//********************************************************************************
//
//    Stun:
//         - An easy to use system that stuns units
//         - Able to keep track of the remaining stun duration
//
//    Requirements:
//         - JASS NewGen
//         - Table
//
//    Functions:
//         - Stun.apply takes unit whichUnit, real duration, boolean stack returns nothing
//           * whichUnit is the target to be stunned
//           * duration is the duration of the stun
//           * stack is to determine if the stun should be a stacking one or not
//           * true - the stun will stack, the duration of the stun will add up with the previous duration
//           * false - the stun will not stack, the unit will be stunned for the longer stun duration
//
//         - Stun.getDuration takes unit whichUnit returns real
//           * whichUnit is the target to check
//           * returns the remaining stun duration
//
//         - Stun.stop takes unit whichUnit returns nothing
//           * removes stun from the target
//
//    How to import:
//         - Copy the whole "Stun" Trigger Folder into your map
//         - Save the map. Close and re-opem the map.
//         - You should have a new unit (Stun Dummy), ability (Stun (System)) and buff (Stun (System)) created
//         - Read through the Configuration part of the code
//
//    Credits:
//         - Bribe for Table
//
//********************************************************************************
//                                CONFIGURABLES
//********************************************************************************

globals
    // timer period. lower the value, the more accurate but might cause decrease in
    // performance
    private constant real PERIOD = 0.03125

    // raw code of ability "Stun (System)"
    private constant integer ABILID = 'ASTN'
    
    // raw code of buff "Stun (System)"
    private constant integer BUFFID = 'BSTN'
    
    // raw code of unit "Stun Dummy"
    private constant integer STUNID = 'sTUN'
endglobals

//********************************************************************************
//                                     CODE
//********************************************************************************

// initialization
module Init
    private static method onInit takes nothing returns nothing
        set table = Table.create()
        set caster = CreateUnit(Player(13), STUNID, 0, 0, 0)
        
        call UnitAddAbility(caster, ABILID)
    endmethod
endmodule

struct Stun extends array
    private unit u
    private real dur

    private thistype next
    private thistype prev
    
    private static Table table
    private static timer t = CreateTimer()
    private static unit caster
    private static integer count = 0
    
    // remove the stun and deallocate
    private method destroy takes nothing returns nothing
        call UnitRemoveAbility(this.u, BUFFID)
        
        if this.next != 0 then
            set this.next.prev = this.prev
        endif
            
        set this.prev.next = this.next
        set this.dur = 0
        set this.prev = thistype(0).prev
        set thistype(0).prev = this
        
        if thistype(0).next == 0 then
            call PauseTimer(t)
        endif
            
        call table.remove(GetHandleId(this.u))
    endmethod
    
    // iterating through all instances every PERIOD
    private static method iterate takes nothing returns nothing
        local thistype this = thistype(0)
        
        loop
            set this = this.next
            exitwhen this == 0
            if this.dur <= 0 or IsUnitType(this.u, UNIT_TYPE_DEAD) or GetUnitTypeId(this.u) == 0 then
                call this.destroy()
            else
                set this.dur = this.dur - PERIOD
            endif
        endloop
    endmethod
    
    // immediately removes stun for the specified unit
    // ex: call Stun.stop(whichTarget)
    static method stop takes unit u returns nothing
        local integer id = GetHandleId(u)
        
        if table.has(id) then
            call thistype(table[id]).destroy()
        endif
    endmethod
    
    // gets the duration left for stun, not stunned units always return 0
    // ex: local real r = Stun.getDuration(whichTarget)
    static method getDuration takes unit u returns real
            return thistype(table[GetHandleId(u)]).dur
    endmethod
    
    // stunning specified target and to see if the stun is a stacking one or not
    // ex: call Stun.apply(whichTarget, 5.0, false)
    static method apply takes unit u, real dur, boolean b returns nothing
        local thistype this
        local integer id = GetHandleId(u)
        
        if table.has(id) then
            set this = table[id]
        else    
            if thistype(0).prev == 0 then
                set count = count + 1
                set this = count
            else
                set this = thistype(0).prev
                set thistype(0).prev = thistype(0).prev.prev
            endif
            
            if thistype(0).next == 0 then
                call TimerStart(t, PERIOD, true, function thistype.iterate)
            else
                set thistype(0).next.prev = this
            endif
            
            set this.next = thistype(0).next
            set thistype(0).next = this
            set this.prev = thistype(0)
            set table[id] = this
            set this.u = u
            set this.dur = 0
            
            call IssueTargetOrder(caster, "firebolt", this.u)
        endif
        
        if b and dur > 0 then
            set this.dur = this.dur + dur
        else
            if this.dur < dur then
                set this.dur = dur
            endif
        endif
    endmethod

    implement Init
endstruct

endlibrary