scope Curse initializer init

    private function spellIdMatch takes nothing returns boolean
      return (GetSpellAbilityId()=='A005')
    endfunction

    private function onSpellCast takes nothing returns nothing
        local xecast   xc
        local unit     u   = GetTriggerUnit()
        local location loc = GetSpellTargetLoc() //The target point
        
        set xc  = xecast.createA() //CreateA so we don't have to destroy the object after the cast.
        
        call SetUnitAnimation(u, "attack") // Let's focus on the look of the item cast for a second...


        //==============================================
        // Here, we do assignments:
        //
        set xc.abilityid    = 'S000'                          //* Cast ability A005
        set xc.level        = GetUnitAbilityLevel(u, 'A005' ) //* Same level as trigger ability
        set xc.orderstring  = "cripple"                     //* The order is polymorph
        set xc.owningplayer = GetOwningPlayer(u)              //* The owning player, determines targets and bounty credits
       
        call xc.castOnAOELoc( loc, 300.0 )                    //* Our castOnAOE call, using the location version
                                                              //* A radius of 200.0
                                                              // Since createA was used, no need to destroy the xecast object

        call RemoveLocation(loc) //We need to clean the point.

        set loc=null
        set u=null
    endfunction


    private function init takes nothing returns nothing
     local trigger t=CreateTrigger()
        call TriggerAddCondition(t, Condition( function spellIdMatch) )
        call TriggerAddAction(t,    function onSpellCast)
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_SPELL_EFFECT )

     set t=null
    endfunction

endscope