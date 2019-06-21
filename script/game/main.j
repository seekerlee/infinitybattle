library main initializer init requires Table, Spawn, Jaina, Battle, Shopping, HeroSelect, MapConst
    globals
        private key GAME_INIT
        private key GAME_WAIT
        private key GAME_BATTLE

    endglobals

    private function onJainaDie takes nothing returns boolean
        call BJDebugMsg("dead")
        return false
    endfunction

    private function onBattleEnd takes nothing returns boolean
        call BJDebugMsg("onBattleEnd")
        set currentWave = currentWave + 1
        call startShopping()
        return false
    endfunction

    private function onShoppingEnd takes nothing returns boolean
        call startBattle(currentWave)
        return false
    endfunction
    
    function initGame takes nothing returns nothing
        // init Jaina
        call initJaina()
        call initBattle()
        call initShopping()
        call InitHeroSelect()
        call registerOnJainaDie(function onJainaDie)
        call registerOnBattleEnd(function onBattleEnd)
        call registerOnShoppingEnd(function onShoppingEnd)
        
        call startShopping()
    endfunction

    private function initex takes nothing returns nothing
        call DestroyTimer(GetExpiredTimer())
        call initGame()
    endfunction

    private function init takes nothing returns nothing
        call FogMaskEnable(false)
        call FogEnable(false)
        call TimerStart(CreateTimer(), 0, false, function initex)
    endfunction
endlibrary
