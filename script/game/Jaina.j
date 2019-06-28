library Jaina requires Table, WorldBounds, MapConst
    globals
        private integer ID_JAINA = 'Jain'
        private trigger T_JAINA_DIE
        private real damageTook = 0.0
        private integer damageTookCount = 0
    endglobals
    
    private function OnJainaDie takes nothing returns boolean
         call TriggerEvaluate(T_JAINA_DIE)
         return false
    endfunction

    function initJaina2 takes nothing returns nothing
        call UnitRemoveAbility(U_JAINA, 'Ane2') // 选择单位技能

        // call UnitAddAbility(U_JAINA, 'Apit') // 购物
        // call UnitAddAbility(U_JAINA, 'Asid') // 购物
        // call UnitAddAbility(U_JAINA, 'Aneu') // 购物
        // call UnitAddAbility(U_JAINA, 'Asud') // 购物

        call UnitAddAbility(U_JAINA, 'AHds')
        call UnitAddAbility(U_JAINA, 'A019') // 圣光
        //call BlzUnitHideAbility(U_JAINA, 'AHds', true)
        //call BlzUnitHideAbility(U_JAINA, 'AHhb', true)
        
        // call AddItemToStock(U_JAINA, 'ajen', 1, 1)
    endfunction

    private function Action takes nothing returns boolean
        if udg_DamageEventTarget == U_JAINA then
            set damageTook = damageTook + udg_DamageEventAmount
            set damageTookCount = damageTookCount + 1
        endif
        return false
    endfunction

    function ClearDamage takes nothing returns nothing
        set damageTook = 0
        set damageTookCount = 0
    endfunction

    function GetDamage takes nothing returns real
        return damageTook
    endfunction

    function GetDamageCount takes nothing returns integer
        return damageTookCount
    endfunction

    function initJaina takes nothing returns nothing
        local trigger tDie = CreateTrigger()
        local trigger t = CreateTrigger()
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition(t, Condition(function Action))
        
        set t = null
        // create jaina in center
        set U_JAINA = CreateUnit(P_JAINA, ID_JAINA, WorldBounds.centerX, WorldBounds.centerY, 270.0)
        call UnitRemoveAbility( U_JAINA, 'Amov' )
        call UnitRemoveAbility(U_JAINA, 'Aatk')
        
        call UnitAddAbility(U_JAINA, 'A015')
        call UnitAddAbility(U_JAINA, 'A016')

        set T_JAINA_DIE = CreateTrigger()
        call TriggerRegisterUnitEvent(tDie, U_JAINA, EVENT_UNIT_DEATH)
        call TriggerAddCondition(tDie, Condition(function OnJainaDie))
        set tDie = null
    endfunction

    function registerOnJainaDie takes code func returns nothing
        call TriggerAddCondition(T_JAINA_DIE, Condition(func))
    endfunction

endlibrary
