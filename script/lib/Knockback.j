library Knockback initializer Init
// https://www.hiveworkshop.com/threads/knockback-unit.35545/
// **************************************************************************
// **                                                                      **
// ** Knockback(Ex)                                                        **
// ** —————————————                                                        **
// **                                                                      **
// ** A function made for efficient knockbacking                           **
// **                                                                      **
// ** By: Silvenon                                                         **
// **                                                                      **
// **************************************************************************

//=======================================//
//Credits to PitzerMike for this function//
//=======================================//

globals
    private constant integer DUMMY_ID = 'e000'
endglobals

private function TreeFilter takes nothing returns boolean
    local destructable d = GetFilterDestructable()
    local boolean i = IsDestructableInvulnerable(d)
    local unit u = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), DUMMY_ID, GetWidgetX(d), GetWidgetY(d), 0)
    local boolean result = false

    call UnitAddAbility(u, 'Ahrl')

    if i then
        call SetDestructableInvulnerable(d, false)
    endif

    set result = IssueTargetOrder(u, "harvest", d)
    call RemoveUnit(u)

    if i then
      call SetDestructableInvulnerable(d, true)
    endif

    set u = null
    set d = null
    return result
endfunction

//===========================================================================

globals
    private timer Tim = CreateTimer()
    private integer Total = 0
    private boolexpr Cond = null

    private integer array Ar
    private boolean array BoolAr

    private real MAX_X
    private real MAX_Y
    private real MIN_X
    private real MIN_Y
endglobals

private constant function Interval takes nothing returns real
    return 0.04
endfunction

private function KillTree takes nothing returns nothing
    if BoolAr[0] then
        call KillDestructable(GetEnumDestructable())
    else
        set BoolAr[1] = true
    endif
endfunction

public struct Data
    unit u
    real d1
    real d2

    real sin
    real cos

    real r

    string s = ""
    effect e = null
    
    static method create takes unit u, integer q, real d, real a, real r, integer t, string s, string p returns Data
        local Data dat = Data.allocate()

        set dat.u = u
        set dat.d1 = 2 * d / (q + 1)
        set dat.d2 = dat.d1 / q

        set dat.sin = Sin(a)
        set dat.cos = Cos(a)

        set dat.r = r

        if s != "" and s != null then
            if t == 2 then
                if p != "" and p != null then
                    set dat.e = AddSpecialEffectTarget(s, u, p)
                else
                    set dat.e = AddSpecialEffectTarget(s, u, "chest")
                endif
            elseif t == 1 then
                set dat.s = s
            endif
        endif

        call SetUnitPosition(u, GetUnitX(u), GetUnitY(u))
        // call PauseUnit(u, true) // modified

        if Total == 0 then
            call TimerStart(Tim, Interval(), true, function Data.Execute)
        endif

        set Total = Total + 1
        set Ar[Total - 1] = dat

        return dat
    endmethod
    
    static method Execute takes nothing returns nothing
        local Data dat
        local integer i = 0
        local real x
        local real y
        local rect r
        local real rad
        
        loop
            exitwhen i >= Total
            set dat = Ar[i]
            
            if dat.s != "" and dat.s != null then
                set x = GetUnitX(dat.u)
                set y = GetUnitY(dat.u)
                
                call DestroyEffect(AddSpecialEffect(dat.s, x, y))
                
                set x = x + dat.d1 * dat.cos
                set y = y + dat.d1 * dat.sin
            else
                set x = GetUnitX(dat.u) + dat.d1 * dat.cos
                set y = GetUnitY(dat.u) + dat.d1 * dat.sin
            endif
            
            if dat.r != 0 then
                set BoolAr[0] = dat.r > 0
                
                set rad = dat.r
                
                if not BoolAr[0] then
                    set rad = rad * (-1)
                endif
                
                set r = Rect(x - rad, y - rad, x + rad, y + rad)

                call EnumDestructablesInRect(r, Cond, function KillTree)
                call RemoveRect(r)
                
                set r = null
            endif
            
            if (x < MAX_X and y < MAX_Y and x > MIN_X and y > MIN_Y) and not BoolAr[1] then
                call SetUnitX(dat.u, x)
                call SetUnitY(dat.u, y)
            endif
            
            set dat.d1 = dat.d1 - dat.d2
            
            if dat.d1 <= 0 or (x > MAX_X or y > MAX_Y or x < MIN_X or y < MIN_Y) or BoolAr[1] then
                set Ar[i] = Ar[Total - 1]
                set Total = Total - 1
                
                call dat.destroy()
            endif
            
            set i = i + 1
        endloop
        
        if Total == 0 then
            call PauseTimer(Tim)
        endif
    endmethod
    
    method onDestroy takes nothing returns nothing
        if .e != null then
            call DestroyEffect(.e)
        endif

        // call PauseUnit(.u, false)

        set BoolAr[0] = false
        set BoolAr[1] = false
    endmethod
endstruct

function KnockbackEx takes unit u, real d, real a, real w, real r, integer t, string s, string p returns nothing
    call Data.create(u, R2I(w / Interval()), d, a, r, t, s, p)
endfunction

function Knockback takes unit u, real d, real a, real w returns nothing
    call Data.create(u, R2I(w / Interval()), d, a, 0, 0, "", "")
endfunction

private function Init takes nothing returns nothing
    set Cond = Filter(function TreeFilter)

    set BoolAr[0] = false
    set BoolAr[1] = false

    set MAX_X = GetRectMaxX(bj_mapInitialPlayableArea) - 64
    set MAX_Y = GetRectMaxY(bj_mapInitialPlayableArea) - 64
    set MIN_X = GetRectMinX(bj_mapInitialPlayableArea) + 64
    set MIN_Y = GetRectMinY(bj_mapInitialPlayableArea) + 64
endfunction

endlibrary