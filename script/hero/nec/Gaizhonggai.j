library Gaizhonggai initializer init requires UnitMaxState

    private struct minionsk extends minionBase
        implement defaultBehavior
        implement gotoTargetBehavior
    endstruct


    private function ggg_gaizhonggai_enhance takes unit skeleton, unit master returns nothing
        local integer gai_lvl = GetUnitAbilityLevelSwapped('A003', master)
        local integer luck_armor = GetRandomInt(0, 99)
        local integer luck_life = GetRandomInt(0, 99)
        local integer luck_damage = GetRandomInt(0, 99)
        local integer luck_lifesuck = GetRandomInt(0, 99)
        local real life_state = GetUnitState(skeleton, UNIT_STATE_MAX_LIFE)
        
        // call BlzSetUnitArmor(skeleton, 100)
        // call BlzSetUnitBaseDamage(skeleton, 1000, 0)
        // call BlzSetUnitMaxHP(skeleton, 99999)
        if (gai_lvl == 1) then
            if (luck_armor > 90) then
                call SetUnitBonus(skeleton, BONUS_ARMOR, R2I(luck_armor * 0.1))
            endif
            if (luck_life > 90) then
                call SetUnitMaxState(skeleton, UNIT_STATE_MAX_LIFE, (life_state * 1.2))
            endif
            if (luck_damage > 90) then
                call SetUnitBonus(skeleton, BONUS_DAMAGE, R2I(luck_damage * 0.1))
            endif
            
        elseif  (gai_lvl == 2) then
            if (luck_armor > 80) then
                call SetUnitBonus(skeleton, BONUS_ARMOR, R2I(luck_armor * 0.2))
            endif
            if (luck_life > 80) then
                call SetUnitMaxState(skeleton, UNIT_STATE_MAX_LIFE, (life_state * 1.5))
            endif
            if (luck_damage > 80) then
                call SetUnitBonus(skeleton, BONUS_DAMAGE, R2I(luck_damage * 0.2))
            endif
        elseif  (gai_lvl == 3) then
            if (luck_armor > 70) then
                call SetUnitBonus(skeleton, BONUS_ARMOR, R2I(luck_armor * 0.3))
            endif
            if (luck_life > 70) then
                call SetUnitMaxState(skeleton, UNIT_STATE_MAX_LIFE, (life_state * 2.7))
            endif
            if (luck_damage > 70) then
                call SetUnitBonus(skeleton, BONUS_DAMAGE, R2I(luck_damage * 0.3))
            endif
        elseif  (gai_lvl == 4) then
            if (luck_armor > 60) then
                call SetUnitBonus(skeleton, BONUS_ARMOR, R2I(luck_armor * 0.5))
            endif
            if (luck_life > 60) then
                call SetUnitMaxState(skeleton, UNIT_STATE_MAX_LIFE, (life_state * 4.0))
            endif
            if (luck_damage > 60) then
                call SetUnitBonus(skeleton, BONUS_DAMAGE, R2I(luck_damage * 0.5))
            endif
            if (luck_armor > 60) and (luck_life > 60) and (luck_damage > 60) then
                call SetUnitVertexColor(skeleton, 255, 100, 100, 255)
            endif
        endif
    endfunction


    private function Trig_skeletonSummonnedActions takes nothing returns nothing
        // check unit type
        local unit sk = GetSummonedUnit()
        local unit master = GetSummoningUnit()
        local player p = GetOwningPlayer(sk)
        local integer playerId = GetPlayerId(p)
        
        local group skeletonG = LoadGroupHandle(ggg_SkeletonGroupForPlayer, playerId, ggg_CATEGORY_SKELETON)
        
        call ggg_gaizhonggai_enhance(sk, master)
        call GroupAddUnit(skeletonG, sk)
        
        call minionsk.create(master, sk, 5, 100)
        
        set sk = null
        set master = null
        set p = null
        set skeletonG = null
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_SUMMON )
        call TriggerAddAction(t, function Trig_skeletonSummonnedActions)
    endfunction
endlibrary
