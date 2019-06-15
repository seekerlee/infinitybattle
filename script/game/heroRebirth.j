library heroRebirth initializer Init requires TimerUtils, RegisterPlayerUnitEvent, UnitDex

    globals
        private constant real TIME_REBORN = 15.0
        private constant timerdialog array tda
    endglobals

    
    private function DoRebirth takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer uIndex = GetTimerData(t)
        local timerdialog td = tda[uIndex]
        local unit hero = GetUnitById(uIndex)
        
        call ReviveHero(hero, GetLocationX(GetRectCenter(gg_rct_born)), GetLocationY(GetRectCenter(gg_rct_born)), true)
        
        call DestroyTimerDialog(td)
        call ReleaseTimer(t)
        set tda[uIndex] = null
        set hero = null
        set t = null
        set td = null
    endfunction
    
    private function Action takes nothing returns boolean
        local timer t
        local timerdialog td 
        local unit dyingU = GetDyingUnit()
        local integer uIndex
        if (IsUnitInGroup(dyingU, heroSelect_PLAYER_HEROS)) then
            set uIndex = GetUnitUserData(dyingU)
            set t = NewTimerEx(uIndex)
            set td = CreateTimerDialog(t)
            
            set tda[uIndex] = td
            
            call TimerDialogSetTitle(td, GetUnitName(dyingU))
            call TimerStart(t, TIME_REBORN, false, function DoRebirth)
            if GetLocalPlayer() == GetOwningPlayer(dyingU) then
                call TimerDialogDisplay(td, true)
            endif
                        
        endif
        set t = null
        set td = null
        set dyingU = null
        return false
    endfunction

    private function Init takes nothing returns nothing
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_DEATH, function Action)
    endfunction

endlibrary