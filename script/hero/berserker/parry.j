library Parry initializer Init requires DamageEngine, SoundTools, BerserkerArmor

    globals
        private Sound pSound0
        private Sound pSound1
        private Sound pSound2
        //
        private constant integer ID_PARRY = 'A00G'
        private constant integer ABLITY_KEEPLIVE = 'A00I'
        private constant integer ID_PARRY_UNIT = 'h002'
        
        private constant integer PARRY_RANGE = 150
        private constant real PARRY_TIME = 0.33
        private constant string PARRY_EFF= "Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl"
    endglobals
        
    private function hideParryUnit takes nothing returns nothing
        call RemoveUnit(GetUnitById(GetTimerData(GetExpiredTimer())))
        call ReleaseTimer(GetExpiredTimer())
    endfunction
    
    private function createParryUnitFor takes unit u, unit target returns nothing
        local unit parry_unit = CreateUnit(GetOwningPlayer(u), ID_PARRY_UNIT, 0.0, 0.0, AngleBetweenPoints(GetUnitLoc(u),GetUnitLoc(target)))
        local timer removeTimer = NewTimerEx(GetUnitId(parry_unit))
        call UnitRemoveAbility( parry_unit, 'Amov' )
        call UnitRemoveAbility( parry_unit, 'Aatk' )
        call SetUnitX(parry_unit, GetLocationX(GetUnitLoc(u)))
        call SetUnitY(parry_unit, GetLocationY(GetUnitLoc(u)))
        call SetUnitColor(parry_unit, PLAYER_COLOR_MAROON)
        if ( berserkerStateOn[GetUnitId(u)] ) then
            call SetUnitVertexColor(parry_unit, 15, 15, 15, 191)
        else
            call SetUnitVertexColor(parry_unit, 127, 127, 127, 191)
        endif
        call SetUnitTimeScale(parry_unit, 3)
        call SetUnitAnimation(parry_unit, "attack")
        
        call TimerStart(removeTimer, PARRY_TIME, true, function hideParryUnit)
        
        set parry_unit = null
        set removeTimer = null
    endfunction
    
    private function Action takes nothing returns boolean
        
        local real damageBack
        local integer luck
        local integer abliLvl
        local integer keepAliveLvl
        local real lifePercent

        if 0 == GetUnitAbilityLevel(udg_DamageEventTarget, ID_PARRY) then
            return false
        endif
        
        set luck = GetRandomInt(0, 99)
        set abliLvl = GetUnitAbilityLevel(udg_DamageEventTarget, ID_PARRY)
        set keepAliveLvl = GetUnitAbilityLevel(udg_DamageEventTarget, ABLITY_KEEPLIVE)
        set lifePercent = GetUnitLifePercent(udg_DamageEventTarget)

        if (lifePercent < 15) then
            set luck = luck - keepAliveLvl * 4 // add more posibility by 4, 8, 12, 16
        elseif (lifePercent < 30) then
            set luck = luck - keepAliveLvl * 2 // add more posibility by 2, 4, 6, 8
        endif
        
        if ( berserkerStateOn[GetUnitId(udg_DamageEventTarget)] ) then
            set luck = luck - 30
        endif
        
        if (abliLvl == 1) and luck > 10 then
            return false
        elseif (abliLvl == 2) and luck > 15 then
            return false
        elseif (abliLvl == 3) and luck > 20 then
            return false
        elseif (abliLvl == 4) and luck > 25 then
            return false
        endif
        
        // 
        set luck = GetRandomInt(0, 2)
        if (luck == 0) then 
            call RunSoundOnUnit(pSound0, udg_DamageEventTarget)
        elseif ( luck == 1) then
            call RunSoundOnUnit(pSound1, udg_DamageEventTarget)
        else 
            call RunSoundOnUnit(pSound2, udg_DamageEventTarget)
        endif
        
        set udg_DamageEventAmount = 0
        call DestroyEffect(AddSpecialEffectTarget( PARRY_EFF , udg_DamageEventTarget, "origin"))
        if (IsUnitInRange(udg_DamageEventTarget, udg_DamageEventSource, PARRY_RANGE)) then
            set damageBack = 2.0 * udg_DamageEventAmount + I2R(GetHeroStr(udg_DamageEventTarget, true))
            call UnitDamageTarget(udg_DamageEventTarget, udg_DamageEventSource, damageBack, true, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_UNKNOWN, null)
            call createParryUnitFor(udg_DamageEventTarget, udg_DamageEventSource)
        endif
        
        return false
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition(t, Condition(function Action))
        
        set t = null
        
        set pSound0 = NewSound("Sound\\Units\\Combat\\MetalLightSliceMetal3.wav", 461, false, true)
        set pSound1 = NewSound("Sound\\Units\\Combat\\MetalMediumSliceMetal2.wav", 614, false, true)
        set pSound2 = NewSound("Sound\\Units\\Combat\\MetalLightSliceMetal1.wav", 375, false, true)
    endfunction

endlibrary