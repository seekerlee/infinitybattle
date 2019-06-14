/*
*	Enable this trigger
*/

/*
*	First, determine what the output will be in the game. Next, run the game to check how you did.
*/

struct UnitIndex1 extends array
	private method onUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1")
	endmethod
	
	implement UnitIndex
endstruct

struct Initialize extends array
	private static method onInit takes nothing returns nothing
		local unit u
		
		set UnitIndexer.enabled = false
		
		set u = CreateUnit(Player(0), 'hpea', 0, 0, 270)
		
		/*
		*	Note that [] converts a unit into a unit index
		*/
		if (UnitIndex1[u].isUnitIndexed) then
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1 Allocated")
		else
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1 Not Allocated")
		endif
		
		set UnitIndexer.enabled = true
		
		call RemoveUnit(u)
		
		set u = CreateUnit(Player(0), 'hpea', 0, 0, 270)
		
		if (UnitIndex1[u].isUnitIndexed) then
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1 Allocated")
		else
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1 Not Allocated")
		endif
		
		set UnitIndexer.enabled = false
		
		call RemoveUnit(u)
		
		set UnitIndexer.enabled = true
		
		set u = null
	endmethod
endstruct