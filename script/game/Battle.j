library Battle requires MapConst, RegisterPlayerUnitEvent, Spawn

    globals
        private trigger tOnBattleEnd
        integer currentEnemyCount
    endglobals

    function registerOnBattleEnd takes code func returns nothing
        call TriggerAddCondition(tOnBattleEnd, Condition(func))
    endfunction

    function createEnemy takes nothing returns nothing
        local enemyConfig enemyConfigList = enemyConfig.create()
        call enemyConfigList.addEnemy('hrif', 20)
        // call enemyConfigList.addEnemy('hpea', 20)
        set currentEnemyCount = SpawnPointAttack(P_DARK, enemyConfigList, GetRectCenterX(RCT_TOPCENTER), GetRectCenterY(RCT_TOPCENTER), 0.0, 0.0)
        call enemyConfigList.destroy()
    endfunction

    function startBattle takes integer wave returns nothing
        call createEnemy()
    endfunction

    private function enemyDeath takes nothing returns boolean
        set currentEnemyCount = currentEnemyCount - 1
        if currentEnemyCount == 0 then
            call TriggerEvaluate(tOnBattleEnd)
        endif
        return false
    endfunction

    function initBattle takes nothing returns nothing
        set tOnBattleEnd = CreateTrigger()
        call RegisterPlayerUnitEvent(P_DARK, EVENT_PLAYER_UNIT_DEATH, function enemyDeath)
        // init_body
    endfunction
endlibrary
