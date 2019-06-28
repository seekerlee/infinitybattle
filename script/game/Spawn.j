library Spawn initializer init requires MapConst, GroupUtils, ListT, Diffculty, UnitDex

    globals
    endglobals

    struct enemyConfig extends array
        readonly integer unitId
        readonly integer count
        readonly integer enhanceLevel
        readonly integer bossLvl // 0 not boss
        readonly real x
        readonly real y
        readonly real targetX
        readonly real targetY

        public method addEnemy takes integer id, integer count, integer enhanceLevel, integer bossLvl returns nothing
            local enemyConfig e = this.push()
            set e.unitId = id
            set e.count = count
            set e.enhanceLevel = enhanceLevel
            set e.bossLvl = bossLvl
        endmethod

        implement ListT // TODO: check destroy
    endstruct

    function SpawnPointAttack takes group creepGroup, player forPlayer, enemyConfig ec, real x, real y, real targetX, real targetY returns nothing
        local enemyConfig enemyc
        local integer i
        local unit u

        set enemyc = ec.first
        loop
            exitwhen enemyc == 0
            set i = 0
            loop
                exitwhen i == enemyc.count
                set u = CreateUnit(forPlayer, enemyc.unitId, x, y, 0.0)
                call GroupAddUnit(creepGroup, u)
                call unitApplyEnhance(u, enemyc.enhanceLevel, enemyc.bossLvl)
                call IssuePointOrder(u, "attack", targetX, targetY)
                set i = i + 1
            endloop
            set enemyc = enemyc.next
        endloop

        set u = null
        call RemoveAllGuardPositions(forPlayer)
    endfunction

    private function init takes nothing returns nothing
        
    endfunction

endlibrary
