library aurabuff initializer init

globals    
    private hashtable timerParams = null
    private hashtable unit2Timer = null
    
    private constant integer KEY_UNIT = 0
    private constant integer KEY_ABCODE = 1
endglobals

private function removeAura takes nothing returns nothing
    local integer tid = GetHandleId(GetExpiredTimer())
    local unit u = LoadUnitHandle(timerParams, tid, KEY_UNIT)
    local integer abCode = LoadInteger(timerParams, tid, KEY_ABCODE)
    
    call BJDebugMsg("timer expired, removeAura")
    call UnitRemoveAbility(u, abCode)
    
    call DestroyTimer(GetExpiredTimer())
    set u = null
    call RemoveSavedHandle(unit2Timer, GetHandleId(u), abCode)
    call FlushChildHashtable(timerParams, tid)
endfunction

public function buffUnit takes unit u, integer auraId, integer auraLvl, real time returns nothing
    local timer t = CreateTimer()
    local integer abiLvlNow = GetUnitAbilityLevel(u, auraId)
    local timer oldTimer = null
    
    call BJDebugMsg("buffUnit")
    
    if (abiLvlNow == 0) then
        call BJDebugMsg("UnitAddAbility")
        call UnitAddAbility(u, auraId)
    else
        call BJDebugMsg("destroy old timer")
        set oldTimer = LoadTimerHandle(unit2Timer, GetHandleId(u), auraId)
        call RemoveSavedHandle(unit2Timer, GetHandleId(u), auraId)
        call FlushChildHashtable(timerParams, GetHandleId(oldTimer))
        call DestroyTimer(oldTimer)
    endif
    call SetUnitAbilityLevel(u, auraId, auraLvl)
    
    // save new timer
    call SaveTimerHandle(unit2Timer, GetHandleId(u), auraId, t)
    // run timer
    call SaveUnitHandle(timerParams, GetHandleId(t), KEY_UNIT, u)
    call SaveInteger(timerParams, GetHandleId(t), KEY_ABCODE, auraId)
    call TimerStart(t, time, false, function removeAura)
    
    set oldTimer = null
    set t = null
endfunction

private function init takes nothing returns nothing
    set timerParams = InitHashtable()
    set unit2Timer = InitHashtable()
endfunction

endlibrary