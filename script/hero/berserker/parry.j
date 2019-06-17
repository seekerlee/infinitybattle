library Parry initializer Init requires DamageEngine

    globals
        private constant integer ID_PARRY = 'A00G'
        private constant integer ABLITY_KEEPLIVE = 'A00I'
        private constant integer ID_PARRY_UNIT = 'h002'
        private constant integer KEY_UNIT = 0
        private constant integer PARRY_RANGE = 150
        private constant real PARRY_TIME = 0.33
        private constant string PARRY_EFF= "Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl"
    endglobals
        
    private function hideParryUnit takes nothing returns nothing
        local integer tid = GetHandleId(GetExpiredTimer())
        local unit pu = LoadUnitHandle(timerParams, tid, KEY_UNIT)
        
        call FlushChildHashtable(timerParams, tid)
        call RemoveUnit(pu)
        call DestroyTimer(GetExpiredTimer())
                
        set pu = null
    endfunction
        //ShowUnit(whichUnit, false)
    private function createParryUnitFor takes unit u, unit target returns nothing
    
        local timer removeTimer = CreateTimer()
        
        local unit parry_unit = CreateUnit(GetOwningPlayer(u), ID_PARRY_UNIT, 0.0, 0.0, AngleBetweenPoints(GetUnitLoc(u),GetUnitLoc(target)))
        call UnitRemoveAbility( parry_unit, 'Amov' )
        call UnitRemoveAbility( parry_unit, 'Aatk' )
        call SetUnitX(parry_unit, GetLocationX(GetUnitLoc(u)))
        call SetUnitY(parry_unit, GetLocationY(GetUnitLoc(u)))
        call SetUnitColor(parry_unit, ConvertPlayerColor(12))
        if ( g_BerserStateOn ) then
            call SetUnitVertexColor(parry_unit, 15, 15, 15, 191)
        else
            call SetUnitVertexColor(parry_unit, 127, 127, 127, 191)
        endif
        call SetUnitTimeScale(parry_unit, 3)
        call SetUnitAnimation(parry_unit, "attack")
        
        call SaveUnitHandle(timerParams, GetHandleId(removeTimer), KEY_UNIT, parry_unit)
        call TimerStart(removeTimer, PARRY_TIME, true, function hideParryUnit)
        
        set parry_unit = null
        set removeTimer = null
    endfunction
    
    private function Requirement takes nothing returns boolean
        return 0 < GetUnitAbilityLevel(udg_DamageEventTarget, ID_PARRY)
    endfunction
    
    private function Action takes nothing returns nothing
        local real dmgPrevented = udg_DamageEventAmount
        local integer str = GetHeroStr(udg_DamageEventTarget, true)
        local real damageBack = 2.0 * dmgPrevented + I2R(str)
        local integer luck = GetRandomInt(0, 99)
        local integer abliLvl = GetUnitAbilityLevel(udg_DamageEventTarget, ID_PARRY)
        local integer keepAliveLvl = GetUnitAbilityLevel(udg_DamageEventTarget, ABLITY_KEEPLIVE)
        local real lifePercent = GetUnitLifePercent(udg_DamageEventTarget)
        
        if (lifePercent < 15) then
            set luck = luck - keepAliveLvl * 4 // add more posibility by 4, 8, 12, 16
        elseif (lifePercent < 30) then
            set luck = luck - keepAliveLvl * 2 // add more posibility by 2, 4, 6, 8
        endif
        
        if ( g_BerserStateOn ) then
            set luck = luck - 30
        endif
        
        if (abliLvl == 1) and luck > 10 then
            return
        elseif (abliLvl == 2) and luck > 15 then
            return
        elseif (abliLvl == 3) and luck > 20 then
            return
        elseif (abliLvl == 4) and luck > 25 then
            return 
        endif
        
        // 
        set luck = GetRandomInt(0, 2)
        if (luck == 0) then 
            call StopSound(gg_snd_MetalLightSliceMetal1, false, false)
            call PlaySoundOnUnitBJ( gg_snd_MetalLightSliceMetal1, 100, udg_DamageEventTarget )
        elseif ( luck == 1) then
            call StopSound(gg_snd_MetalMediumSliceMetal2, false, false)
            call PlaySoundOnUnitBJ( gg_snd_MetalMediumSliceMetal2, 100, udg_DamageEventTarget )
        else 
            call StopSound(gg_snd_MetalLightSliceMetal3, false, false)
            call PlaySoundOnUnitBJ( gg_snd_MetalLightSliceMetal3, 100, udg_DamageEventTarget )
        endif
        
        set udg_DamageEventAmount = 0
        call DestroyEffect(AddSpecialEffectTarget( PARRY_EFF , udg_DamageEventTarget, "origin"))
        if (IsUnitInRange(udg_DamageEventTarget, udg_DamageEventSource, PARRY_RANGE)) then
            call UnitDamageTarget(udg_DamageEventTarget, udg_DamageEventSource, damageBack, true, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_UNKNOWN, null)
            call createParryUnitFor(udg_DamageEventTarget, udg_DamageEventSource)
        endif
        
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        call TriggerAddCondition(t, Condition(function Requirement))
        call TriggerAddAction(t, function Action)
        
        set t = null
    endfunction

endlibrary