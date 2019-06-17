library Spawn initializer init requires MapConst, GroupUtils, ListT, Diffculty

    struct enemyConfig extends array
        readonly integer unitId
        readonly integer count
        readonly real x
        readonly real y
        readonly real targetX
        readonly real targetY

        public method addEnemy takes integer id, integer count returns nothing
            local enemyConfig e = this.push()
            set e.unitId = id
            set e.count = count
        endmethod

        implement ListT // TODO: check destroy
    endstruct

    function SpawnPointAttack takes player forPlayer, enemyConfig ec, real x, real y, real targetX, real targetY returns integer
        local enemyConfig enemyc
        local integer i
        local unit u
        local integer spawnCount = 0

        set enemyc = ec.first
        loop
            exitwhen enemyc == 0
            set i = 0
            loop
                exitwhen i == enemyc.count
                set u = CreateUnit(forPlayer, enemyc.unitId, x, y, 0.0)
                //call RemoveGuardPosition(u)
                call unitApplyEnhance(u, currentWave )
                set spawnCount = spawnCount + 1
                call IssuePointOrder(u, "attack", targetX, targetY)
                set i = i + 1
            endloop
            set enemyc = enemyc.next
        endloop

        set u = null
        call RemoveAllGuardPositions(forPlayer)
        return spawnCount
    endfunction

    private function init takes nothing returns nothing
        //call test()
    endfunction

endlibrary
