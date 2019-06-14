/*
*	Enable this trigger
*/

/*
*	First, determine what the output will be in the game. Next, run the game to check how you did.
*/

struct UnitIndex1 extends array
	private method onUnitDeindex takes nothing returns nothing
		if (isDeindexing(unit)) then
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + " is being deindexed")
		else
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + " is not being deindexed")
		endif
	endmethod
	
	implement UnitIndex
endstruct

struct Initialize extends array
	private static method onInit takes nothing returns nothing
		call RemoveUnit(CreateUnit(Player(0), 'hpea', 0, 0, 270))
	endmethod
endstruct