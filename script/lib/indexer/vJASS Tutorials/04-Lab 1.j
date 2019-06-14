/*
*	Enable this trigger
*/

/*
*	First, determine what the output will be in the game. Next, run the game to check how you did.
*/

struct UnitIndex1 extends array
	private method onUnitIndex takes nothing returns boolean
		return false
	endmethod
	
	private method onUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1")
	endmethod
	
	implement UnitIndex
endstruct

struct UnitIndex2 extends array
	private method onUnitIndex takes nothing returns boolean
		return true
	endmethod
	
	private method onUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex2")
	endmethod
	
	implement UnitIndex
endstruct

struct Initialize extends array
	private static method onInit takes nothing returns nothing
		call RemoveUnit(CreateUnit(Player(0), 'hpea', 0, 0, 270))
	endmethod
endstruct