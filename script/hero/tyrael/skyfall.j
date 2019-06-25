library skyfall initializer init requires SpellEffectEvent
    globals
        private constant integer AB_ID = 'A00A'

        private string EFF = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl"
        //private string EFF = "Abilities\\Spells\\Human\\ReviveHuman\\ReviveHuman.mdl"
        //
        private constant integer FLY_HEIGHT = 2000
        private constant integer FLY_RATE = 8000
        private constant real FLYING_TIME = 0.8
        private constant real UPDONW_TIME = I2R(FLY_HEIGHT) / I2R(FLY_RATE)
    endglobals

    
    struct skyfallSpell
        private real targetX
        private real targetY
        private unit bird

        static method create takes real targetX, real targetY, unit bird returns thistype
            local thistype this = thistype.allocate()
            set this.targetX = targetX
            set this.targetY = targetY
            set this.bird = bird
            return this
        endmethod

        method action takes nothing returns nothing
            local timer t = NewTimerEx(this)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", GetUnitX(this.bird), GetUnitY(this.bird)))
            
            call SetUnitInvulnerable(this.bird, true)
            call IssuePointOrder(this.bird, "move", this.targetX, this.targetY)
            
            call UnitAddAbility(this.bird, XE_HEIGHT_ENABLER)
            call UnitRemoveAbility(this.bird, XE_HEIGHT_ENABLER)
            call SetUnitFlyHeight(this.bird, FLY_HEIGHT, FLY_RATE)
            
            call TimerStart(t, UPDONW_TIME + FLYING_TIME, FALSE, function thistype.falldown)
            set t = null
        endmethod

        private method damageEarth takes unit u, real x, real y returns nothing
            local xecast xc
            call SetUnitAnimation(u, "attack")
        
            set xc = xecast.createA()
            set xc.abilityid    = 'A00B'
            set xc.level        = GetUnitAbilityLevel(u, AB_ID)
            set xc.orderstring  = "stomp"
            set xc.owningplayer = GetOwningPlayer(u)
        
            call xc.castInPoint( x, y )

            set u = null
        endmethod

        private static method falldowned takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            
            call SetUnitPathing( this.bird, true )
            call SetUnitInvulnerable(this.bird, false)
            
            call this.damageEarth(this.bird, this.targetX, this.targetY)
            
            call SetUnitAnimationByIndex(this.bird, 4)
            //call SetUnitAnimation(bird, "attack")
            
            call DestroyEffect(AddSpecialEffect(EFF, this.targetX, this.targetY))
            call ReleaseTimer(GetExpiredTimer())
            
            set this.bird = null
            call this.destroy()
        endmethod
        
        private static method falldown takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            //
            local timer fallTimer = NewTimerEx(this)
            
            call SetUnitPathing( this.bird, false ) // turn off collision
            call SetUnitPosition(this.bird, this.targetX, this.targetY)
            call SetUnitFlyHeight(this.bird, 0, FLY_RATE)
            
            call TimerStart(fallTimer, UPDONW_TIME, FALSE, function thistype.falldowned)
            
            call ReleaseTimer(GetExpiredTimer())
            
            set fallTimer = null
        endmethod
    endstruct
    
    private function onCast takes nothing returns nothing
        local skyfallSpell sp = skyfallSpell.create(GetSpellTargetX(), GetSpellTargetY(), GetTriggerUnit())
        call sp.action()
    endfunction
    
    private function init takes nothing returns nothing
        local integer i = 1
        loop
            exitwhen i > 10
            call BlzSetAbilityTooltip(AB_ID, "物理天谴(|cffffcc00W|r) - [|cffffcc00等级 " + I2S(i) + "|r]", i - 1)
            call BlzSetAbilityExtendedTooltip(AB_ID, "英雄对目标地点腾空而起，在落地时对300范围内的敌人造成" + I2S(100 + (i - 1) * 50 ) + "点伤害并使其眩晕" + R2S(3.0 + (i - 1) / 3.0 ) + "秒", i - 1)
            set i = i + 1
        endloop
        call RegisterSpellEffectEvent(AB_ID, function onCast)
    endfunction

endlibrary