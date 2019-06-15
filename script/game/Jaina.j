library Jaina requires Table, WorldBounds, MapConst
    globals
        private integer ID_JAINA = 'Jain'
        private trigger T_JAINA_DIE
    endglobals
    
    private function OnJainaDie takes nothing returns boolean
         call TriggerEvaluate(T_JAINA_DIE)
         return false
    endfunction

    function initJaina takes nothing returns nothing
        local trigger tDie = CreateTrigger()
        // create jaina in center
        set U_JAINA = CreateUnit(P_JAINA, ID_JAINA, WorldBounds.centerX, WorldBounds.centerY, 90.0)
        set T_JAINA_DIE = CreateTrigger()
        call TriggerRegisterUnitEvent(tDie, U_JAINA, EVENT_UNIT_DEATH)
        call TriggerAddCondition(tDie, Condition(function OnJainaDie))
        set tDie = null
    endfunction

    function registerOnJainaDie takes code func returns nothing
        call TriggerAddCondition(T_JAINA_DIE, Condition(func))
    endfunction

endlibrary
