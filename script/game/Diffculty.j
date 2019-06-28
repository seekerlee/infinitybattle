library Diffculty initializer init requires Table, Util


    globals

        private key MAX_LIFE
        private key MAX_MANA
        private key IAS

        private integer difficulty

        integer maxLvl

        private constant integer LIFE_BONUS_LVL = 10
        private constant integer MANA_BONUS_LVL = 5
        private constant integer DMG_BONUS_LVL = 4
        private constant integer ARMOR_BONUS_LVL = 2

        private constant integer BASE_HP = 40
        private constant integer BASE_DMG  = 10
    endglobals

    struct baseEnhance extends array
        real rate_maxLife
        real rate_maxMana
        real rate_damage
        real rate_armor
        real rate_ACD
    endstruct

    private function initDiffculty takes integer difficulty returns nothing

    endfunction

    private function getEnhance takes integer targetLvl returns baseEnhance
        loop
            exitwhen maxLvl >= targetLvl

            set baseEnhance[maxLvl + 1].rate_maxLife = 1.03 * baseEnhance[maxLvl].rate_maxLife
            set baseEnhance[maxLvl + 1].rate_maxMana = 1.02 * baseEnhance[maxLvl].rate_maxMana
            set baseEnhance[maxLvl + 1].rate_ACD     = 0.99 * baseEnhance[maxLvl].rate_ACD
            set baseEnhance[maxLvl + 1].rate_damage  = 1.03 * baseEnhance[maxLvl].rate_damage
            set baseEnhance[maxLvl + 1].rate_armor   = 1.03 * baseEnhance[maxLvl].rate_armor

            set maxLvl = maxLvl + 1
        endloop
        return baseEnhance[targetLvl]
    endfunction


    function unitApplyEnhance takes unit u, integer lvl, integer bossLvl returns nothing
        local baseEnhance enh = getEnhance(lvl)
        // call BlzSetUnitMaxHP(u,      R2I(BlzGetUnitMaxHP(u) * enh.rate_maxLife)        + lvl * LIFE_BONUS_LVL)
        // call BlzSetUnitBaseDamage(u, R2I(BlzGetUnitBaseDamage(u, 0) * enh.rate_damage) + lvl * DMG_BONUS_LVL, 0)
        // native SetUnitMoveSpeed    takes unit whichUnit, real newSpeed returns nothing
        local integer life = R2I( (BASE_HP  + SquareRoot(BlzGetUnitMaxHP(u)         - BASE_HP))  * enh.rate_maxLife ) + lvl * LIFE_BONUS_LVL
        if bossLvl == 1 then
            call BlzSetUnitMaxHP(u, life * 10)
        else
            call BlzSetUnitMaxHP(u, life)
        endif
        call BlzSetUnitBaseDamage(u, R2I( (BASE_DMG + SquareRoot(BlzGetUnitBaseDamage(u, 0) - BASE_DMG)) * enh.rate_damage  ) + lvl * DMG_BONUS_LVL, 0)
        call BlzSetUnitBaseDamage(u, R2I( (BASE_DMG + SquareRoot(BlzGetUnitBaseDamage(u, 1) - BASE_DMG)) * enh.rate_damage  ) + lvl * DMG_BONUS_LVL, 1)

        call BlzSetUnitMaxMana(u,    R2I(BlzGetUnitMaxMana(u) * enh.rate_maxMana)   + lvl * MANA_BONUS_LVL)
        call BlzSetUnitArmor(u,      maxReal(BlzGetUnitArmor(u), 1.0) * enh.rate_armor + lvl * ARMOR_BONUS_LVL)
        call BlzSetUnitAttackCooldown(u, BlzGetUnitAttackCooldown(u, 0) * enh.rate_ACD, 0)
        call BlzSetUnitIntegerField(u, UNIT_IF_LEVEL, maxInt(R2I(lvl / 2), 1))


        call SetUnitState(u, UNIT_STATE_LIFE, BlzGetUnitMaxHP(u))
        call SetUnitState(u, UNIT_STATE_MANA, BlzGetUnitMaxMana(u))
    endfunction

    private function init takes nothing returns nothing
        set baseEnhance[0].rate_maxLife = 1.0
        set baseEnhance[0].rate_maxMana = 1.0
        set baseEnhance[0].rate_ACD = 1.0
        set baseEnhance[0].rate_damage = 1.0
        set baseEnhance[0].rate_armor = 1.0
        set maxLvl = 0
    endfunction

endlibrary
