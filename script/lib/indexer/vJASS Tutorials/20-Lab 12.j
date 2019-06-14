/*
*	The output, except for the order of messages on Lab 10, should have been rather straight forward.
*
*	Just like before, there were local and global events. If onUnitIndex did not exist, the the struct
*	had only global index events. As a result, the module also had global events.
*
*	When onUnitIndex did exist, then the module had local events. Even when onLocalUnitIndex was removed, the module
*	still had local events.
*
*	What happens when UnitIndex is used instead of UnitIndexEx?
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