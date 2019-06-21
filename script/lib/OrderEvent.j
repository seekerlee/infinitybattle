//============================================================================
// OrderEvent by Bribe, special thanks to Nestharus and Azlier, version 3.0.1.1
//
// API
// ---
//     RegisterOrderEvent(integer orderId, code eventFunc)
//     RegisterAnyOrderEvent(code eventFunc) //Runs for point/target/instant for any order
//
// Requires
// --------
//     RegisterPlayerUnitEvent: http://www.hiveworkshop.com/threads/snippet-registerevent-pack.250266/
//     Table: http://www.hiveworkshop.com/forums/showthread.php?t=188084
//
library OrderEvent requires RegisterPlayerUnitEvent, Table

globals
    private Table t = 0
endglobals

//============================================================================
function RegisterAnyOrderEvent takes code c returns nothing
    static if RPUE_VERSION_NEW then
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_ORDER, c)
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, c)
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, c)
    else
        call RegisterPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_ORDER, c)
        call RegisterPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, c)
        call RegisterPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, c)
    endif
endfunction

//============================================================================
private function OnOrder takes nothing returns nothing
    call TriggerEvaluate(t.trigger[GetIssuedOrderId()])
endfunction

//============================================================================
function RegisterOrderEvent takes integer orderId, code c returns nothing
    local trigger trig
    if integer(t) == 0 then
        set t = Table.create()
        call RegisterAnyOrderEvent(function OnOrder)
    endif
    set trig = t.trigger[orderId]
    if trig == null then
        set trig = CreateTrigger()
        set t.trigger[orderId] = trig
    endif
    call TriggerAddCondition(trig, Filter(c))
    set trig = null
endfunction

endlibrary