//TESH.scrollpos=9
//TESH.alwaysfold=0
/*
*	When UnitIndexEx is implemented in the module. An error will be thrown if UnitIndex was already
*	implemented.
*/

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
	
	implement UnitIndexEx
	//! runtextmacro CREATE_LOCAL_UNIT_INDEX()
endmodule

struct UnitIndex1 extends array
	private method onUnitIndex takes nothing returns boolean
		if (GetUnitTypeId(unit) != 'hkni') then
			return false
		endif
		
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + " was indexed for thistype (struct)")
		
		return true
	endmethod

	private method onUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + " was deindexed for thistype (struct)")
	endmethod
	
	/*
	*	Forcefully implement UnitIndex
	*/
	implement UnitIndex
	implement MyCustomModule
endstruct

struct Initialize extends array
	private static method onInit takes nothing returns nothing
		local unit u
		
		set UnitIndex1.enabled = false
		set u = CreateUnit(Player(0), 'hkni', 0, 0, 270)
		set UnitIndex1.enabled = true
		call RemoveUnit(u)
		
		set u = CreateUnit(Player(0), 'hkni', 0, 0, 270)
		call RemoveUnit(u)
		
		set u = CreateUnit(Player(0), 'hfoo', 0, 0, 270)
		call RemoveUnit(u)
		
		set u = null
	endmethod
endstruct