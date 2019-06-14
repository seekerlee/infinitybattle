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

struct UnitIndex2 extends array
	private method onUnitIndex takes nothing returns boolean
		return false
	endmethod
	
	private method onUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex2")
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
		if (UnitIndex1.exists(u)) then
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1 Allocated")
		else
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1 Not Allocated")
		endif
		
		if (UnitIndex2.exists(u)) then
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex2 Allocated")
		else
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex2 Not Allocated")
		endif
		
		set UnitIndexer.enabled = true
		
		set UnitIndex1.enabled = false
		set UnitIndex2.enabled = false
		
		call RemoveUnit(u)
		
		set u = CreateUnit(Player(0), 'hpea', 0, 0, 270)
		
		if (UnitIndex1.exists(u)) then
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1 Allocated")
		else
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex1 Not Allocated")
		endif
		
		if (UnitIndex2.exists(u)) then
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex2 Allocated")
		else
			call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, "UnitIndex2 Not Allocated")
		endif
		
		set UnitIndexer.enabled = false
		
		set UnitIndex1.enabled = true
		set UnitIndex2.enabled = true
		
		call RemoveUnit(u)
		
		set UnitIndexer.enabled = true
		
		set u = null
	endmethod
endstruct