/*
*	Enable this trigger
*/

/*
*	First, determine what the output will be in the game. Next, run the game to check how you did.
*/

module MyCustomModule
	private method onLocalUnitIndex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + " was indexed for thistype (module)")
	endmethod
	
	private method onLocalUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + " was deindexed for thistype (module)")
	endmethod
	
	//! runtextmacro CREATE_LOCAL_UNIT_INDEX()
endmodule

struct UnitIndex1 extends array
	private method onUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + " was deindexed for thistype (struct)")
	endmethod
	
	implement MyCustomModule
endstruct

struct Initialize extends array
	private static method onInit takes nothing returns nothing
		local unit u
		
		set UnitIndex1.enabled = false
		set u = CreateUnit(Player(0), 'hfoo', 0, 0, 270)
		set UnitIndex1.enabled = true
		call RemoveUnit(u)
		
		set u = CreateUnit(Player(0), 'hkni', 0, 0, 270)
		call RemoveUnit(u)
		
		set u = null
	endmethod
endstruct