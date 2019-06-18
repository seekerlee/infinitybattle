library Gaizhonggai initializer init requires UnitDex, GroupUtils
    globals
        private constant integer SKELETON_ID = 'u002'
        private constant string BIG_EFF = "Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl"
        group array skeletonGroups
    endglobals

    private function gaiEnhance takes unit skeleton, unit master returns nothing
        local integer gai_lvl = GetUnitAbilityLevel(master, 'A003')
        local integer armorEnhanced
        local integer lifeEnhanced
        local integer damageEnhanced
        if gai_lvl == 0 then
            return
        endif
        // 65% - 200%
        set lifeEnhanced   = R2I( (.5 + 0.15 * gai_lvl) * BlzGetUnitMaxMana(master) + BlzGetUnitMaxHP(skeleton) )
        set damageEnhanced = R2I( (.5 + 0.15 * gai_lvl) * BlzGetUnitBaseDamage(master, 0) + BlzGetUnitBaseDamage(skeleton, 0) )
        set armorEnhanced  = R2I( (.5 + 0.15 * gai_lvl) * BlzGetUnitArmor(master) + BlzGetUnitArmor(skeleton) )

        if GetRandomInt(0, 99) < 15 then
            set lifeEnhanced = lifeEnhanced * 6
            set damageEnhanced = damageEnhanced * 6
            set armorEnhanced = armorEnhanced * 6
            call SetUnitScale(skeleton, 1.5, 1.5, 2)
            call SetUnitVertexColor(skeleton, 255, 84, 84, 255)
            call DestroyEffect( AddSpecialEffectTarget(BIG_EFF, skeleton, "origin") )
        endif
        call BlzSetUnitArmor(skeleton, armorEnhanced)
        call BlzSetUnitBaseDamage(skeleton, damageEnhanced, 0)
        call BlzSetUnitMaxHP(skeleton, lifeEnhanced)
        call SetUnitState(skeleton, UNIT_STATE_LIFE, BlzGetUnitMaxHP(skeleton))
    endfunction

    private function Actions takes nothing returns boolean
        // check unit type
        local unit sk = GetSummonedUnit()
        local unit master = GetSummoningUnit()
        local group skeletonG
        if GetUnitTypeId(sk) == SKELETON_ID then
            
            if skeletonGroups[GetUnitId(master)] == null then
                set skeletonGroups[GetUnitId(master)] = NewGroup()
            endif

            set skeletonG = skeletonGroups[GetUnitId(master)]
            
            call gaiEnhance(sk, master)
            call GroupRefresh(skeletonG)
            call GroupAddUnit(skeletonG, sk)

            set skeletonG = null
        endif
        set master = null
        set sk = null
        return false
    endfunction

    private function init takes nothing returns nothing
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SUMMON, function Actions)
    endfunction
endlibrary
