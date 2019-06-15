library Battle requires TimerUtils, MapConst, RegisterPlayerUnitEvent

    globals
        private trigger tOnBattleEnd
        integer currentEnemyCount
    endglobals
    
    function registerOnEnemyKilled takes code func returns nothing

    endfunction

    function registerOnBattleEnd takes code func returns nothing
        call TriggerAddCondition(tOnBattleEnd, Condition(func))
    endfunction

    function createEnemy takes nothing returns nothing
        local enemyConfig enemyConfigList = enemyConfig.create()
        call enemyConfigList.addEnemy('hfoo', 5)
        // call enemyConfigList.addEnemy('hpea', 20)
        // SpawnPointAttack takes player forPlayer, enemyConfig ec, real x, real y, real targetX, real targetY returns nothing
        call SpawnPointAttack(P_DARK, enemyConfigList, GetRectCenterX(RCT_TOPCENTER), GetRectCenterY(RCT_TOPCENTER), 0.0, 0.0)
        call enemyConfigList.destroy()

        set currentEnemyCount = 5
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
