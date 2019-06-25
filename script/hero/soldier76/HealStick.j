library HealStick initializer init requires RegisterPlayerUnitEvent
    globals
        private constant integer STICK_ID = 'o001'
        private constant integer STICK_AB_ID = 'A014'
        private constant integer S67_AB_ID = 'A00T'
    endglobals

    private function Actions takes nothing returns boolean
        local unit sk = GetSummonedUnit()
        if GetUnitTypeId(sk) == STICK_ID then
            call SetUnitAbilityLevel(sk, STICK_AB_ID, GetUnitAbilityLevel(GetSummoningUnit(), S67_AB_ID))
        endif
        set sk = null
        return false
    endfunction

    private function init takes nothing returns nothing
        local integer i = 1
        loop
            exitwhen i > 10
            call BlzSetAbilityTooltip(S67_AB_ID, "生物力场(|cffffcc00W|r) - [|cffffcc00等级 " + I2S(i) + "|r]", i - 1)
            call BlzSetAbilityExtendedTooltip(S67_AB_ID, "在地上放置一个生物力场。每秒回复500范围内友军" + I2S(2 * i) + "%的生命，持续20秒。", i - 1)
            set i = i + 1
        endloop
        set i = 0
        loop
            exitwhen i > 10
            call BlzSetAbilityTooltip('A00W', "爆头 - [|cffffcc00等级 " + I2S(i) + "|r]", i - 1)
            call BlzSetAbilityExtendedTooltip('A00W', "有15%的概率爆头，造成" + I2S(i + 1) + "倍伤害。", i - 1)
            set i = i + 1
        endloop
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SUMMON, function Actions)
    endfunction
endlibrary
