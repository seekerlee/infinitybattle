library Curse initializer init requires SpellEffectEvent

    globals
        private constant integer CURSE_ID = 'A005'
    endglobals 

    private function onSpellCast takes nothing returns boolean
        local xecast   xc
        local unit     u   = GetTriggerUnit()
        local location loc = GetSpellTargetLoc() //The target point
        //
        local real size = BlzGetAbilityRealLevelField(BlzGetUnitAbility(GetTriggerUnit(), CURSE_ID), ABILITY_RLF_AREA_OF_EFFECT, GetUnitAbilityLevel(u, CURSE_ID ) - 1)
        
        set xc  = xecast.createA()
        call SetUnitAnimation(u, "attack") // Let's focus on the look of the item cast for a second...

        set xc.abilityid    = 'S000'                          //* Cast ability A005
        set xc.level        = GetUnitAbilityLevel(u, CURSE_ID ) //* Same level as trigger ability
        set xc.orderstring  = "cripple"                     //* The order is polymorph
        set xc.owningplayer = GetOwningPlayer(u)              //* The owning player, determines targets and bounty credits
       
        call xc.castOnAOELoc( loc, size )                    //* Our castOnAOE call, using the location version

        call RemoveLocation(loc) //We need to clean the point.

        set loc=null
        set u=null
        return false
    endfunction

    private function init takes nothing returns nothing
        call RegisterSpellEffectEvent(CURSE_ID, function onSpellCast)
    endfunction

endlibrary