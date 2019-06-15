library MapConst initializer init
    globals
        unit U_JAINA = null
        constant player P_JAINA = Player(22)
        constant player P_DARK = Player(23)
        //
        rect RCT_BOTTOMLEFT
        rect RCT_BOTTOMRIGHT 
        rect RCT_TOPRIGHT
        rect RCT_TOPLEFT
        rect RCT_BOTTOMCENTER
        rect RCT_TOPCENTER
        rect RCT_CENTERLEFT
        rect RCT_CENTERRIGHT
        rect RCT_CENTERBIG
        // event
        real SHOP1_X
        real SHOP1_Y
        real SHOP2_X
        real SHOP2_Y
        real SHOP3_X
        real SHOP3_Y
        real SHOP4_X
        real SHOP4_Y

    endglobals
    
    private function init takes nothing returns nothing
        set RCT_BOTTOMLEFT = Rect( -3328.0, -3328.0, -2816.0, -2816.0 )
        set RCT_BOTTOMRIGHT = Rect( 2816.0, -3328.0, 3328.0, -2816.0 )
        set RCT_TOPRIGHT = Rect( 2816.0, 2816.0, 3328.0, 3328.0 )
        set RCT_TOPLEFT = Rect( -3328.0, 2816.0, -2816.0, 3328.0 )
        set RCT_BOTTOMCENTER = Rect( -256.0, -3328.0, 256.0, -2816.0 )
        set RCT_TOPCENTER = Rect( -256.0, 2816.0, 256.0, 3328.0 )
        set RCT_CENTERLEFT = Rect( -3328.0, -256.0, -2816.0, 256.0 )
        set RCT_CENTERRIGHT = Rect( 2816.0, -256.0, 3328.0, 256.0 )
        set RCT_CENTERBIG = Rect( -768.0, -768.0, 768.0, 768.0 )
        set SHOP1_X = 0.0
        set SHOP1_Y = GetRectMaxY(RCT_CENTERBIG)
        set SHOP2_X = GetRectMaxX(RCT_CENTERBIG)
        set SHOP2_Y = 0.0
        set SHOP3_X = 0.0
        set SHOP3_Y = GetRectMinY(RCT_CENTERBIG)
        set SHOP4_X = GetRectMinX(RCT_CENTERBIG)
        set SHOP4_Y = 0.0
    endfunction
endlibrary
