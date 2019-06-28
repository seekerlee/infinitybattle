library Battle requires MapConst, RegisterPlayerUnitEvent, Spawn, GroupUtils

    globals
        private trigger tOnBattleEnd
        group currentWaveGroup

    endglobals

    function registerOnBattleEnd takes code func returns nothing
        call TriggerAddCondition(tOnBattleEnd, Condition(func))
    endfunction

    function createEnemy takes nothing returns nothing
        local enemyConfig enemyConfigList = enemyConfig.create()
        call enemyConfigList.addEnemy(getRandomIdOfType(typeWeak), 10, currentWave, 0)
        call enemyConfigList.addEnemy(getRandomIdOfType(typeWeak), 10, currentWave, 0)
        if currentWave > 9 then
            call enemyConfigList.addEnemy(getRandomIdOfType(typeNormal), 2, currentWave + 5, 0)
        endif
        if currentWave > 14 then
            call enemyConfigList.addEnemy(getRandomIdOfType(typeStrong), 1, currentWave + 20, 1)
        endif
        
        call SpawnPointAttack(currentWaveGroup, P_DARK, enemyConfigList, GetRectCenterX(RCT_TOPCENTER), GetRectCenterY(RCT_TOPCENTER), 0.0, 0.0)
        call SpawnPointAttack(currentWaveGroup, P_DARK, enemyConfigList, GetRectCenterX(RCT_CENTERLEFT), GetRectCenterY(RCT_CENTERLEFT), 0.0, 0.0)
        call SpawnPointAttack(currentWaveGroup, P_DARK, enemyConfigList, GetRectCenterX(RCT_CENTERRIGHT), GetRectCenterY(RCT_CENTERRIGHT), 0.0, 0.0)
        call SpawnPointAttack(currentWaveGroup, P_DARK, enemyConfigList, GetRectCenterX(RCT_BOTTOMCENTER), GetRectCenterY(RCT_BOTTOMCENTER), 0.0, 0.0)
        call enemyConfigList.destroy()
    endfunction

    function startBattle takes integer wave returns nothing
        call createEnemy()
    endfunction

    private function enemyDeath takes nothing returns boolean
        if IsUnitInGroup(GetDyingUnit(), currentWaveGroup) then
            call GroupRemoveUnit(currentWaveGroup, GetDyingUnit())
            if BlzGroupGetSize(currentWaveGroup) == 0 then
                call GroupClear(currentWaveGroup)
                call TriggerEvaluate(tOnBattleEnd)
            endif
        endif
        if IsUnitType(GetDyingUnit(), UNIT_TYPE_HERO) then
            call RemoveUnit(GetDyingUnit())
        endif
        return false
    endfunction

    private function onStopMoving takes nothing returns nothing
        if IsUnitInGroup(GetUnitById(moveEventUnitId), currentWaveGroup) then
            call IssuePointOrder(GetUnitById(moveEventUnitId), "attack", 0.0, 0.0)
        endif
    endfunction

    function initBattle takes nothing returns nothing
        local trigger t2 = CreateTrigger(  )
        call TriggerRegisterVariableEvent( t2, "unitMovingEvent", EQUAL, 2.00 )
        call TriggerAddAction( t2, function onStopMoving )

        set currentWaveGroup = CreateGroup()
        set tOnBattleEnd = CreateTrigger()
        call RegisterPlayerUnitEvent(P_DARK, EVENT_PLAYER_UNIT_DEATH, function enemyDeath)

    endfunction
endlibrary
