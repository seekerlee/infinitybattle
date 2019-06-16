library Diffculty initializer init requires Table


    globals

        private key MAX_LIFE
        private key MAX_MANA
        private key IAS

        private integer difficulty

        integer maxLvl
    endglobals

    
    struct baseEnhance extends array
        real rate_maxLife
        real rate_maxMana
        real rate_damage
        real rate_armor
        real rate_ACD

        integer value_maxLife
        integer value_maxMana
        real value_IAS
        integer value_damage
        integer value_armor

    endstruct
    // native BlzSetUnitMaxHP                             takes unit whichUnit, integer hp returns nothing
    // native BlzSetUnitMaxMana                           takes unit whichUnit, integer mana returns nothing
    // native BlzSetUnitBaseDamage                        takes unit whichUnit, integer baseDamage, integer weaponIndex returns nothing
    // native BlzSetUnitAttackCooldown                    takes unit whichUnit, real cooldown, integer weaponIndex returns nothing
    // native BlzSetUnitArmor                             takes unit whichUnit, real armorAmount returns nothing
    // native SetUnitMoveSpeed    takes unit whichUnit, real newSpeed returns nothing

    private function initDiffculty takes integer difficulty returns nothing

    endfunction

    private function getEnhance takes integer targetLvl returns baseEnhance

        loop
            exitwhen maxLvl >= targetLvl

            set baseEnhance[maxLvl + 1].rate_maxLife = 1.02 * baseEnhance[maxLvl].rate_maxLife
            set baseEnhance[maxLvl + 1].rate_maxMana = 1.02 * baseEnhance[maxLvl].rate_maxMana
            set baseEnhance[maxLvl + 1].rate_ACD     = 0.99 * baseEnhance[maxLvl].rate_ACD
            set baseEnhance[maxLvl + 1].rate_damage  = 1.02 * baseEnhance[maxLvl].rate_damage
            set baseEnhance[maxLvl + 1].rate_armor   = 1.02 * baseEnhance[maxLvl].rate_armor

            set maxLvl = maxLvl + 1
        endloop

        return baseEnhance[targetLvl]
    endfunction

    function unitApplyEnhance takes unit u, integer lvl returns nothing
        local baseEnhance enh = getEnhance(lvl)
        debug call BJDebugMsg("enhance unit lvl: " + I2S(lvl))
        call BlzSetUnitMaxHP(u, R2I(BlzGetUnitMaxHP(u) * enh.rate_maxLife))
        call BlzSetUnitMaxMana(u, R2I(BlzGetUnitMaxMana(u) * enh.rate_maxMana))
        call BlzSetUnitBaseDamage(u, R2I(BlzGetUnitBaseDamage(u, 0) * enh.rate_damage), 0)
        call BlzSetUnitArmor(u, BlzGetUnitArmor(u) * enh.rate_armor)
        call BlzSetUnitAttackCooldown(u, BlzGetUnitAttackCooldown(u, 0) * enh.rate_ACD, 0)

        call SetUnitState(u, UNIT_STATE_LIFE, BlzGetUnitMaxHP(u))
        call SetUnitState(u, UNIT_STATE_MAX_MANA, BlzGetUnitMaxMana(u))
    endfunction

    private function init takes nothing returns nothing
        set baseEnhance[0].rate_maxLife = 1.0
        set baseEnhance[0].rate_maxMana = 1.0
        set baseEnhance[0].rate_ACD = 1.0
        set baseEnhance[0].rate_damage = 1.0
        set baseEnhance[0].rate_armor = 1.0
        
        set baseEnhance[0].value_maxLife = 0
        set baseEnhance[0].value_maxMana = 0
        set baseEnhance[0].value_IAS = 0.0
        set baseEnhance[0].value_damage = 0
        set baseEnhance[0].value_armor = 0
        
        // set baseEnhance[1].rate_maxLife = 1.0
        // set baseEnhance[1].rate_maxMana = 1.0
        // set baseEnhance[1].rate_ACD = 1.0
        // set baseEnhance[1].rate_damage = 1.0
        // set baseEnhance[1].rate_armor = 1.0
        
        // set baseEnhance[1].value_maxLife = 0
        // set baseEnhance[1].value_maxMana = 0
        // set baseEnhance[1].value_IAS = 0.0
        // set baseEnhance[1].value_damage = 0
        // set baseEnhance[1].value_armor = 0
        
        set maxLvl = 0
    endfunction

endlibrary
