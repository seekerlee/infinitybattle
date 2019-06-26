library Util requires ARGB

    globals
        private constant integer RGB_BAD = 0xFFFF0000 // red
        private constant integer RGB_INFO = 0xFF3399FF // blue
        private constant integer RGB_WARN = 0xFFFFFF00 // yellow
        
        private constant string BOUNTY_ART = "UI\\Feedback\\GoldCredit\\GoldCredit.mdl"
    endglobals

    function broadCast takes string text returns nothing
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 5.0, text)
    endfunction

    function broadCastRGB takes string text, ARGB color returns nothing
        call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 5.0, color.str(text))
    endfunction
    
    function broadCastBAD takes string text returns nothing
        call broadCastRGB(text, RGB_BAD)
    endfunction

    function broadCastINFO takes string text returns nothing
        call broadCastRGB(text, RGB_INFO)
    endfunction

    function broadCastWARN takes string text returns nothing
        call broadCastRGB(text, RGB_WARN)
    endfunction

    function Degrade takes string message, ARGB colorA, ARGB colorB returns string
        local integer i=0
        local integer L=StringLength(message)
        local string  r
        if(L==1) then
            return ARGB.mix(colorA,colorB,0.5).str(message)
        endif
        set r=""
        loop
            exitwhen (i>=L)
            set r=r+ARGB.mix(colorA,colorB, i*(1.0/ (L-1) ) ).str( SubString(message,i,i+1) )
            set i=i+1
        endloop
        return r
    endfunction

    //
    private function playGold takes nothing returns boolean
        if IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) then
            call DestroyEffect(AddSpecialEffectTarget(BOUNTY_ART, GetFilterUnit(), "head"))
        endif
        return false
    endfunction

    function rewardAllPlayer takes integer gold, integer lumber returns nothing
        local User p = User.first
 
        loop // only loop through players that are playing
            exitwhen p == User.NULL
            //GroupEnumUnitsOfPlayer               takes group whichGroup, player whichPlayer, boolexpr filter returns nothing
            call GroupEnumUnitsOfPlayer(ENUM_GROUP, p.toPlayer(), Filter(function playGold))
            call SetPlayerState(p.toPlayer(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p.toPlayer(), PLAYER_STATE_RESOURCE_GOLD) + gold)
            call SetPlayerState(p.toPlayer(), PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(p.toPlayer(), PLAYER_STATE_RESOURCE_LUMBER) + lumber)
            set p = p.next
        endloop
    endfunction

    //call BJDebugMsg( Degrade("Hello" , 0xFFFF0000, 0xFF0000FF ) )
endlibrary
