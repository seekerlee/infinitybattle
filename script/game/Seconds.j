library Seconds initializer Init requires StaticUniqueList

    globals
        private integer seconds = 0
    endglobals

    interface secWatch
        method onSecond takes integer sec returns nothing
    endinterface

    private struct secWatchList extends array
        implement StaticUniqueList
    endstruct

    function registerSecond takes secWatch sw returns nothing
        call secWatchList.enqueue(sw)
    endfunction

    function unRegisterSecond takes secWatch sw returns nothing
        call secWatchList(sw).remove()
    endfunction

    private function remindTime takes nothing returns boolean
        local secWatchList e = secWatchList.first
        set seconds = seconds + 1
        loop
            exitwhen e == 0
            call secWatch(e).onSecond(seconds)
            set e = e.next
        endloop
        return false
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterTimerEventPeriodic( t, 1.0 )
        call TriggerAddCondition( t, function remindTime )
        set t = null
    endfunction
endlibrary
