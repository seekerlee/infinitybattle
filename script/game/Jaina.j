library Jaina initializer init requires Table, WorldBounds
    globals
        private unit U_JAINA = null
        private integer ID_JAINA = 'Jain'
        private player P_JAINA = Player(22)
    endglobals
    
    private function init takes nothing returns nothing
        // create jaina in center
        // takes player id, integer unitid, real x, real y, real face returns unit
        set U_JAINA = CreateUnit(P_JAINA, ID_JAINA, WorldBounds.centerX, WorldBounds.centerY, 0.0)
    endfunction
endlibrary
