library heroSelect initializer Init requires RegisterPlayerUnitEvent

    globals
        private constant integer ID_SELECTOR = 'e001'
        public constant group PLAYER_HEROS = CreateGroup()
    endglobals
    
    private function ActionSold takes nothing returns boolean
        local unit hero = GetSoldUnit()
        local integer index = 0
        if (GetSellingUnit() == udg_Tavern) then
            // call RemoveUnitFromAllStock( GetUnitTypeId(hero) )
            call SetUnitPositionLoc(hero, GetRectCenter(gg_rct_born))
            // camera
            call PanCameraToTimedLocForPlayer( GetOwningPlayer(hero), GetRectCenter(gg_rct_born), 0 )
            //call RemoveUnit(GetBuyingUnit())
            call SetPlayerMaxHeroesAllowed(0, Player(index))
            call GroupAddUnit(PLAYER_HEROS, hero)
            loop
                exitwhen index >= bj_MAX_PLAYERS 
                call SetPlayerUnitAvailableBJ(GetUnitTypeId(hero), false, Player(index))
                set index = index + 1
            endloop
        endif
        return false
    endfunction
    
    private function Action takes nothing returns nothing
        local integer index = 0
        local real x = GetLocationX(GetUnitLoc(udg_Tavern))
        local real y = GetLocationY(GetUnitLoc(udg_Tavern))
        loop
            exitwhen index >= bj_MAX_PLAYERS // 12
            if (GetPlayerController(Player(index)) == MAP_CONTROL_USER and GetPlayerSlotState(Player(index)) == PLAYER_SLOT_STATE_PLAYING) then
                // create unit for player
                call CreateUnit(Player(index), ID_SELECTOR, x, y, 0)
            endif
            set index = index + 1
        endloop
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_SELL, function ActionSold)
    endfunction

    private function Init takes nothing returns nothing
        local real x = GetLocationX(GetUnitLoc(udg_Tavern))
        local trigger t = CreateTrigger(  )
        
        call TriggerRegisterVariableEvent( t, "udg_EVENT_MAP_VAR_SET", EQUAL, 1.00 )
        call TriggerAddAction( t, function Action )
        set t = null
        
    endfunction

endlibrary