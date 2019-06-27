library SharedBounty initializer init requires RegisterPlayerUnitEvent, GroupUtils, TextTag

    globals
        private constant real BOUNTY_RANGE = 1200.0
        private boolean array shouldReward
    endglobals

    private function clearArray takes nothing returns nothing
        local integer i = 0
        loop
            set shouldReward[i] = false
            set i = i + 1
            exitwhen i == bj_MAX_PLAYERS
        endloop
    endfunction

    function CalculateBounty takes unit u returns integer
        local integer lvl = GetUnitLevel(u)
        if IsUnitType(u, UNIT_TYPE_HERO) then
            return R2I(10.0 * (SquareRoot(BlzGetUnitMaxHP(u)) + SquareRoot(BlzGetUnitMaxMana(u))) + GetRandomInt(-30, 30))
        else
            return 50 + 20 * lvl + GetRandomInt(-30, 30)
        endif
    endfunction

    private function payBounty takes player p, unit dyingU, integer gold, integer lumber returns nothing
        // call BJDebugMsg("pay: " + I2S(gold))
        if gold > 0 then
            call GoldBounty(dyingU, gold, p)
            call SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) + gold)
        endif
        if lumber > 0 then
            call LumberBounty(dyingU, lumber, p)
            call SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER) + lumber)
        endif
    endfunction

    private function heroEnum takes nothing returns boolean
        return IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) and not IsUnitAlly(GetDyingUnit(), GetOwningPlayer(GetFilterUnit()))
    endfunction

    private function Action takes nothing returns boolean
        local integer bounty
        local integer bountyCount = 1
        local integer size
        local integer i = 0
        local integer playId
        local unit u = GetDyingUnit()
        if not IsUnitAlly( GetKillingUnit(), GetOwningPlayer(u) ) then
            set bounty = CalculateBounty(u)
            call GroupEnumUnitsInRange(ENUM_GROUP, GetUnitX(u), GetUnitY(u), BOUNTY_RANGE, Filter(function heroEnum))
            set size = BlzGroupGetSize(ENUM_GROUP)

            set shouldReward[GetPlayerId(GetOwningPlayer(GetKillingUnit()))] = true
            loop
                exitwhen i == size
                set playId = GetPlayerId(GetOwningPlayer(BlzGroupUnitAt(ENUM_GROUP, i)))
                if not shouldReward[playId] then
                    set shouldReward[playId] = true
                    set bountyCount = bountyCount + 1
                endif
                set i = i + 1
            endloop
            call GroupClear(ENUM_GROUP)
            set i = 0
            loop
                if shouldReward[i] then
                    call payBounty(Player(i), u, bounty / bountyCount, 0)
                endif
                set i = i + 1
                exitwhen i == bj_MAX_PLAYERS
            endloop
            call clearArray()
        endif
        set u = null
        return false
    endfunction

    private function init takes nothing returns nothing
        call clearArray()
        call RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_DEATH, function Action)
    endfunction
endlibrary
