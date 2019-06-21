library AttachObject /*


    AttachObject v2.02
   
    by
   
    Spellbound
   
   
    ________DESCRIPTION_____________________________________________________________________________
   
    AttachObject (formetly AttachUnit) will bind a unit or special effect to a unit, with respect 
    to angle, distance and, optionally, facing angle of the host. Carrier units are called Hosts 
    and attached units/effects are called Guests.
   
    AttachObject comes with a turret functionality that allows unit Guests to rotate and attack 
    normally, after which they will return to a specific facing position. They can also be made 
    to slowly rotate over time, which maybe be useful for sci-fi type attachements.
   
   
   
    ________REQUIREMENTS____________________________________________________________________________
   
    */ requires     /*
    Nothing
   
    */ optional     /*
    */ ListT,       /* https://www.hiveworkshop.com/threads/containers-list-t.249011/
   
    */ optional     /*
    */ RiseAndFall  /* https://www.hiveworkshop.com/threads/riseandfall.306703/
   
   
   
    ________INSTALLATION____________________________________________________________________________
   
    Simply copy-paste this trigger into your map and install a unit indexer that uses custom values.
    If you get an error telling you that UnitAlive or BlzGetUnitMovementType have been re-declared, 
    comment out the corresponding line:
    */
    native UnitAlive takes unit whichUnit returns boolean
    native BlzGetUnitMovementType takes unit whichUnit returns integer
    /*
   
   
    ________API_____________________________________________________________________________________
   
    /* IMPORTANT */ For units to function as Guests, they must have a positive, non-zero movement 
                    speed. Otherwise they will not move along with their Host.
                   
    STRUCTS
    ¯¯¯¯¯¯¯
   
        GuestEx
       
            GuestEx is you main referrence struct. When you attach a unit or a special effect, the 
            funciton will return a GuestEx instance.
           
            GuestEx members are readonly:
           
            .host
            .guest
            .fx
           
           
        LinkedList
       
            If you do not have ListT in your map, an internal doubly linked list will be created in 
            this library. You may use this linked list for your own purposes should you need one. It
            stores integers.
           
            LinkedList.create() will create a list.
           
            whichLinkedList.push(whichInteger)
                will add an integer at the end of the list.
               
            whichLinkedList.find(whichInteger)
                will return the node associated with that value.
               
            whichLinkedList.erase(whichListItem)
                will remove that specific node in the list.
               
            whichLinkedList.getRandom(whichLinkedList)
                will return a random node.
               
            whichLinkedList.destroy()
                will destroy the list and all the nodes inside
           
            whichLinkedList.size()
                will return the number of nodes in a list
                
            whichLinkedList.empty()
                will return true if the list is empty
           
           
        ListItem
       
            Works with LinkedList. When you do whichLinkedList.push(whichInteger) it will add a new 
            node to the list. When iterating through the list, your node type is ListItem. Eg:
           
            local ListItem node = whichLinkedList.first // this returns the first node in a list
           
            set node = node.next // this gets the next node in the list
            set node = node.prev // this gets the previous node in the list
            set IntegerVariable = node.data // the value stored in the node is accessed through .data
           
            To remove a node from a list, do this:
           
            whichLinkedList.erase(node)
           
            However, for safety reasons, if you are planning to remove a node, have a separate local
            to store node.next in and then at the end of the loop set node to that local. Eg:
           
            local ListItem node = list.first
            local ListItem nodeNext
           
            loop
                exitwhen node == 0
                set nodeNext = node.next
                call list.erase(node)
                set node = nodeNext
            endloop
           
           
        EffectTimed
           
            EffectTimed is used internally to destroy special effects after a certain time, similar
            to an expiration timer on units.
           
            EffectTimed.start(whichEffect, whichDuration)
                Destroys whichEffect after whichDuration.
               
               
    FUNCTIONS
    ¯¯¯¯¯¯¯¯¯
   
        call AttachUnitToHost takes unit g, unit host, real angle, real distance, real zOffset, real offsetFix, boolean staticAngle returns GuestEx
            ^ This function will attach a unit to a host. Returns the guest instance.
           
            [_PARAMETERS_]
            unit guest              - the unit to attach (aka the Guest)
            unit host               - the Host
            real angle              - the angle relative to the Host's facing angle at which the Guest is offset to. In degrees.
            real distance           - the distance between the Host and the Guest
            real zOffset            - the height difference from the Host
            real offsetFix          - if your Guest is off-center, try setting this to -16 or 16.
            boolean staticAngle     - if true, the Guest's angle offset will ignore the Host's facing direction
           
           
        call AttachEffectToHost takes effect fx, unit h, real angle, real distance, real zOffset, real offsetFix, boolean staticAngle returns GuestEx
            Similarly you may attach a special effect to a host instead of a unit. The only difference is the unit parameter is instead a special effect parameter.
           
           
        call SetUnitFacingProperties takes unit guest, real startAngle, real rate, real cooldown, boolean dynamicFacing, boolean turretMode
            ^ This sets an attached unit's facing properties. If this is not called, the unit will always face the same direction.
           
            [_PARAMETERS_]
            unit guest              - the attached unit (aka Guest)
            real startAngle         - the angle at which the Guest begins at. If dynamicFacing (see below) is false, the guest will always face this specific angle.
            real rate               - the speed at which the Guest rotates over time. Set to zero to ignore.
            real cooldown           - this is neccessary if the Guest can attack. It will resume it facing parameters after that cooldown has expired.
            boolean dynamicFacing   - if this is true, the facing angle of the Guest will depend on the facing of the Host.
            boolean turretMode      - Set this to true if you want your Guest to be able to attack. Otherwise, the facing parameters will keep interferring.
           
           
        call SetEffectFacingProperties takes effect fx, real startAngle, real rate, boolean dynamicFacing
            With a special effect, the facing parameters have fewer options. Use this function instead of SetUnitFacingProperties.
       
       
        call DettachUnit takes unit g, boolean resetHeight, real duration
            ^ Call this function when you want to Dettach a Guest from a Host. real duration is for how long after Dettachement do you want the Guest to die.
            Set real time to zero if you don't want the Guest to die. This function is called automatically when a Guest dies.
       
       
        call DettachEffect takes effect fx, real duration
            ^ same as above, but specific to attached effects. real duration call EffectTimed.start(guest.fx, duration) internally if duration is greater than zero.
           
           
        call DettachAllGuests takes unit h, boolean resetHeight, real duration
            ^ Call this function on a Host to Dettach all its Guests. This function will NOT get called automatically on Host death and must be done manually.
            Similarly to DettachGuest, real duration will determine how long after Dettachment will the Guest die. Set to zero to not destroy your Dettached Guests.
       
       
        call GetRandomGuest takes unit h, boolepx guestFilter returns unit
            ^ This will return a random Guest attached to a Host. Set guestFilter to null if you do not wish to filter your guests.
            /* IMPORTANT */ In your filter you MUST use the variable 'FilterGuest' and NOT GetFilterUnit().
           
           
        call GetNumberOfGuests takes unit h returns integer
            ^ This will return the number of Guests currently connected to a Host.
           
       
        call GroupUnitGuests takes unit h returns group
            ^ this will take all UNIT Guests attached to a Host and put them in a unit group via:
            set YourGroup = GrouGuests(host).
       
       
        call GetGuestList takes unit h returns integer
            ^ this will copy the Guest list of a host and return either an IntegerList instance or 
            LinkedList instance. When you are done with that copy, YOU MUST DESTROY IT with 
            list.destroy().
           
            If you have ListT, the list returned will be an IntegerList type. Otherwise the type
            returned will be LinkedList. The node struct for LinkedList is ListItem. See the trigger
            HowToIterateThroughLists if you are unfamiliar with linked lists.
           
            GetGuestList() is not wait-safe as the list is not being updated if Guests are
            added or removed.
           
       
        call IsUnitHost takes unit h returns boolean
            ^ Returns true if a unit is a Host.


        call IsUnitGuest takes unit g returns boolean
            ^ Returns true if a unit is a Guest.


        call IsEffectGuest takes effect fx returns boolean
            ^ Returns true if an effect is a Guest.
           
           
        call IsGuestUnit takes GuestEx ex returns boolean
            ^ Returns true if a Guest is a unit.


        call IsGuestEffect takes GuestEx ex returns boolean
            ^ Returns true if a Guest is a special effect.
           
       
        call GetHost takes GuestEx ex returns unit
            ^ Returns the Host unit of a Guest.


        call GetGuestUnitId takes unit g returns GuestEx
            ^ Returns the readonly instance id of a unit Guest.


        call GetGuestEffectId takes effect fx returns GuestEx
            ^ Returns the readonly instance id of an effect Guest.
       
       
        call ShowGuests takes unit h returns nothing
            ^ Cycles through all the Guests of a Host and unhides them.
            This function is called automatically when a Host is unhidden.
       
       
        call HideGuests takes unit h returns nothing
            ^ Cycles through all Guests a Host has and hides them.
            This function is called automatically when a Host is hidden.
           
           
        call ShowGuest takes GuestEx ex returns nothing
            ^ not to be mistaken with ShowGuests, this will reveal ONE Guest. ShowGuest does
            not break locaut ('Aloc').
   
   
   
*/   

globals
   
    // interval between Guest updates. Do not change this or things will look choppy.
    private constant real TIMEOUT = .03125
   
    // order attack for turret mode
    private constant integer ORDER_ATTACK = 851983
   
    // If true then Guests will reset to their default fly height when they are dettached.
    private constant boolean RESET_HEIGHT = true
   
    // the speed at which they rise/fall if RESET_HEIGHT is true.
    private constant real FALL_SPEED = 300.
   
    unit FilterGuest = null
    private trigger FilterTrig = CreateTrigger()

    private hashtable TurretStorage = InitHashtable()
    private hashtable IdStorage = InitHashtable()
    private timer Clock = CreateTimer()
       
    private group GuestGroup = CreateGroup()
endglobals

//! runtextmacro optional DEFINE_LIST("", "AOList", "integer")
   
static if LIBRARY_ListT then

    private struct GlobalListT
        static AOList Guests = 0
        static AOList Hosts = 0
    endstruct
   
    function ListTGetRandom takes AOList list returns AOListItem
        local integer size = list.size()
        local integer i
        local AOListItem node = 0
               
        debug if size == 0 then 
        debug call BJDebugMsg("the list is empty")
        debug return 0
        debug endif 
       
        // thanks to Wareditor for that bit of code
        if size > 0 then
            set i = GetRandomInt(1, size)
            if i > size / 2 then
                set i = size - i
                set node = list.last
                loop
                    exitwhen i == 0
                    set node = node.prev
                    set i = i - 1
                endloop
            else
                set i = i - 1
                set node = list.first
                loop
                    exitwhen i == 0
                    set node = node.next
                    set i = i - 1
                endloop
            endif
        endif
       
        return node
    endfunction
   
else
   
    private struct GlobalList
        static LinkedList Guests = 0
        static LinkedList Hosts = 0
    endstruct
   
    // LINKED LIST
    struct ListItem
       
        ListItem next
        ListItem prev
        integer data
       
        method destroy takes nothing returns nothing
            set this.prev.next = this.next
            set this.next.prev = this.prev
            set this.next = 0
            set this.prev = 0
            set this.data = 0
            call this.deallocate()
        endmethod
       
        static method create takes integer i returns thistype
            local thistype this = allocate()
            set this.next = 0
            set this.prev = 0
            set this.data = i
            return this
        endmethod
       
    endstruct

    struct LinkedList
       
        readonly ListItem first
        readonly ListItem last
        readonly integer count
       
        method destroy takes nothing returns nothing
            local ListItem node = .first
            local ListItem nodeNext
            loop
                exitwhen node == 0
                set nodeNext = node.next
                call node.destroy()
            endloop
            set .first = 0
            set .last = 0
            set .count = 0
            call this.deallocate()
        endmethod
       
        // returns the size of a list
        method size takes nothing returns integer
            return this.count
        endmethod
        
        method empty takes nothing returns boolean
            return this.count == 0
        endmethod
       
        // inserts an element at the end of the list
        method push takes integer i returns nothing
            local ListItem node = allocate()
           
            if .count == 0 then
                set .first = node
            else
                set .last.next = node
            endif
           
            set node.prev = .last   // .last is already set to 0 at list creation
            set node.next = 0       // otherwise the list will cycle forever
            set .last = node
           
            set node.data = i
           
            set .count = .count + 1
        endmethod
       
        // removes a node from the list
        method erase takes ListItem node returns nothing
            call node.destroy()
            set .count = .count - 1
        endmethod
       
        method getRandom takes nothing returns ListItem
            local integer i = GetRandomInt(1, .count)
            local ListItem node = 0
           
            debug if .count == 0 then 
            debug call BJDebugMsg("the list is empty")
            debug return 0
            debug endif 
           
            // thanks to Wareditor for that bit of code
            if .count > 0 then
                if i > .count / 2 then
                    set i = .count - i
                    set node = .last
                    loop
                        exitwhen i == 0
                        set node = node.prev
                        set i = i - 1
                    endloop
                else
                    set i = i - 1
                    set node = .first
                    loop
                        exitwhen i == 0
                        set node = node.next
                        set i = i - 1
                    endloop
                endif
            endif
           
            return node
        endmethod
       
        method find takes integer i returns ListItem
            local ListItem node = .first
            loop
                exitwhen node == 0 or node.data == i
                set node = node.next
            endloop
            return node
        endmethod
       
        static method create takes nothing returns thistype
            local thistype this =  allocate()
            set this.first = 0
            set this.last = 0
            set this.count = 0
            return this
        endmethod

    endstruct

endif

// specfic for reading Guest data
struct GuestEx
    readonly unit host
    readonly unit guest
    readonly effect fx
   
    method destroy takes nothing returns nothing
        set this.host = null
        set this.guest = null
        set this.fx = null
        call this.deallocate()
    endmethod
   
    static method create takes unit h, unit g, effect fx returns thistype
        local thistype this = allocate()
        set this.host = h
        set this.guest = g
        set this.fx = fx
        return this
    endmethod
endstruct

private struct Guest
   
    real cooldown
    real cooldownReset
    trigger turretTrigger
    boolean dynamicFacing
    boolean updateFacing
    boolean isHidden
   
    real distance
    real angle
    real zOffset
    real offsetFix
    real angleRate
    real facing
    real idleAngle
    boolean staticAngle
   
    unit parent
    unit u
    effect fx
   
    GuestEx ex
   
    method destroy takes nothing returns nothing
        if this.fx != null then
            call FlushChildHashtable(IdStorage, GetHandleId(this.fx))
            set this.fx = null
        else
            call FlushChildHashtable(IdStorage, GetHandleId(this.u))
            set this.u = null
        endif
        set this.parent = null
        set this.staticAngle = false
        set this.dynamicFacing = false
        set this.updateFacing = false
        set this.isHidden = false
        set this.angleRate = 0.
        set this.idleAngle = 0.
        call this.ex.destroy()
        set this.ex = 0
        call this.deallocate()
    endmethod
   
    static method create takes unit g, effect fx, unit h returns thistype
        local thistype this = allocate()
        
        static if LIBRARY_ListT then
            call GlobalListT.Guests.push(this)
        else
            call GlobalList.Guests.push(this)
        endif
        
        set this.parent = h
        set this.u = g
        set this.fx = fx
        set this.ex = GuestEx.create(h, g, fx)
        
        if g == null then
            call SaveInteger(IdStorage, GetHandleId(fx), 0, this)
        else
            call SaveInteger(IdStorage, GetHandleId(g), 0, this)
        endif
        
        return this
    endmethod
   
endstruct

private struct Host
   
    real x
    real y
    real z
    real f
    unit u
    boolean hiddenState
   
    static if LIBRARY_ListT then
        AOList guestList
    else
        LinkedList guestList
    endif
   
    method destroy takes nothing returns nothing
        call FlushChildHashtable(IdStorage, GetHandleId(this.u))
        call this.guestList.destroy()
        set this.u = null
        set this.hiddenState = false
        static if LIBRARY_ListT then
            call GlobalListT.Hosts.removeElem(this)
            if GlobalListT.Hosts.empty() then
                call PauseTimer(Clock)
            endif
        else
            call GlobalList.Hosts.erase(this)
            if GlobalList.Hosts.empty() then
                call PauseTimer(Clock)
            endif
        endif
        call this.deallocate()
    endmethod
   
    method addGuest takes Guest guest returns nothing
        call this.guestList.push(guest)
    endmethod
   
    static method create takes unit h returns thistype
        local thistype this = allocate()
        
        static if LIBRARY_ListT then
            set this.guestList = AOList.create()
            call GlobalListT.Hosts.push(this)
        else
            set this.guestList = LinkedList.create()
            call GlobalList.Hosts.push(this)
        endif
        
        set this.u = h
        set this.hiddenState = IsUnitHidden(h)
        call SaveInteger(IdStorage, GetHandleId(h), 0, this)
        return this
    endmethod
   
endstruct

struct EffectTimed
   
    private effect fx
    private real dur
    private static timer clock = CreateTimer()
   
    static if LIBRARY_ListT then
        static AOList fxList
    else
        static LinkedList fxList
    endif
   
    private static method update takes nothing returns nothing
        local thistype this
       
        static if LIBRARY_ListT then
            local AOListItem node = thistype.fxList.first
            local AOListItem nodeNext
        else
            local ListItem node = thistype.fxList.first
            local ListItem nodeNext
        endif
       
        loop
            exitwhen node == 0
            set nodeNext = node.next
            set this = node.data
           
            set this.dur = this.dur - TIMEOUT
            if this.dur <= 0. then
                call DestroyEffect(this.fx)
                set this.fx = null
                call this.deallocate()
            endif
           
            set node = nodeNext
        endloop
       
        if thistype.fxList.size() < 1 then
            call PauseTimer(thistype.clock)
        endif
    endmethod
   
    static method start takes effect vfx, real duration returns nothing
        local thistype this = allocate()
        set this.fx = vfx
        set this.dur = duration
        call thistype.fxList.push(this)
        if thistype.fxList.size() == 1 then
            call TimerStart(thistype.clock, TIMEOUT, true, function thistype.update)
        endif
    endmethod
   
endstruct

//REFERENCE AND OTHER USEFUL FUNCTIONS

// library use only
private function GetPrivateHostUnitId takes unit h returns Host
    return LoadInteger(IdStorage, GetHandleId(h), 0)
endfunction

private function GetPrivateGuestUnitId takes unit g returns Guest
    return LoadInteger(IdStorage, GetHandleId(g), 0)
endfunction

private function GetPrivateGuestEffectId takes effect e returns Guest
    return LoadInteger(IdStorage, GetHandleId(e), 0)
endfunction

// public use
function GetHost takes Guest guest returns unit
    return guest.parent
endfunction

function IsUnitHost takes unit h returns boolean
    return LoadInteger(IdStorage, GetHandleId(h), 0) != 0
endfunction

function IsUnitGuest takes unit g returns boolean
    return LoadInteger(IdStorage, GetHandleId(g), 0) != 0
endfunction

function IsEffectGuest takes effect e returns boolean
    return LoadInteger(IdStorage, GetHandleId(e), 0) != 0
endfunction

function IsGuestUnit takes GuestEx ex returns boolean
    return ex.guest != null
endfunction

function IsGuestEffect takes GuestEx ex returns boolean
    return ex.fx != null
endfunction

function GetGuestUnitId takes unit g returns GuestEx
    local Guest guest = LoadInteger(IdStorage, GetHandleId(g), 0)
    return guest.ex
endfunction

function GetGuestEffectId takes effect e returns GuestEx
    local Guest guest = LoadInteger(IdStorage, GetHandleId(e), 0)
    return guest.ex
endfunction

function GetNumberOfGuests takes unit h returns integer
    local Host host = GetPrivateHostUnitId(h)
    return host.guestList.size()
endfunction

function GroupUnitGuests takes unit h returns group
    local Host host = GetPrivateHostUnitId(h)
    local Guest guest
   
    static if LIBRARY_ListT then
        local AOListItem node = host.guestList.first
    else
        local ListItem node = host.guestList.first
    endif
   
    if GuestGroup == null then
        set GuestGroup = CreateGroup()
    else
        call GroupClear(GuestGroup)
    endif
   
    if IsUnitHost(h) then
        loop
            exitwhen node == 0
            set guest = node.data
            call GroupAddUnit(GuestGroup, guest.u)
            set node = node.next
        endloop
    endif
   
    return GuestGroup
endfunction

static if LIBRARY_ListT then
function GetGuestList takes unit h returns IntegerList
else
function GetGuestList takes unit h returns LinkedList
endif
    local Host host = GetPrivateHostUnitId(h)
    local Guest guest
   
    static if LIBRARY_ListT then
        //return IntegerList[host.guestList]
        local IntegerList list = IntegerList.create()
        local IntegerListItem node = host.guestList.first
    else
        local LinkedList list = LinkedList.create()
        local ListItem node = host.guestList.first
    endif
   
    loop
        exitwhen node == 0
        set guest = node.data
        call list.push(guest.ex)
        set node = node.next
    endloop
    return list
endfunction

function GetRandomGuest takes unit h, boolexpr guestFilter returns unit
   
    local Host host = GetPrivateHostUnitId(h)
    local Guest guest
   
    static if LIBRARY_ListT then
        local AOListItem node = ListTGetRandom(host.guestList)
    else
        local ListItem node = host.guestList.getRandom()
    endif
   
    local unit u
    local triggercondition tcnd
    local boolean firstPass = false
    local integer n = host.guestList.size()
       
    if guestFilter == null then
        set guest = node.data
        return guest.u
    else
        set firstPass = (node == host.guestList.first)
        set FilterGuest = null
       
        loop
            exitwhen node == 0 and firstPass
           
            if node == 0 and not firstPass then
                set node = host.guestList.first
                set firstPass = true
            endif
           
            set guest = node.data
            set u = guest.u
           
            set tcnd = TriggerAddCondition(FilterTrig, guestFilter)
            if TriggerEvaluate(FilterTrig) then
                set FilterGuest = u
            endif
            call TriggerRemoveCondition(FilterTrig, tcnd)
           
            set node = node.next
        endloop
       
        set u = null
        set tcnd = null
       
        return FilterGuest
    endif
    return null
endfunction

function ShowGuest takes GuestEx ex returns nothing
    local Guest guest
    if ex.guest != null then
        set guest = GetGuestUnitId(ex.guest)
        if IsUnitHidden(guest.u) then
            call ShowUnit(guest.u, true)
            if GetUnitAbilityLevel(guest.u, 'Aloc') > 0 then
                call UnitRemoveAbility(guest.u, 'Aloc')
                call UnitAddAbility(guest.u, 'Aloc')
            endif
        endif
    else
        set guest = GetGuestEffectId(ex.fx)
    endif
    set guest.isHidden = false
endfunction

private function ShowGuestEx takes Guest guest returns nothing
    set guest.isHidden = false
    if guest.u != null then
        if IsUnitHidden(guest.u) then
            call ShowUnit(guest.u, true)
            if GetUnitAbilityLevel(guest.u, 'Aloc') > 0 then
                call UnitRemoveAbility(guest.u, 'Aloc')
                call UnitAddAbility(guest.u, 'Aloc')
            endif
        endif
    endif
endfunction

function ShowGuestsEx takes unit h, boolean flag returns nothing
   
    local Host host = GetPrivateHostUnitId(h)
    local Guest guest
   
    static if LIBRARY_ListT then
        local AOListItem node = host.guestList.first
    else
        local ListItem node = host.guestList.first
    endif
   
    loop
        exitwhen node == 0
        set guest = node.data
        if flag then
            call ShowGuestEx(guest)
        else
            call ShowUnit(guest.u, false)
            call BlzSetSpecialEffectZ(guest.fx, -1000.)
            set guest.isHidden = true
        endif
        set node = node.next
    endloop
   
endfunction

function ShowGuests takes unit h returns nothing
    call ShowGuestsEx(h, true)
endfunction

function HideGuests takes unit h returns nothing
    call ShowGuestsEx(h, false)
endfunction


//Core function to dettach guests from hosts
private function DettachObject takes Guest guest, boolean resetHeight, real time returns nothing
    local Host host
   
    static if LIBRARY_RiseAndFall then
        local real hc // height current
        local real hd // height default
        local integer moveType
        local real duration
    endif
   
    if guest.turretTrigger != null then
        call FlushChildHashtable(TurretStorage, GetHandleId(guest.turretTrigger))
        call DestroyTrigger(guest.turretTrigger)
        set guest.turretTrigger = null
    endif
   
    if guest.parent != null then
        set host = GetPrivateHostUnitId(guest.parent)
       
        static if LIBRARY_ListT then
            call host.guestList.removeElem(guest)
        else
            call host.guestList.erase(guest)
        endif
       
        if guest.u != null then
            if UnitAlive(guest.u) and time > 0. then
                call UnitApplyTimedLife(guest.u , 'BTLF', time)
            endif
            
            static if RESET_HEIGHT then
                if resetHeight then
                    static if LIBRARY_RiseAndFall then
                        set hc = GetUnitFlyHeight(guest.u)
                        set hd = GetUnitDefaultFlyHeight(guest.u)
                        set moveType = BlzGetUnitMovementType(guest.u)
                        set duration = (hc - hd) / FALL_SPEED
                        if duration < 0. then
                            set duration = -duration
                        endif
                        call RiseAndFall.create(guest.u, hc, hd, duration, (moveType == 8 or moveType == 2))
                    else
                        call SetUnitFlyHeight(guest.u, GetUnitDefaultFlyHeight(guest.u), FALL_SPEED)
                    endif
                endif
            endif
        endif
       
        if guest.fx != null and time > 0. then
            call EffectTimed.start(guest.fx, time)
        endif
       
        call SetUnitPropWindow(guest.u, GetUnitDefaultPropWindow(guest.u) * bj_DEGTORAD)
        call UnitRemoveAbility(guest.u, 'Aeth')
        call SetUnitPathing(guest.u, true)
       
        if host.guestList.empty() then
            call host.destroy()
        endif
    endif
    
    call guest.destroy()
endfunction

private function DettachAllObjects takes Host host, boolean resetHeight, real time returns nothing
    local Guest guest
   
    static if LIBRARY_ListT then
        local AOListItem node = host.guestList.first
        local AOListItem nodeNext
    else
        local ListItem node = host.guestList.first
        local ListItem nodeNext
    endif
       
    loop
        exitwhen node == 0
        set nodeNext = node.next
        set guest = node.data
        call DettachObject(guest, resetHeight, time)
        set node = nodeNext
    endloop
   
endfunction

function DettachEffect takes effect fx, boolean resetHeight, real time returns nothing
    call DettachObject(GetPrivateGuestEffectId(fx), resetHeight, time)
endfunction

function DettachUnit takes unit g, boolean resetHeight, real time returns nothing
    call DettachObject(GetPrivateGuestUnitId(g), resetHeight, time)
endfunction

function DettachAllGuests takes unit h, boolean resetHeight, real time returns nothing
    call DettachAllObjects(GetPrivateHostUnitId(h), resetHeight, time)
endfunction


private function TurretActions takes nothing returns nothing
    local Guest guest = LoadInteger(TurretStorage, GetHandleId(GetTriggeringTrigger()), 0)
    set guest.cooldown = guest.cooldownReset
    if GetUnitCurrentOrder(guest.u) != ORDER_ATTACK then
        call IssuePointOrderById(guest.u, ORDER_ATTACK, GetUnitX(guest.u), GetUnitY(guest.u))
    endif
endfunction

private function UpdateGuests takes nothing returns nothing
   
    local real x
    local real y
    local real z
    local real f
    local real a
    local real xNew
    local real yNew
    local real zNew
   
    static if LIBRARY_ListT then
        local AOListItem node = GlobalListT.Hosts.first
        local AOListItem nodeNext
        local AOListItem nNode
        local AOListItem nNodeNext
    else
        local ListItem node = GlobalList.Hosts.first
        local ListItem nodeNext
        local ListItem nNode
        local ListItem nNodeNext
    endif
   
    local Host host
    local Guest guest
   
    // This loop cycles through all the Hosts and a secondary loop inside cycles through their
    // attached Guests, updating their x, y and z coordiates.
    loop
   
        exitwhen node == 0
        set nodeNext = node.next
       
        set host = node.data       
        set x = GetUnitX(host.u)
        set y = GetUnitY(host.u)
        set z = BlzGetLocalUnitZ(host.u)
        set f = GetUnitFacing(host.u)
        
        if not IsUnitHidden(host.u) then
           
            // unhide guests if host was previously hidden
            if host.hiddenState then
                set host.hiddenState = false
                call ShowGuestsEx(host.u, true)
            endif
           
            if x != host.x or y != host.y or z != host.z or f != host.f then
               
                set nNode = host.guestList.first
                loop
                    exitwhen nNode == 0
                    set nNodeNext = nNode.next
                   
                    set guest = nNode.data
                   
                    // required for manually hidden special effects
                    if not guest.isHidden then
                        if guest.staticAngle then
                            set a = 0.
                        else
                            set a = f * bj_DEGTORAD
                        endif
                       
                        set xNew = guest.offsetFix + x + Cos(guest.angle + a) * guest.distance
                        set yNew = guest.offsetFix + y + Sin(guest.angle + a) * guest.distance
                        set zNew = z + guest.zOffset
                       
                        if guest.u != null then
                            call SetUnitX(guest.u, xNew)
                            call SetUnitY(guest.u, yNew)
                            call SetUnitFlyHeight(guest.u, zNew, 0.)
                        endif
                       
                        if guest.fx != null then
                            call BlzSetSpecialEffectPosition(guest.fx, xNew, yNew, zNew)
                        endif
                    endif
                   
                    set nNode = nNodeNext
                endloop
               
                set host.x = x
                set host.y = y
                set host.z = z
                set host.f = f * bj_RADTODEG
           
            endif
           
        else
           
            // hide guests if host was not previously hidden
            if not host.hiddenState then
                set host.hiddenState = true
                call ShowGuestsEx(host.u, false)
            endif
           
        endif
       
        set node = nodeNext
       
    endloop
   
    static if LIBRARY_ListT then
        set node = GlobalListT.Guests.first
    else
        set node = GlobalList.Guests.first
    endif
   
    // Updates the facing angle of Guests that rotate when idle and when not to turn (eg when in combat).
    loop
   
        exitwhen node == 0
        set nodeNext = node.next
       
        set guest = node.data
       
        if guest.u != null and not UnitAlive(guest.u) then
            call DettachObject(guest, true, 0.)
        else
           
            if guest.updateFacing and not guest.isHidden then
               
                if guest.dynamicFacing then
                    set f = GetUnitFacing(guest.parent)
                else
                    set f = 0.
                endif
               
                set guest.facing = guest.facing + guest.angleRate
                       
                if guest.u == null then
                    call BlzSetSpecialEffectRoll(guest.fx, guest.facing + f * bj_DEGTORAD)
                else
                    if GetUnitCurrentOrder(guest.u) != 0 then
                        if guest.cooldown > 0. then
                            set guest.cooldown = guest.cooldown - TIMEOUT
                        else
                            set guest.cooldown = guest.cooldownReset
                            call IssueImmediateOrderById(guest.u, 851973) //order stunned
                            call SetUnitFacing(guest.u, guest.idleAngle + f)
                        endif
                       
                        if guest.angleRate != 0. then
                            // Store the facing of the unit if it needs to rotate later
                            set guest.facing = GetUnitFacing(guest.u)
                        endif
                    else
                        call SetUnitFacing(guest.u, guest.facing + f)
                    endif
                endif
               
            endif
           
        endif
       
        set node = nodeNext
   
    endloop
endfunction


private function SetFacingProperties takes Guest guest, real startAngle, real rate, real cooldown, boolean dynamicFacing, boolean turretMode returns nothing
    local real f
   
    if guest != 0 then
        set guest.cooldownReset = cooldown
        set guest.cooldown = cooldown
        set guest.updateFacing = true
       
        set guest.angleRate = rate * TIMEOUT
        set guest.dynamicFacing = dynamicFacing
           
        if guest.u == null then
            set guest.facing = startAngle * bj_DEGTORAD
            set guest.idleAngle = guest.facing
            set guest.angleRate = guest.angleRate * bj_DEGTORAD
            call BlzSetSpecialEffectRoll(guest.fx, guest.facing)
        else
            set guest.facing = startAngle
            set guest.idleAngle = guest.facing
            call SetUnitFacing(guest.u, guest.facing)
        endif
       
        if turretMode and guest.u != null then
            set guest.turretTrigger = CreateTrigger()
            call TriggerRegisterUnitEvent(guest.turretTrigger, guest.u, EVENT_UNIT_ACQUIRED_TARGET)
            call TriggerRegisterUnitEvent(guest.turretTrigger, guest.u, EVENT_UNIT_TARGET_IN_RANGE)
            call SaveInteger(TurretStorage, GetHandleId(guest.turretTrigger), 0, guest)
            call TriggerAddCondition(guest.turretTrigger, Condition(function TurretActions))
        endif
    endif
endfunction

function SetEffectFacingProperties takes effect fx, real startAngle, real rate, boolean dynamicFacing returns nothing
    call SetFacingProperties(GetPrivateGuestEffectId(fx), startAngle, rate, 0., dynamicFacing, false)
endfunction

function SetUnitFacingProperties takes unit g, real startAngle, real rate, real cooldown, boolean dynamicFacing, boolean turretMode returns nothing
    call SetFacingProperties(GetPrivateGuestUnitId(g), startAngle, rate, cooldown, dynamicFacing, turretMode)
endfunction


private function AttachObject takes unit g, effect fx, unit h, real angle, real distance, real zOffset, real offsetFix, boolean staticAngle returns GuestEx
   
    local Host host = GetPrivateHostUnitId(h)
    local Guest guest = GetPrivateGuestUnitId(g)
   
    static if LIBRARY_ListT then
        local AOListItem node = GlobalListT.Hosts.first
    else
        local ListItem node = GlobalList.Hosts.first
    endif
   
    local real x = GetUnitX(h)
    local real y = GetUnitY(h)
    local real z = BlzGetLocalUnitZ(h)
    local real f = GetUnitFacing(h)
    local real a
    local real xNew
    local real yNew
    local real zNew
    
    // if there is no host or not effect and guest unit, end the function
    if h == null or (g == null and fx == null) then
        return 0
    endif
    
    // if guest instance is not null then it's already attached to a unit
    if guest != 0 then
        if guest.parent == h then
            return 0
        else
            call DettachObject(guest, false, 0.)
        endif
    endif
    
    // check if the Host has an instance
    if host == 0 then
        set host = Host.create(h)
        set host.x = x
        set host.y = y
        set host.z = z
        set host.f = f
    endif
    
    set guest = Guest.create(g, fx, h)
   
    call host.addGuest(guest)
   
    set guest.angle = angle * bj_DEGTORAD
    set guest.staticAngle = staticAngle
    set guest.distance = distance
    set guest.zOffset = zOffset
    set guest.offsetFix = offsetFix
   
    // if angle is static then ignore the Host's facing angle.
    if staticAngle then
        set a = guest.angle
    else
        set a = guest.angle + f * bj_DEGTORAD
    endif
   
    set xNew = offsetFix + x + Cos(a) * distance
    set yNew = offsetFix + y + Sin(a) * distance
    set zNew = z + zOffset
   
    if g == null then
        set guest.facing = f * bj_DEGTORAD
        call BlzSetSpecialEffectPosition(fx, xNew, yNew, zNew)
        call BlzSetSpecialEffectRoll(fx, guest.facing)
    else
        set guest.facing = f
        call SetUnitX(g, xNew)
        call SetUnitY(g, yNew)
        call SetUnitFlyHeight(g, zNew, 0.)
        call SetUnitFacing(g, guest.facing)
        call SetUnitPropWindow(g, 0.)
        call UnitAddAbility(g, 'Aeth')
        call SetUnitPathing(g, false)
    endif
   
    static if LIBRARY_ListT then
        if GlobalListT.Hosts.size() == 1 then
            call TimerStart(Clock, TIMEOUT, true, function UpdateGuests)
        endif
    else
        if GlobalList.Hosts.size() == 1 then
            call TimerStart(Clock, TIMEOUT, true, function UpdateGuests)
        endif
    endif
   
    return guest.ex
endfunction

function AttachEffectToHost takes effect fx, unit h, real angle, real distance, real zOffset, real offsetFix, boolean staticAngle returns Guest
    return AttachObject(null, fx, h, angle, distance, zOffset, offsetFix, staticAngle)
endfunction

function AttachUnitToHost takes unit g, unit h, real angle, real distance, real zOffset, real offsetFix, boolean staticAngle returns Guest
    return AttachObject(g, null, h, angle, distance, zOffset, offsetFix, staticAngle)
endfunction


// Initialisation - the module, the module's method and the struct must all be private. The method must be static.
private module init
    private static method onInit takes nothing returns nothing
       
        static if LIBRARY_ListT then
            set GlobalListT.Guests = AOList.create()
            set GlobalListT.Hosts = AOList.create()
            set EffectTimed.fxList = AOList.create()
        else
            set GlobalList.Guests = LinkedList.create()
            set GlobalList.Hosts = LinkedList.create()
            set EffectTimed.fxList = LinkedList.create()
        endif
       
    endmethod
endmodule

private struct Init
    implement init
endstruct

endlibrary