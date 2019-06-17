library DragonBlade initializer Init requires RegisterPlayerUnitEvent, BonusMod, xecast

    globals
        private integer array soulCount
        private integer array attackBounus
        private constant integer ABLITY_DB = 'A00F'
        private constant integer ABLITY_SLOW = 'A00O'
        private constant integer ATTACKBOUNSPERSOUL = 10
    endglobals
    
    private function addBuf takes unit u returns nothing
        local xecast xc = xecast.createA()
        set xc.abilityid    = ABLITY_SLOW
        set xc.orderstring  = "slow"
        call xc.castOnTarget(u)
    endfunction
    
    private function AdjustBladeBuf takes unit killer returns nothing
        local integer bladeLvl = GetUnitAbilityLevel(killer, ABLITY_DB)
        local integer soul = soulCount[GetUnitUserData(killer)]
        local integer oldBonnus = attackBounus[GetUnitUserData(killer)]
        local integer newBonus = soul * ATTACKBOUNSPERSOUL
        if (oldBonnus != newBonus) then
            call addBuf(killer)
        endif
        call AddUnitBonus(killer, BONUS_DAMAGE, newBonus - oldBonnus)
        set attackBounus[GetUnitUserData(killer)] = newBonus
    endfunction
    
    private function ActionUnitDeath takes nothing returns boolean
    
        local unit killer = GetKillingUnit()
        local unit deadU = GetDyingUnit()
        local integer bladeLvl = GetUnitAbilityLevel(killer, ABLITY_DB)
        local integer bladeLvl_dead = GetUnitAbilityLevel(deadU, ABLITY_DB)
        local integer UIndex = GetUnitUserData(killer)
        local integer UIndex_dead = GetUnitUserData(deadU)
        local integer maxSoul = 10 * bladeLvl
        //if (bladeLvl == 1) then
        //    set maxSoul = 10
        //elseif (bladeLvl == 2) then
        //elseif (bladeLvl == 3) then
        //elseif (bladeLvl == 4) then
        //endif
        local integer currentSoul = soulCount[UIndex]
        if (bladeLvl > 0) then // if blade kills
            if (IsUnitType(deadU, UNIT_TYPE_MECHANICAL) or (not IsUnitEnemy(deadU, GetOwningPlayer(killer))) ) then
                return false
            endif
            if (currentSoul < maxSoul) then
                set soulCount[UIndex] = soulCount[UIndex] + 1
            endif
            call AdjustBladeBuf(killer)
        endif
        if (bladeLvl_dead > 0) then // if blade is killed
            set soulCount[UIndex_dead] = 0
            call AdjustBladeBuf(deadU)
        endif
        return false
    endfunction
    
    private function Action takes nothing returns boolean
        local integer bladeLvl
        if GetLearnedSkill() != ABLITY_DB then
            return false
        endif
        set bladeLvl = GetUnitAbilityLevel(GetTriggerUnit(), ABLITY_DB)
        if (bladeLvl > 1) then
            call AdjustBladeBuf(GetTriggerUnit())
        endif
        if (bladeLvl == 1) then
            call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_DEATH, function ActionUnitDeath)
        endif
        return false
    endfunction
    
    private function Init takes nothing returns nothing
        
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_HERO_SKILL, function Action)
    endfunction

endlibrary