library ShowDamage initializer init
    function Trig_Damage_Tag_Func003Func001Func001Func001Func001Func001Func002C takes nothing returns boolean
        if ( not ( udg_IsDamageRanged == true ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Damage_Tag_Func003Func001Func001Func001Func001Func001C takes nothing returns boolean
        if ( not ( udg_IsDamageSpell == true ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Damage_Tag_Func003Func001Func001Func001Func001C takes nothing returns boolean
        if ( not ( udg_DamageEventAmount < ( udg_DamageEventPrevAmt * 0.60 ) ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Damage_Tag_Func003Func001Func001Func001C takes nothing returns boolean
        if ( not ( udg_DamageEventAmount > 1.50 ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Damage_Tag_Func003Func001Func001C takes nothing returns boolean
        if ( not ( udg_DamageEventAmount >= ( udg_DamageEventPrevAmt * 1.50 ) ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Damage_Tag_Func003Func001C takes nothing returns boolean
        if ( not ( udg_DamageEventAmount < 0.00 ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Damage_Tag_Func003C takes nothing returns boolean
        if ( not ( udg_DamageEventAmount == 0.00 ) ) then
            return false
        endif
        return true
    endfunction

    function Trig_Damage_Tag_Actions takes nothing returns nothing
        local string udg_DmgStr = "|cffffffff"
        if ( Trig_Damage_Tag_Func003C() ) then
            set udg_DmgStr = ( "|c00AAAAAABlocked " + ( I2S(R2I(udg_DamageEventPrevAmt)) + "!|r" ) )
            call ArcingTextTag.create(udg_DmgStr, udg_DamageEventTarget)
        else
            if ( Trig_Damage_Tag_Func003Func001C() ) then
                set udg_DmgStr = "|cff00ff00+"
                call ArcingTextTag.create(udg_DmgStr + I2S(R2I(-udg_DamageEventAmount)) + "|r", udg_DamageEventTarget)
            else
                if ( Trig_Damage_Tag_Func003Func001Func001C() ) then
                    set udg_DmgStr = ( "|cffff0000" + ( I2S(R2I(udg_DamageEventAmount)) + "!|r" ) )
                    call ArcingTextTag.create(udg_DmgStr, udg_DamageEventTarget)
                else
                    if ( Trig_Damage_Tag_Func003Func001Func001Func001C() ) then
                        if ( Trig_Damage_Tag_Func003Func001Func001Func001Func001C() ) then
                            set udg_DmgStr = "|cff808000"
                        else
                            if ( Trig_Damage_Tag_Func003Func001Func001Func001Func001Func001C() ) then
                                set udg_DmgStr = "|cff3264c8"
                            else
                                if ( Trig_Damage_Tag_Func003Func001Func001Func001Func001Func001Func002C() ) then
                                    set udg_DmgStr = "|cffffff00"
                                else
                                endif
                            endif
                        endif
                        call ArcingTextTag.create(udg_DmgStr + I2S(R2I(udg_DamageEventAmount)) + "|r", udg_DamageEventTarget)
                    else
                    endif
                endif
            endif
        endif
    endfunction


    private function init takes nothing returns nothing
        // local trigger t = CreateTrigger()
        // call TriggerRegisterVariableEvent( t, "udg_DamageEvent", EQUAL, 1.00 )
        // call TriggerAddAction( t, function Trig_Damage_Tag_Actions )
    endfunction
endlibrary
