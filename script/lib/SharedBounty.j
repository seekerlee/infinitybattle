// SHARED BOUNTY SYSTEM by ANDREWGOSU.
// ver. 1.2.

library SharedBounty initializer init

    globals
        //LEAVE THESE UNCHANGED
        boolexpr ALLIE_INDICATOR
        boolean array PLAYER_INDICATOR

        //CONFIGURATION

        //SYSTEM
        constant real    RADIUS   = 756. //The radius where the gold is distributed.
        constant integer HANDICAP = 100  //The bounty handicap. E.g 50 is half the normal bounty, 200 double the normal.

        //APPEREANCE
        constant string TEXTTAG_COLOUR  = "|cffffcc00"                                //Colour code of the texttag.
        constant string BOUNTY_ART      = "UI\\Feedback\\GoldCredit\\GoldCredit.mdl"  //Model path of the bounty art.
        constant string ATTACHMENTPOINT = "overhead"                                  //Attachmentpoint of the bounty art.
        
        //TEXTTAG CONFIGURATION
        constant integer TEXTTAG_TEXTSIZE  = 11  //The size of the texttag text.
        constant real    TEXTTAG_VELOCITY  = 64. //Texttag's velocity.
        constant real    TEXTTAG_ANGLE     = 90. //Texttag's angle.
        constant real    TEXTTAG_LIFESPAN  = 5.  //Texttag's lifespan.
        constant real    TEXTTAG_FADEPOINT = 4.  //Texttag's fading point.
    endglobals

    // SYSTEM
    function SharedBounty_Allied takes nothing returns boolean
        return (IsUnitAlly( GetKillingUnit(), GetOwningPlayer(GetFilterUnit()) ) == true)
    endfunction

    function SharedBounty_Gold takes integer level returns integer
        if     ( level == 1 ) then
            return GetRandomInt( 4, 6 )
        elseif ( level == 2 ) then
            return GetRandomInt( 6, 8 )
        elseif ( level == 3 ) then
            return GetRandomInt( 8, 10 )
        elseif ( level == 4 ) then
            return GetRandomInt( 11, 15 )
        elseif ( level == 5 ) then
            return GetRandomInt( 20, 26 )
        elseif ( level == 6 ) then
            return GetRandomInt( 44, 52 )
        elseif ( level == 7 ) then
            return GetRandomInt( 55, 65 )
        elseif ( level == 8 ) then
            return GetRandomInt( 76, 88 )
        elseif ( level == 9 ) then
            return GetRandomInt( 107, 121 )
        elseif ( level == 10 ) then
            return GetRandomInt( 158, 174 )
        endif
        return 0
    endfunction

    function SharedBounty_TextTag takes integer bounty, unit receiver returns nothing
        local texttag t          = CreateTextTag()
        local real    textHeight = TextTagSize2Height(TEXTTAG_TEXTSIZE)
        local real    vel        = TextTagSpeed2Velocity(TEXTTAG_VELOCITY)
        local real    xvel       = vel * Cos(TEXTTAG_ANGLE * bj_DEGTORAD)
        local real    yvel       = vel * Sin(TEXTTAG_ANGLE * bj_DEGTORAD)
        
        if ( GetLocalPlayer() == GetOwningPlayer(receiver) ) then
            call SetTextTagText(t, TEXTTAG_COLOUR + "+" + I2S(bounty) + "|r", textHeight)
            call SetTextTagPos( t, GetUnitX(receiver), GetUnitY(receiver), 0 )
            call SetTextTagColor( t, 0, 0, 0, 255 )
            call SetTextTagPermanent( t, false )
            call SetTextTagVelocity(t, xvel, yvel)
            call SetTextTagLifespan( t, TEXTTAG_LIFESPAN )
            call SetTextTagFadepoint( t, TEXTTAG_FADEPOINT )
            call SetTextTagVisibility( t, true )
        endif
        
        set t = null
    endfunction

    function SharedBounty_CreateBounty takes nothing returns nothing
        local group   g     = CreateGroup()
        local unit    a     = GetTriggerUnit()
        local integer level = GetUnitLevel(a)
        local integer i     = 0
        local integer id
        local unit    receiver
        local player  owner
        local integer amount
        local unit array receivers
        
        call DestroyEffect(AddSpecialEffectTarget(BOUNTY_ART, a, ATTACHMENTPOINT))
        loop
            exitwhen ( i == bj_MAX_PLAYERS )
            set PLAYER_INDICATOR[i] = true
            set i = i + 1
        endloop
        set i = 0
        call GroupEnumUnitsInRange( g, GetUnitX(a), GetUnitY(a), RADIUS, ALLIE_INDICATOR )
        loop
            set receiver = FirstOfGroup(g)
            exitwhen ( receiver == null )
            set owner = GetOwningPlayer(receiver)
            set id    = GetPlayerId(owner)
            if ( IsUnitType( receiver, UNIT_TYPE_HERO ) == true ) then
                if ( PLAYER_INDICATOR[id] == true ) then
                    set PLAYER_INDICATOR[id] = false
                    set i = i + 1
                    set receivers[i] = receiver
                endif
            endif
            call GroupRemoveUnit( g, receiver )
        endloop
        call DestroyGroup(g)
        set amount = SharedBounty_Gold(level) / i * (HANDICAP / 100)
        if ( amount < 1 ) then
        set amount = 1
        endif   
        loop
            exitwhen ( i == 0 )
            set owner = GetOwningPlayer(receivers[i])
            call SetPlayerState( owner, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD) + amount )
            call SharedBounty_TextTag( amount, receivers[i] )
            set receivers[i] = null
            set i = i - 1
        endloop
        
        set a        = null
        set g        = null
        set receiver = null
        set owner    = null
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        set ALLIE_INDICATOR = Condition(function SharedBounty_Allied)
        call TriggerRegisterPlayerUnitEvent( t, Player(PLAYER_NEUTRAL_AGGRESSIVE), EVENT_PLAYER_UNIT_DEATH, null )
        call TriggerAddAction( t, function SharedBounty_CreateBounty )   
        call SetPlayerState( Player(PLAYER_NEUTRAL_AGGRESSIVE), PLAYER_STATE_GIVES_BOUNTY, IntegerTertiaryOp( false, 1, 0 ) )
    endfunction
endlibrary
