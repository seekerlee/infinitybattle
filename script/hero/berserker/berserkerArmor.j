library berserkerArmor initializer Init requires TimerUtils, SpellEffectEvent

    globals
        boolean array berserkerStateOn
        private constant integer AB_ID = 'A00L'
        private constant real AB_EFFECT_TIME = 60.0
        
        private constant string EFF_SHOUT = "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl"
    endglobals
        
    private function Requirement takes nothing returns boolean
        return GetSpellAbilityId() == AB_ID
    endfunction
    
    private function bleed takes nothing returns nothing
        local unit u = GetUnitById(GetTimerData(GetExpiredTimer()))
        local integer luck
        if (IsUnitAliveBJ(u)) then
            call SetUnitLifePercentBJ(u, GetUnitLifePercent(u) - 1)
            set luck = GetRandomInt(0, 4)
            if (luck == 0) then
                call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodPriest.mdl" , u, "chest"))
            elseif (luck == 1) then
                call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl" , u, "chest"))
            elseif (luck == 2) then
                call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodFootman.mdl" , u, "chest"))
            elseif (luck == 3) then
                call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodKnight.mdl" , u, "chest"))
            elseif (luck == 4) then
                call DestroyEffect(AddSpecialEffectTarget( "Objects\\Spawnmodels\\Human\\HumanBlood\\HumanBloodSorceress.mdl" , u, "chest"))
            endif
        endif
        set u = null
    endfunction
    
    struct berserkerParam
        integer lifeBonus
        integer unitId
        timer bleedTimer
    endstruct

    private function recover takes nothing returns nothing
        local berserkerParam bp = GetTimerData(GetExpiredTimer())
        local unit u = GetUnitById(bp.unitId)
        // color:
        call SetUnitVertexColor(u, 127, 127, 127, 255)
        // life:
        call BlzSetUnitMaxHP(u, BlzGetUnitMaxHP(u) - bp.lifeBonus)
        // set global
        set berserkerStateOn[GetUnitId(u)] = false
        //
        call ReleaseTimer(bp.bleedTimer)
        call ReleaseTimer(GetExpiredTimer())
        set bp.bleedTimer = null
        call bp.destroy()
        set u = null
    endfunction

    private function Action takes nothing returns boolean
        local unit u
        local timer t_bleed
        local timer t_end
        local berserkerParam bp
        // 5 times life
        local integer max_life_now
        if (GetSpellAbilityId() != AB_ID) then
            return false
        endif
        set u = GetTriggerUnit()
        set t_bleed = NewTimerEx(GetUnitId(u))
        set t_end = NewTimer()
        set bp = berserkerParam.create()
        // 5 times life
        set max_life_now = BlzGetUnitMaxHP(u)
        call BlzSetUnitMaxHP(u, max_life_now * 5)
        // turn black
        call SetUnitVertexColor(u, 0, 0, 0, 255)
        // visual effect 
        call AddSpecialEffectLoc(EFF_SHOUT, GetUnitLoc(u))
        // bleeding
        call TimerStart(t_bleed, 0.5, true, function bleed)
        // update state
        set berserkerStateOn[GetUnitId(u)] = true
        // endtimer
        set bp.lifeBonus = max_life_now * 4
        set bp.unitId = GetUnitId(u)
        set bp.bleedTimer = t_bleed
        call SetTimerData(t_end, bp)
        call TimerStart(t_end, AB_EFFECT_TIME, false, function recover)
        
        set u = null
        set t_bleed = null
        set t_end = null

        return false
    endfunction

    private function Init takes nothing returns nothing
        call RegisterSpellEffectEvent(AB_ID, function Action)
    endfunction

endlibrary