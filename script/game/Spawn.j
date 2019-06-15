library Spawn initializer Init requires CreepCamp, GroupUtils


    globals
        private integer banditCampLvl = 0
        private integer UNIT_ID_CAMP = 'ntn2'
    endglobals

    private function isAliveCamp takes nothing returns boolean
            return UNIT_ID_CAMP == GetUnitTypeId(GetFilterUnit()) and IsUnitAliveBJ(GetFilterUnit())
    endfunction

    private function hasCamp takes nothing returns boolean
        call GroupEnumUnitsInArea(ENUM_GROUP, GetRectCenterX(gg_rct_BanditCamp), GetRectCenterY(gg_rct_BanditCamp), 750, Filter(function isAliveCamp))
        return BlzGroupGetSize(ENUM_GROUP) != 0
    endfunction
    // gg_rct_Dragon1
    // gg_rct_Dragon2
    // gg_rct_Dragon3
    // gg_rct_DragonQuanshui
    // gg_rct_DragonMountain
    struct DragonSpawn extends simpleRespawn
        private static method isAlive takes nothing returns boolean
            return IsUnitAliveBJ(GetFilterUnit()) and ( not IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) )
        endmethod
        private method shouldSpawn takes nothing returns boolean
            // call BJDebugMsg("DragonSpawn x y: " + R2S(GetRectCenterX(this.spawnRect)))
            // call GroupEnumUnitsInArea(ENUM_GROUP, GetRectCenterX(this.spawnRect), GetRectCenterY(this.spawnRect), 750., Condition(function thistype.isAlive))
            // call BJDebugMsg("groupsize:" + I2S(BlzGroupGetSize(ENUM_GROUP)))
            return this.countUnitInSpawnArea(750.0, Filter(function thistype.isAlive)) == 0
        endmethod
    endstruct

    struct BanditSpawn extends simpleRespawn
        implement SpawnTarget

        //private static method isBanditPlayer takes nothing returns boolean
        //    return GetPlayerId(GetOwningPlayer(GetFilterUnit())) == PLAYER_ID_BANDIT
        //endmethod
        private method shouldSpawn takes nothing returns boolean
            return this.CountSpawnUnitInTargetRect() < 10 and hasCamp()
        endmethod

        private static method test takes nothing returns nothing
            //call RemoveGuardPosition(GetEnumUnit())
        endmethod
        
        private method afterSpawn takes nothing returns nothing
            //call ForGroup(bj_lastCreatedGroup, function thistype.test)
            //call GroupPointOrderLocBJ(bj_lastCreatedGroup, "attack", GetRectCenter(this.targetRect) )

        endmethod
    endstruct

    struct BanditCampSpawn extends simpleRespawn
    
        private static method isPlayerAliveUnit takes nothing returns boolean
            return IsUnitAliveBJ(GetFilterUnit()) // GetPlayerId(GetOwningPlayer(GetFilterUnit())) < 8 and 
        endmethod

        private method shouldSpawn takes nothing returns boolean
            return this.countUnitInSpawnArea(750.0, Filter(function thistype.isPlayerAliveUnit)) == 0
        endmethod

        private method afterSpawn takes nothing returns nothing
            local unit camp = GetLastCreatedUnit()
            set banditCampLvl = banditCampLvl + 1
            call BJDebugMsg("afterSpawn22")
            call DDebugUnit(camp)
            if (camp != null and GetUnitTypeId(camp) == UNIT_ID_CAMP and banditCampLvl > 0) then
                call BJDebugMsg("enhance camp: " + I2S(powersOf2[banditCampLvl]))
                call BlzSetUnitArmor(camp, BlzGetUnitArmor(camp) * powersOf2[banditCampLvl])
                // call BlzSetUnitBaseDamage(skeleton, 1000, 0)
                call BlzSetUnitMaxHP(camp, BlzGetUnitMaxHP(camp) * powersOf2[banditCampLvl])
                call SetUnitLifeBJ(camp, BlzGetUnitMaxHP(camp))
            endif
            set camp = null
        endmethod
    endstruct

    private function Init takes nothing returns nothing
        local DragonSpawn sp1 = DragonSpawn.create(gg_rct_Dragon1, 3)
        local DragonSpawn sp2 = DragonSpawn.create(gg_rct_Dragon2, 3)
        local DragonSpawn sp3 = DragonSpawn.create(gg_rct_Dragon3, 3)
        local DragonSpawn sp4 = DragonSpawn.create(gg_rct_DragonQuanshui, 3)
        local DragonSpawn sp5 = DragonSpawn.create(gg_rct_DragonMountain, 3)

        local BanditSpawn banditTopLvl1 = BanditSpawn.create(gg_rct_BanditBoss, 10)
        // local BanditSpawn banditTopLvl2 = BanditSpawn.create()
        // local BanditSpawn banditRightLvl1 = BanditSpawn.create()
        // local BanditSpawn banditRightLvl2 = BanditSpawn.create()
        // local BanditSpawn banditBoss = BanditSpawn.create()

        local BanditCampSpawn campSpawn = BanditCampSpawn.create(gg_rct_BanditCamp, 10)

        call sp1.addCreepType('nrwm', 2)
        call sp2.addCreepType('nbwm', 2)
        call sp3.addCreepType('nbzd', 2)
        call sp4.addCreepType('ngrd', 2)
        call sp5.addCreepType('nadr', 2)
        
        // bandit
        call banditTopLvl1.setTargetRect(gg_rct_BanditLvl1Top)
        call banditTopLvl1.setPlayerId(PLAYER_ID_BANDIT)
        call banditTopLvl1.addCreepType('Hmkg', 5)

        call campSpawn.addCreepType('ntn2', 1)
        call campSpawn.setPlayerId(PLAYER_ID_BANDIT)
    endfunction
endlibrary
