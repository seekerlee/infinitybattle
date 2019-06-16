library dh initializer init requires RegisterPlayerUnitEvent

globals
    
        
        unit dh1
        unit dh2
        boolean did = false
endglobals


    private function learned takes nothing returns boolean
        local integer lvl = GetUnitAbilityLevel(GetTriggerUnit(), 'AEev')
        local ability ab = BlzGetUnitAbility(GetTriggerUnit(), 'AEev')
        local integer i = 0
        // if GetLearnedSkillBJ() == 'AEev'
            // y =100-1/ ( (x + 10) / 1000)
        call BlzSetAbilityStringField(ab, ABILITY_SF_NAME, "test")
        
        if not did then
            loop
                exitwhen i == 10
                call BJDebugMsg("testets1")
                call BlzSetAbilityStringLevelField(ab, ABILITY_SLF_TOOLTIP_LEARN_EXTENDED, i, "ABILITY_SLF_TOOLTIP_LEARN_EXTENDED")
                call BlzSetAbilityStringLevelField(ab, ABILITY_SLF_TOOLTIP_LEARN, i, "ABILITY_SLF_TOOLTIP_LEARN")
                call BlzSetAbilityStringLevelField(ab, ABILITY_SLF_TOOLTIP_NORMAL, i, "ABILITY_SLF_TOOLTIP_NORMAL")
                call BlzSetAbilityStringLevelField(ab, ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, i, "ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED")
                
                // 100-1 / ( (i + 10) / 1000)
                call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_CHANCE_TO_EVADE_EEV1, i, 0.1 * i)
                call BJDebugMsg("testets4")
                set i = i + 1
            endloop
            set did = true
        endif

        return false
    endfunction
    private function learned2 takes nothing returns boolean
        local integer lvl = GetUnitAbilityLevel(GetTriggerUnit(), 'AEfk')
        local ability ab = BlzGetUnitAbility(GetTriggerUnit(), 'AEfk')
        local integer i = 0
        // if GetLearnedSkillBJ() == 'AEev'
            // y =100-1/ ( (x + 10) / 1000)
        call BlzSetAbilityStringField(ab, ABILITY_SF_NAME, "test")
        
        if not did then
            loop
                exitwhen i == 10
                call BJDebugMsg("testets1")
                call BlzSetAbilityStringLevelField(ab, ABILITY_SLF_TOOLTIP_LEARN_EXTENDED, i, "ABILITY_SLF_TOOLTIP_LEARN_EXTENDED")
                call BlzSetAbilityStringLevelField(ab, ABILITY_SLF_TOOLTIP_LEARN, i, "ABILITY_SLF_TOOLTIP_LEARN")
                call BlzSetAbilityStringLevelField(ab, ABILITY_SLF_TOOLTIP_NORMAL, i, "ABILITY_SLF_TOOLTIP_NORMAL")
                call BlzSetAbilityStringLevelField(ab, ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, i, "ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED")
                
                // 100-1 / ( (i + 10) / 1000)
                call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_MAXIMUM_TOTAL_DAMAGE, i, 0.0)
                call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_DAMAGE_PER_TARGET_EFK1, i, 100.0 * (i + 1))
                call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_AREA_OF_EFFECT, i, 1000.0 * (i + 1))
                call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_COOLDOWN, i, 10 / (i + 1))
                call BlzSetAbilityIntegerLevelField(ab, ABILITY_ILF_MANA_COST, i, 100 / (i + 1))

                call BlzSetAbilityTooltip('AEfk', "ability tooltip", i)
                call BlzSetAbilityExtendedTooltip('AEfk', "ability extended tooltip", i)
                call BlzSetAbilityResearchTooltip('AEfk', "ability research tooltip", i)
                call BlzSetAbilityResearchExtendedTooltip('AEfk', "ability research extended tooltip", i)
                
                call BJDebugMsg("testets4")
                set i = i + 1
            endloop
            set did = true
        endif

            
        return false
    endfunction

    private function initAbility takes nothing returns nothing
    endfunction

    
    private function ordered takes nothing returns boolean
        local ability ab
        if GetIssuedOrderId() == OrderId("fanofknives") then
            call BJDebugMsg("ordered, level: " + I2S(GetUnitAbilityLevel(GetOrderedUnit(), 'AEfk')))
            set ab = BlzGetUnitAbility(GetOrderedUnit(), 'AEfk')
            call BlzSetAbilityRealLevelField(ab, ABILITY_RLF_DAMAGE_PER_TARGET_EFK1, GetUnitAbilityLevel(GetOrderedUnit(), 'AEfk') - 1, 100.0 * GetHeroAgi(GetOrderedUnit(), true))
        endif
        set ab = null
        return false
    endfunction


    private function init takes nothing returns nothing
        //call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_HERO_SKILL, function learned2)
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_ORDER, function ordered)
        
        set dh1 = CreateUnit(Player(0), 'Edem', 100, 100, 90.0)
        set dh2 = CreateUnit(Player(0), 'Ewar', 100, 100, 90.0)
        call SetHeroLevel(dh1, 100, true)
        call SetHeroLevel(dh2, 100, true)
        call initAbility()
    endfunction
endlibrary
