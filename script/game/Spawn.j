library Spawn initializer init requires GroupUtils, ListT

    struct enemyConfig extends array
        readonly integer unitId
        readonly integer count

        public method addEnemy takes integer id, integer count returns nothing
            local enemyConfig e = this.push()
            set e.unitId = id
            set e.count = count
        endmethod

        implement ListT // need destroy element manually
    endstruct

    function test takes nothing returns nothing
        local enemyConfig enemyConfigList = enemyConfig.create()
        local enemyConfig enemyc
        call enemyConfigList.addEnemy(1000, 2000)
        call enemyConfigList.addEnemy(1001, 2001)
        call enemyConfigList.addEnemy(1002, 2002)
        call enemyConfigList.addEnemy(1003, 2003)
        
        debug call BJDebugMsg( enemyConfigList.getAllocatedMemoryAsString() )
        set enemyc = enemyConfigList.first
        loop
            exitwhen enemyc == 0
            call BJDebugMsg(I2S(enemyc.count))
            set enemyc = enemyc.next
        endloop
        call enemyConfigList.destroy()
        debug call BJDebugMsg( enemyConfigList.getAllocatedMemoryAsString() )
    endfunction

    function enhanceUnit takes unit u returns nothing
        call BlzSetUnitMaxHP(u, 1)
        call SetUnitLifePercentBJ(u, 100.0)
    endfunction

    function SpawnPointAttack takes player forPlayer, enemyConfig ec, real x, real y, real targetX, real targetY returns nothing
        local enemyConfig enemyc
        local integer i
        local unit u

        set enemyc = ec.first
        loop
            exitwhen enemyc == 0
            set i = 0
            loop
                exitwhen i == enemyc.count
                // CreateUnit              takes player id, integer unitid, real x, real y, real face returns unit
                set u = CreateUnit(forPlayer, enemyc.unitId, x, y, 0.0)
                call enhanceUnit(u)
                // IssuePointOrder              takes unit whichUnit, string order, real x, real y returns boolean
                call IssuePointOrder(u, "attack", targetX, targetY)
                set i = i + 1
            endloop
            set enemyc = enemyc.next
        endloop

        
        set u = null
    endfunction

    private function init takes nothing returns nothing
        //call test()
    endfunction

endlibrary
