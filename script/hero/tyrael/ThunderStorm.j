library ThunderStorm initializer Init requires GroupUtils, UnitDex

    globals
        private weathereffect weather
        //
        private constant integer ID_TIANQIAN = 'A009'
        private constant integer ID_THUNDERSTORM = 'A00E'
        private constant string LIGHTSHIELD = "Abilities\\Spells\\Orc\\LightningShield\\LightningShieldTarget.mdl"

        private integer g_enumParamPlay = -1
    endglobals
        
    struct thunder extends array
        effect lighteff
        timer castTimer

        private static method doTianqian takes unit source, unit target returns nothing
            local xecast xc = xecast.createBasicA(ID_TIANQIAN, OrderId("thunderbolt"), GetOwningPlayer(source) )
            if GetUnitAbilityLevel(source, ID_TIANQIAN) == 0 then
                set xc.level = 1
            else
                set xc.level = GetUnitAbilityLevel(source, ID_TIANQIAN)
            endif
            call xc.castOnTarget( target )
        endmethod
        
        private static method NotAlly takes nothing returns boolean
            return IsUnitAliveBJ(GetFilterUnit()) and IsPlayerEnemy(GetOwningPlayer(GetFilterUnit()), Player(g_enumParamPlay)) //TODO BJ
        endmethod

        private static method dianliao takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            local unit u = GetUnitById(this)
            local group gdaomei
            local integer i = 0
            local integer groupCount
            
            call SetUnitAnimation(u, "attack")
            
            set g_enumParamPlay = GetPlayerId(GetOwningPlayer(u))
            call GroupEnumUnitsInRange(ENUM_GROUP, GetUnitX(u), GetUnitY(u), 900, Filter(function thistype.NotAlly))
            // set gdaomei = GetRandomSubGroup(CountUnitsInGroup(g) / 4, g)
            set gdaomei = GetRandomSubGroup(3, ENUM_GROUP)
            set groupCount = BlzGroupGetSize(gdaomei)

            loop
                exitwhen i == groupCount
                call thistype.doTianqian(u, BlzGroupUnitAt(gdaomei, i))
                set i = i + 1
            endloop
            
            call DestroyGroup(gdaomei)
            set gdaomei = null
            set u = null
        endmethod
        
        static method onSpellCast takes nothing returns boolean
            local unit u
            local thistype this
            local real interval
            if GetSpellAbilityId() != ID_THUNDERSTORM then
                return false
            endif
            set u = GetTriggerUnit()
            set this = GetUnitId(u)
            set this.castTimer = NewTimerEx(this)
            set interval = 1.0 - (GetUnitAbilityLevel(u, ID_THUNDERSTORM) - 1) / 3.0
            call TimerStart(this.castTimer, interval, true, function thistype.dianliao)
            set this.lighteff = AddSpecialEffectTarget( LIGHTSHIELD , u, "origin")
            // weather
            call EnableWeatherEffect( weather, true )
            
            set u = null
            return false
        endmethod
        
        static method onSpellCastEnd takes nothing returns boolean
            local unit u
            local thistype this
            if GetSpellAbilityId() != ID_THUNDERSTORM then
                return false
            endif
            set u = GetTriggerUnit()
            set this = GetUnitId(u)
            
            call EnableWeatherEffect( weather, false )
            set u = null
            call DestroyEffect(this.lighteff)
            call ReleaseTimer(this.castTimer)
            set this.castTimer = null
            set this.lighteff = null
            return false
        endmethod
    endstruct
    

    private function Init takes nothing returns nothing
        set weather = AddWeatherEffect( GetEntireMapRect(), 'RAhr' )
        
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_EFFECT, function thunder.onSpellCast)
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_ENDCAST, function thunder.onSpellCastEnd)
    endfunction

endlibrary