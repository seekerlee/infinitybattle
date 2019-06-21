library Shopping requires MapConst, TimerUtils

    globals
        private unit shopTop
        private unit shopRight
        private unit shopBottom
        private unit shopLeft

        private constant integer ID_SHOPTOP = 'ngme'
        private constant integer ID_SHOPRIGHT = 'ngme'
        private constant integer ID_SHOPBOTTOM = 'ngme'
        private constant integer ID_SHOPLEFT = 'ngme'

        private real shoppingTime = 10.0

        private trigger tShoppingEnd
    endglobals

    private function showShops takes boolean show returns nothing
        call ShowUnit(shopTop, show)
        call ShowUnit(shopRight, show)
        call ShowUnit(shopBottom, show)
        call ShowUnit(shopLeft, show)
    endfunction

    function initShopping takes nothing returns nothing
        set tShoppingEnd = CreateTrigger()
        // body
        set shopTop = CreateUnit(P_JAINA, ID_SHOPTOP, SHOP1_X, SHOP1_Y, 0.0)
        set shopRight = CreateUnit(P_JAINA, ID_SHOPTOP, SHOP2_X, SHOP2_Y, 0.0)
        set shopBottom = CreateUnit(P_JAINA, ID_SHOPTOP, SHOP3_X, SHOP3_Y, 0.0)
        set shopLeft = CreateUnit(P_JAINA, ID_SHOPTOP, SHOP4_X, SHOP4_Y, 0.0)
        call showShops(false)
    endfunction

    private function endShopping takes nothing returns nothing
        call showShops(false)
        call TriggerEvaluate(tShoppingEnd)
    endfunction

    private function tEndShopping takes nothing returns nothing
        call endShopping()
        call ReleaseTimer(GetExpiredTimer())
    endfunction

    function startShopping takes nothing returns nothing
        local timer tm = NewTimer()
        call TimerStart(tm, shoppingTime, false, function tEndShopping)
        call BJDebugMsg("shopping time")
        call showShops(true)

        set tm = null
        // create shops
    endfunction
    
    function registerOnShoppingEnd takes code func returns nothing
        call TriggerAddCondition(tShoppingEnd, Condition(func))
    endfunction
endlibrary
