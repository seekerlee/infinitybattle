library main initializer init requires Table, Spawn, Jaina, Battle, HeroSelect, MapConst, Util, TimerUtils
    globals
        private key GAME_INIT
        private key GAME_WAIT
        private key GAME_BATTLE

        private real waitingTime = 10.0
        private timerdialog waitTD
    endglobals

    private function onJainaDie takes nothing returns boolean
        call broadCastBAD("吉安娜：要你们有什么用？！")
        return false
    endfunction

    function endWaiting takes nothing returns nothing
        call DestroyTimerDialog(waitTD)
        set waitTD = null
        call ReleaseTimer(GetExpiredTimer())
        call startBattle(currentWave)
    endfunction

    function startWaiting takes nothing returns nothing
        local timer waitTimer = NewTimer()
        call broadCastWARN(R2S(waitingTime) + "秒中后下一波敌人来袭")
        set waitTD = CreateTimerDialog(waitTimer)
        call TimerDialogSetTitle(waitTD, "第" + I2S(currentWave + 1) + "波倒计时")
        call TimerStart(waitTimer, waitingTime, false, function endWaiting)
        call TimerDialogDisplay(waitTD, true)
        set waitTimer = null
    endfunction

    private function onBattleEnd takes nothing returns boolean
        call broadCastINFO("战斗结束，这一波吉安娜受到了" + R2S(GetDamage()) + "点伤害," + I2S(GetDamageCount()) + "次攻击")
        if GetDamage() < 5000 or GetDamageCount() < 15 then
            call broadCastINFO("吉安娜很开心，奖励大家1000金3木")
            call rewardAllPlayer(1000, 3)
        elseif GetDamage() < 10000 or GetDamageCount() < 100 then
            call broadCastWARN("吉安娜心情一般，还是奖励大家600金2木")
            call rewardAllPlayer(600, 2)
        else
            call broadCastBAD("吉安娜心情很糟，勉强给大家300金1木")
            call rewardAllPlayer(300, 1)
        endif
        call ClearDamage()
        
        set currentWave = currentWave + 1
        call startWaiting()
        return false
    endfunction

    private function onSelectDone takes nothing returns boolean
        call startWaiting()
        call initJaina2()
        return false
    endfunction
    
    function initGame takes nothing returns nothing
        // init Jaina
        call initJaina()
        call initBattle()
        call InitHeroSelect()
        call registerOnJainaDie(function onJainaDie)
        call registerOnBattleEnd(function onBattleEnd)
        call registerOnSelectDone(function onSelectDone)
    endfunction

    private function initex takes nothing returns nothing
        call DestroyTimer(GetExpiredTimer())
        call initGame()
    endfunction

    private function init takes nothing returns nothing
        call FogMaskEnable(false)
        // call FogEnable(false)
        call TimerStart(CreateTimer(), 0, false, function initex)
    endfunction
endlibrary
