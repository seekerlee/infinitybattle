//===========================================================================
// Damage Engine lets you detect, amplify, block or nullify damage. It even
// lets you detect if the damage was physical or from a spell. Just reference
// DamageEventAmount/Source/Target or the boolean IsDamageSpell, to get the
// necessary damage event data.
//
// - Detect damage (after it's been dealt to the unit): use the event "DamageEvent Equal to 1.00"
// - To change damage before it's dealt: use the event "DamageModifierEvent Equal to 1.00"
// - Detect spell damage: use the condition "IsDamageSpell Equal to True"
// - Detect zero-damage: use the event "DamageEvent Equal to 2.00" (an AfterDamageEvent will not fire for this)
//
// You can specify the DamageEventType before dealing triggered damage:
// - Set NextDamageType = DamageTypeWhatever
// - Unit - Cause...
//
// You can modify the DamageEventAmount and the DamageEventType from a "DamageModifierEvent Equal to 1.00" trigger.
// - If the amount is modified to negative, it will count as a heal.
// - If the amount is set to 0, no damage will be dealt.
//
// If you need to reference the pre-armor "pure" damage amount, use "DamageEventPureAmt"
// If you need to reference the original in-game damage, use the variable "DamageEventPrevAmt".
//
//===========================================================================
library DamageEngine initializer Init

globals
    private boolean started = false
    private boolean paused = false
    private integer recursion = -1
    private boolean recursive = false
    private boolean clearable = false
    private boolean purge = false
    private code cleaner = null
    private timer ticker = CreateTimer()
    private trigger trig = CreateTrigger()
    private trigger otrg = CreateTrigger()
    
    private real previousValue = 0.00       //Added to track the original pure damage amount of Spirit Link
    private integer previousType = 0        //Track the type
    private boolean previousCode = false    //Was it caused by a trigger/script?
    
    private unit array lastSource    
    private unit array lastTarget    
    private real array lastAmount    
    private attacktype array lastAttackT    
    private damagetype array lastDamageT    
    private weapontype array lastWeaponT    
    private trigger array lastTrig    
    private integer array lastType    
endglobals

//GUI Vars:
/*
    trigger udg_DamageEventTrigger      //Different functionality from before in 5.1
    
    boolean udg_DamageEventOverride
    boolean udg_NextDamageType
    boolean udg_DamageEventType
    boolean udg_IsDamageCode            //New in 5.1 as per request from chopinski
    boolean udg_IsDamageSpell
    boolean udg_IsDamageMelee           //New in 5.0
    boolean udg_IsDamageRanged          //New in 5.0
    
    unit udg_DamageEventSource
    unit udg_DamageEventTarget
    
    real    udg_AOEDamageEvent
    integer udg_DamageEventAOE
    group   udg_DamageEventAOEGroup
    unit    udg_AOEDamageSource         //New in 5.0
    integer udg_DamageEventLevel
    unit    udg_EnhancedDamageTarget
    
    real udg_DamageEvent
    real udg_DamageModifierEvent
    real udg_LethalDamageEvent          //New in 5.0
    
    real udg_DamageEventAmount
    real udg_DamageEventPrevAmt
    real udg_LethalDamageHP             //New in 5.0
    
    integer udg_DamageEventAttackT      //New in 5.0
    integer udg_DamageEventDamageT      //New in 5.0
    integer udg_DamageEventWeaponT      //New in 5.0
*/

private function Error takes nothing returns nothing
    local string s = "WARNING: Recursion error when dealing damage! Prior to dealing damage from within a DamageEvent response trigger, do this:\n"
    set s = s + "Set DamageEventTrigger = (This Trigger)\n"
    set s = s + "Unit - Cause <Source> to damage <Target>...\n\n"
    set s = s + "Alternatively, just use the UNKNOWN damage type. It will skip recursive damage on its own without needing the \"Set\" line:/n"
    set s = s + "Unit - Cause <Source> to damage <Target>, dealing <Amount> damage of attack type <Attack Type> and damage type Unknown"
    
    call ClearTextMessages()
    call DisplayTimedTextToPlayer(GetLocalPlayer(), 0.00, 0.00, 999.00, s)
endfunction

private function ClearDamageEvent takes nothing returns nothing
    if not IsTriggerEnabled(trig) then
        call EnableTrigger(trig)
    endif
    if clearable then
        set clearable = false
        if recursion > -1 and not purge then
            set purge = true
            call ForForce(bj_FORCE_PLAYER[0], cleaner)
            set purge = false
            set recursive = false
        endif
    endif
endfunction

private function OnAOEEnd takes nothing returns nothing
    if udg_DamageEventAOE > 1 then
        set udg_AOEDamageEvent      = 0.00
        set udg_AOEDamageEvent      = 1.00
        set udg_DamageEventAOE      = 1
    endif
    set udg_DamageEventLevel        = 1
    set udg_EnhancedDamageTarget    = null
    set udg_AOEDamageSource         = null
    call GroupClear(udg_DamageEventAOEGroup)
endfunction
    
private function OnExpire takes nothing returns nothing
    set started = false //The timer has expired. Flag off to allow it to be restarted when needed.
    
    call ClearDamageEvent() //Check for any lingering damage
    
    call OnAOEEnd() //Reset things so they don't perpetuate for AoE/Level target detection
endfunction

private function SetVars takes unit src, unit tgt, real amt, attacktype at, damagetype dt, weapontype wt, integer ph returns boolean
    local integer i                     = recursion + 1
    local boolean rec                   = recursive
    
    call ClearDamageEvent()
    
    if ph < 2 and udg_NextDamageType == 0 and (udg_DamageEventTrigger != null or rec) then
        set udg_NextDamageType          = udg_DamageTypeCode
    endif
    if rec and ph == 1 then
        set recursion = i
        if i < 16 then  //when 16 events are run recursively from one damage instance, it's a safe bet that something has gone wrong.
            //If "purge" is True and this is running, the damage is trying to fire off of an already-recursive function and didn't use the safety trigger.
            //This is pretty much guaranteed to be unwanted behavior.
            set lastAmount[i]           = amt
            if amt != 0.00 then
                //Store recursive damage into a queue from index i (0-15)
                //This damage will be fired after the current damage instance has wrapped up its events.
                //This damage can only be caused by triggers.
                set lastSource[i]       = src
                set lastTarget[i]       = tgt
                set lastAttackT[i]      = at
                set lastDamageT[i]      = dt
                set lastWeaponT[i]      = wt
                
                if udg_NextDamageType != 0 then
                    set lastTrig[i]     = udg_DamageEventTrigger
                    set lastType[i]     = udg_NextDamageType
                endif
            endif
        else
            //Delete or comment-out the next lines to disable the in-game recursion crash warnings
            call Error()
        endif
        set udg_NextDamageType          = 0
        set udg_DamageEventTrigger      = null
        return false
    endif
    if ph == 1 then
        //Added 25 July 2017 to detect AOE damage or multiple single-target damage
        if started then
            if src != udg_AOEDamageSource then //Source has damaged more than once
                
                call OnAOEEnd() //New damage source - unflag everything
                set udg_AOEDamageSource = src
            elseif tgt == udg_EnhancedDamageTarget then
                set udg_DamageEventLevel= udg_DamageEventLevel + 1  //The number of times the same unit was hit.
            elseif not IsUnitInGroup(tgt, udg_DamageEventAOEGroup) then
                set udg_DamageEventAOE  = udg_DamageEventAOE + 1    //Multiple targets hit by this source - flag as AOE
            endif
            if (dt == DAMAGE_TYPE_SPIRIT_LINK and udg_DamageEventAOE + udg_DamageEventLevel == 3) or dt == DAMAGE_TYPE_DEFENSIVE or dt == DAMAGE_TYPE_PLANT then
                set previousValue       = udg_DamageEventPrevAmt    //Store the actual pre-armor value.
                set previousType        = udg_DamageEventType       //also store the damage type.
                set previousCode        = udg_IsDamageCode          //store this as well.
            endif
        else
            set started                 = true
            set udg_AOEDamageSource     = src
            set udg_EnhancedDamageTarget= tgt
            call TimerStart(ticker, 0.00, false, function OnExpire)
        endif
        call GroupAddUnit(udg_DamageEventAOEGroup, tgt)
    endif
    if ph == 2 then
        set udg_DamageEventPrevAmt      = previousValue
        set udg_DamageEventType         = previousType
        set udg_IsDamageCode            = previousCode
    else
        set udg_DamageEventType         = udg_NextDamageType
        if udg_NextDamageType != 0 then
            set udg_DamageEventType     = udg_NextDamageType
            set udg_NextDamageType      = 0
            set udg_IsDamageCode        = true //New in 5.1 - requested by chopinski to allow user to detect Code damage
            
            set udg_DamageEventTrigger  = null
        endif
        set udg_DamageEventOverride     = dt == null or amt == 0.00 or udg_DamageEventType*udg_DamageEventType == 4 //Got rid of NextDamageOverride in 5.1 for simplicity
        set udg_DamageEventPrevAmt      = amt
    endif
    set udg_DamageEventSource           = src    
    set udg_DamageEventTarget           = tgt        
    set udg_DamageEventAmount           = amt
    set udg_DamageEventAttackT          = GetHandleId(at)
    set udg_DamageEventDamageT          = GetHandleId(dt)
    set udg_DamageEventWeaponT          = GetHandleId(wt)
    
    //Set Melee and Ranged detection.
    set udg_IsDamageMelee               = false
    set udg_IsDamageRanged              = false
    set udg_IsDamageSpell               = at == null //In Patch 1.31, one can just check the attack type to find out if it's a spell.
    
    if dt == DAMAGE_TYPE_NORMAL and not udg_IsDamageSpell and not udg_IsDamageCode then //This damage type is the only one that can get reduced by armor.
        set udg_IsDamageMelee           = IsUnitType(src, UNIT_TYPE_MELEE_ATTACKER)
        set udg_IsDamageRanged          = IsUnitType(src, UNIT_TYPE_RANGED_ATTACKER)
        if udg_IsDamageMelee and udg_IsDamageRanged then
            set udg_IsDamageMelee       = wt != null                // Melee units play a sound when damaging
            set udg_IsDamageRanged      = not udg_IsDamageMelee     // In the case where a unit is both ranged and melee, the ranged attack plays no sound.
        endif                                                   // The Huntress has a melee sound for her ranged projectile, however it is only an issue
    endif                                                       //if she also had a melee attack, because by default she is only UNIT_TYPE_RANGED_ATTACKER.
    
    if ph < 2 and not udg_DamageEventOverride then
        set recursive = true
        call DisableTrigger(otrg)
        //Ignores event on various debuffs like Faerie Fire - alternatively,
        //the user can exploit UNKNOWN damage type to avoid damage detection.

        set udg_DamageModifierEvent = 0.00
        set udg_DamageModifierEvent = 1.00  //I recommend using this for changing damage types or for when you need to do things that should override subsequent damage modification.
        
        set udg_DamageEventOverride = udg_DamageEventOverride or udg_DamageEventType*udg_DamageEventType == 4
        if not udg_DamageEventOverride then
            set udg_DamageModifierEvent = 2.00  //This should involve damage calculation based on multiplication/percentages.
            set udg_DamageModifierEvent = 3.00  //This should just be addition or subtraction at this point.
        endif
        call EnableTrigger(otrg)
        set recursive = false
    endif
    return true
endfunction

private function OnPreDamage takes nothing returns boolean
    
    //Load the event responses into the Pre-Damage Modification trigger.
    if SetVars(GetEventDamageSource(), BlzGetEventDamageTarget(), GetEventDamage(), BlzGetEventAttackType(), BlzGetEventDamageType(), BlzGetEventWeaponType(), 1) then
        
        //All events have run and the damage amount is finalized.
        call BlzSetEventAttackType(ConvertAttackType(udg_DamageEventAttackT))
        call BlzSetEventDamageType(ConvertDamageType(udg_DamageEventDamageT))
        call BlzSetEventWeaponType(ConvertWeaponType(udg_DamageEventWeaponT))
        if udg_DamageEventAmount > 0.00 then
            call BlzSetEventDamage(udg_DamageEventAmount)
            return false
            //Healing causes issues here as the negative damage is not always counted as a heal (for example with physical damage).
            //I therefore run a separate heal process from the "After Damage" moment which works for all circumstances. 
        endif
    endif
    call BlzSetEventDamage(0.00) //queue the damage instance instead of letting it run recursively
    return false
endfunction

private function UDTX takes unit src, unit tgt, real amt, boolean a, boolean r, attacktype at, damagetype dt, weapontype wt, integer ph returns boolean
    if SetVars(src, tgt, amt, at, dt, wt, ph) then
        call DisableTrigger(trig)
        call UnitDamageTarget(udg_DamageEventSource, udg_DamageEventTarget, udg_DamageEventAmount, a, r, ConvertAttackType(udg_DamageEventAttackT), ConvertDamageType(udg_DamageEventDamageT), ConvertWeaponType(udg_DamageEventWeaponT))
        call ClearDamageEvent()
        return true
    endif
    return false
endfunction

private function DoCleanup takes nothing returns nothing
    local integer i = -1
    loop
        exitwhen i >= recursion
        set i = i + 1 //Need to loop bottom to top to make sure damage order is preserved.
        
        if lastAmount[i] != 0.00 then
            set udg_NextDamageType = lastType[i]
            if lastTrig[i] != null then
                call DisableTrigger(lastTrig[i])//Since the damage is run sequentially now, rather than recursively, the system needs to disable the user's trigger for them.
            endif
            call UDTX(lastSource[i], lastTarget[i], lastAmount[i], true, false, lastAttackT[i], lastDamageT[i], lastWeaponT[i], -1)
        endif
    endloop
    loop
        exitwhen i <= -1
        if lastTrig[i] != null then
            call EnableTrigger(lastTrig[i]) //Only re-enable recursive triggers AFTER all damage is dealt.
        endif
        set i = i - 1
    endloop
    set recursion = -1 //Can only be set after all the damage has successfully ended.
endfunction

//The traditional on-damage response, where armor reduction has already been factored in.
private function OnDamage takes nothing returns boolean
    local real r = GetEventDamage()
    local damagetype dt = BlzGetEventDamageType()
    local boolean rec = recursive
    call ClearDamageEvent()
    
    call DisableTrigger(otrg)
    if udg_DamageEventPrevAmt == 0.00 then
        set recursive = true
        set udg_DamageEvent = 0.00
        set udg_DamageEvent = 2.00
    else
        //Unfortunately, Spirit Link and Thorns Aura/Spiked Carapace fire the DAMAGED event out of sequence with the DAMAGING event,
        //so I have to re-generate some stuff here.
        if GetHandleId(dt) != udg_DamageEventDamageT then
            call SetVars(GetEventDamageSource(), BlzGetEventDamageTarget(), r, BlzGetEventAttackType(), dt, BlzGetEventWeaponType(), 2)
        endif
        
        //DamageEventAmount remains unmodified by in-game damage processing for DamageTypePure.
        //Damage may have been further adjusted (ie. unit armor or armor type reduction)
        //Do not adjust in case damage was below zero because WC3 no longer treats it as a heal. 
        if (udg_DamageEventAmount > 0.00 or r < 0.00) and not udg_DamageEventOverride then
            set udg_DamageEventAmount = r
        endif
        
        set recursive = true
        if udg_DamageEventAmount > 0.00 then
            //This event is used for custom shields which have a limited hit point value
            //The shield here kicks in after armor, so it acts like extra hit points.
            set udg_DamageModifierEvent = 0.00
            set udg_DamageModifierEvent = 4.00
            
            set udg_LethalDamageHP = GetWidgetLife(udg_DamageEventTarget) - udg_DamageEventAmount
            if udg_LethalDamageHP <= 0.405 then
                
                set udg_LethalDamageEvent = 0.00    //New - added 10 May 2019 to detect and potentially prevent lethal damage. Instead of
                set udg_LethalDamageEvent = 1.00    //modifying the damage, you need to modify LethalDamageHP instead (the final HP of the unit).
                
                set udg_DamageEventAmount = GetWidgetLife(udg_DamageEventTarget) - udg_LethalDamageHP
                if udg_DamageEventType < 0 and udg_LethalDamageHP <= 0.405 then
                    call SetUnitExploded(udg_DamageEventTarget, true)   //Explosive damage types should blow up the target.
                endif
            endif
        endif
        
        //Apply the final damage amount.
        if udg_DamageEventAmount < 0.00 then
            call SetWidgetLife(udg_DamageEventTarget, GetWidgetLife(udg_DamageEventTarget) - udg_DamageEventAmount)
            call BlzSetEventDamage(0.00)
        else
            call BlzSetEventDamage(udg_DamageEventAmount)
        endif
        
        //AfterDamageEvent was removed as it is no longer required.
        if dt != DAMAGE_TYPE_UNKNOWN then
            set udg_DamageEvent = 0.00
            set udg_DamageEvent = 1.00
        endif
    endif
    call EnableTrigger(otrg)
    set recursive = false
    set clearable = true
    return false
endfunction


private function DebugStr takes nothing returns nothing
    set udg_AttackTypeDebugStr[0] = "SPELLS"
    set udg_AttackTypeDebugStr[1] = "NORMAL" 
    set udg_AttackTypeDebugStr[2] = "PIERCE"
    set udg_AttackTypeDebugStr[3] = "SIEGE" 
    set udg_AttackTypeDebugStr[4] = "MAGIC" 
    set udg_AttackTypeDebugStr[5] = "CHAOS" 
    set udg_AttackTypeDebugStr[6] = "HERO" 
    
    set udg_DamageTypeDebugStr[0]  = "UNKNOWN"
    set udg_DamageTypeDebugStr[4]  = "NORMAL"
    set udg_DamageTypeDebugStr[5]  = "ENHANCED"
    set udg_DamageTypeDebugStr[8]  = "FIRE"
    set udg_DamageTypeDebugStr[9]  = "COLD"
    set udg_DamageTypeDebugStr[10] = "LIGHTNING"
    set udg_DamageTypeDebugStr[11] = "POISON"
    set udg_DamageTypeDebugStr[12] = "DISEASE"
    set udg_DamageTypeDebugStr[13] = "DIVINE"
    set udg_DamageTypeDebugStr[14] = "MAGIC"
    set udg_DamageTypeDebugStr[15] = "SONIC"
    set udg_DamageTypeDebugStr[16] = "ACID"
    set udg_DamageTypeDebugStr[17] = "FORCE"
    set udg_DamageTypeDebugStr[18] = "DEATH"
    set udg_DamageTypeDebugStr[19] = "MIND"
    set udg_DamageTypeDebugStr[20] = "PLANT"
    set udg_DamageTypeDebugStr[21] = "DEFENSIVE"
    set udg_DamageTypeDebugStr[22] = "DEMOLITION"
    set udg_DamageTypeDebugStr[23] = "SLOW_POISON"
    set udg_DamageTypeDebugStr[24] = "SPIRIT_LINK"
    set udg_DamageTypeDebugStr[25] = "SHADOW_STRIKE"
    set udg_DamageTypeDebugStr[26] = "UNIVERSAL"
    
    set udg_WeaponTypeDebugStr[0]  = "NONE"
    set udg_WeaponTypeDebugStr[1]  = "METAL_LIGHT_CHOP"
    set udg_WeaponTypeDebugStr[2]  = "METAL_MEDIUM_CHOP"
    set udg_WeaponTypeDebugStr[3]  = "METAL_HEAVY_CHOP"
    set udg_WeaponTypeDebugStr[4]  = "METAL_LIGHT_SLICE"
    set udg_WeaponTypeDebugStr[5]  = "METAL_MEDIUM_SLICE"
    set udg_WeaponTypeDebugStr[6]  = "METAL_HEAVY_SLICE"
    set udg_WeaponTypeDebugStr[7]  = "METAL_MEDIUM_BASH"
    set udg_WeaponTypeDebugStr[8]  = "METAL_HEAVY_BASH"
    set udg_WeaponTypeDebugStr[9]  = "METAL_MEDIUM_STAB"
    set udg_WeaponTypeDebugStr[10] = "METAL_HEAVY_STAB"
    set udg_WeaponTypeDebugStr[11] = "WOOD_LIGHT_SLICE"
    set udg_WeaponTypeDebugStr[12] = "WOOD_MEDIUM_SLICE"
    set udg_WeaponTypeDebugStr[13] = "WOOD_HEAVY_SLICE"
    set udg_WeaponTypeDebugStr[14] = "WOOD_LIGHT_BASH"
    set udg_WeaponTypeDebugStr[15] = "WOOD_MEDIUM_BASH"
    set udg_WeaponTypeDebugStr[16] = "WOOD_HEAVY_BASH"
    set udg_WeaponTypeDebugStr[17] = "WOOD_LIGHT_STAB"
    set udg_WeaponTypeDebugStr[18] = "WOOD_MEDIUM_STAB"
    set udg_WeaponTypeDebugStr[19] = "CLAW_LIGHT_SLICE"
    set udg_WeaponTypeDebugStr[20] = "CLAW_MEDIUM_SLICE"
    set udg_WeaponTypeDebugStr[21] = "CLAW_HEAVY_SLICE"
    set udg_WeaponTypeDebugStr[22] = "AXE_MEDIUM_CHOP"
    set udg_WeaponTypeDebugStr[23] = "ROCK_HEAVY_BASH"
endfunction
private function ConfigInit takes nothing returns nothing
    // -
    // You can add extra classifications here if you want to differentiate between your triggered damage
    // Use DamageTypeExplosive (or any negative value damage type) if you want a unit killed by that damage to explode
    // -
    // The pre-defined type Code might be set by Damage Engine if Unit - Damage Target is detected and the user didn't define a type of their own.
    // "Pure" is especially important because it overrides both the Damage Engine as well as WarCraft 3 damage modification.
    // I therefore gave the user "Explosive Pure" in case one wants to combine the functionality of the two.
    // -
    set udg_DamageTypePureExplosive = -2
    set udg_DamageTypeExplosive = -1
    set udg_DamageTypeCode = 1
    set udg_DamageTypePure = 2
    // -
    set udg_DamageTypeHeal = 3
    set udg_DamageTypeBlocked = 4
    set udg_DamageTypeReduced = 5
    // -
    set udg_DamageTypeCriticalStrike = 6
    // -
    // Added 25 July 2017 to allow detection of things like Bash or Pulverize or AOE spread
    // -
    set udg_DamageEventAOE = 1
    set udg_DamageEventLevel = 1
    // -
    // In-game World Editor doesn't allow Attack Type and Damage Type comparisons. Therefore I need to code them as integers into GUI
    // -
    set udg_ATTACK_TYPE_SPELLS = 0
    set udg_ATTACK_TYPE_NORMAL = 1
    set udg_ATTACK_TYPE_PIERCE = 2
    set udg_ATTACK_TYPE_SIEGE = 3
    set udg_ATTACK_TYPE_MAGIC = 4
    set udg_ATTACK_TYPE_CHAOS = 5
    set udg_ATTACK_TYPE_HERO = 6
    // -
    set udg_DAMAGE_TYPE_UNKNOWN = 0
    set udg_DAMAGE_TYPE_NORMAL = 4
    set udg_DAMAGE_TYPE_ENHANCED = 5
    set udg_DAMAGE_TYPE_FIRE = 8
    set udg_DAMAGE_TYPE_COLD = 9
    set udg_DAMAGE_TYPE_LIGHTNING = 10
    set udg_DAMAGE_TYPE_POISON = 11
    set udg_DAMAGE_TYPE_DISEASE = 12
    set udg_DAMAGE_TYPE_DIVINE = 13
    set udg_DAMAGE_TYPE_MAGIC = 14
    set udg_DAMAGE_TYPE_SONIC = 15
    set udg_DAMAGE_TYPE_ACID = 16
    set udg_DAMAGE_TYPE_FORCE = 17
    set udg_DAMAGE_TYPE_DEATH = 18
    set udg_DAMAGE_TYPE_MIND = 19
    set udg_DAMAGE_TYPE_PLANT = 20
    set udg_DAMAGE_TYPE_DEFENSIVE = 21
    set udg_DAMAGE_TYPE_DEMOLITION = 22
    set udg_DAMAGE_TYPE_SLOW_POISON = 23
    set udg_DAMAGE_TYPE_SPIRIT_LINK = 24
    set udg_DAMAGE_TYPE_SHADOW_STRIKE = 25
    set udg_DAMAGE_TYPE_UNIVERSAL = 26
    // -
    // The below variables don't affect damage amount, but do affect the sound played
    // They also give important information about the type of attack used.
    // They can differentiate between ranged and melee for units who are both
    // -
    set udg_WEAPON_TYPE_NONE = 0
    // Metal Light/Medium/Heavy
    set udg_WEAPON_TYPE_ML_CHOP = 1
    set udg_WEAPON_TYPE_MM_CHOP = 2
    set udg_WEAPON_TYPE_MH_CHOP = 3
    set udg_WEAPON_TYPE_ML_SLICE = 4
    set udg_WEAPON_TYPE_MM_SLICE = 5
    set udg_WEAPON_TYPE_MH_SLICE = 6
    set udg_WEAPON_TYPE_MM_BASH = 7
    set udg_WEAPON_TYPE_MH_BASH = 8
    set udg_WEAPON_TYPE_MM_STAB = 9
    set udg_WEAPON_TYPE_MH_STAB = 10
    // Wood Light/Medium/Heavy
    set udg_WEAPON_TYPE_WL_SLICE = 11
    set udg_WEAPON_TYPE_WM_SLICE = 12
    set udg_WEAPON_TYPE_WH_SLICE = 13
    set udg_WEAPON_TYPE_WL_BASH = 14
    set udg_WEAPON_TYPE_WM_BASH = 15
    set udg_WEAPON_TYPE_WH_BASH = 16
    set udg_WEAPON_TYPE_WL_STAB = 17
    set udg_WEAPON_TYPE_WM_STAB = 18
    // Claw Light/Medium/Heavy
    set udg_WEAPON_TYPE_CL_SLICE = 19
    set udg_WEAPON_TYPE_CM_SLICE = 20
    set udg_WEAPON_TYPE_CH_SLICE = 21
    // Axe Medium
    set udg_WEAPON_TYPE_AM_CHOP = 22
    // Rock Heavy
    set udg_WEAPON_TYPE_RH_BASH = 23
    // -
    call DebugStr()
endfunction
//===========================================================================
private function Init takes nothing returns nothing
    call TriggerRegisterAnyUnitEventBJ(otrg, EVENT_PLAYER_UNIT_DAMAGED) //Thanks to this I no longer have to have 1 event for all units in the map.
    call TriggerAddCondition(otrg, Filter(function OnDamage))
    
    call TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_DAMAGING) //The new 1.31 event which fires before damage.
    call TriggerAddCondition(trig, Filter(function OnPreDamage))
    
    call ConfigInit()

    set cleaner = function DoCleanup
endfunction

//New function that hacks a UDT call directly into the damage modification phase, setting some stuff automatically for the user.
function UnitDamageTargetEx takes unit src, unit tgt, real amt, boolean a, boolean r, attacktype at, damagetype dt, weapontype wt returns boolean
    if udg_DamageEventTrigger == null then
        set udg_DamageEventTrigger = GetTriggeringTrigger() //Directly access the user's calling trigger
    endif
    if udg_NextDamageType == 0 then
       set udg_NextDamageType = udg_DamageTypeCode 
    endif
    return UDTX(src, tgt, amt, a, r, at, dt, wt, 1)
endfunction

endlibrary 