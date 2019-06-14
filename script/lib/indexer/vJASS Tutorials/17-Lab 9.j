/*
*	Enable this trigger
*/

/*
*	First, determine what the output will be in the game. Next, run the game to check how you did.
*
*	Remember that deindex events run in reverse.
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
	*	One cool thing about the textmacro is that it automtaically implements
	*	UnitIndexEx
	*/
	implement MyCustomModule
endstruct

struct Initialize extends array
	private static method onInit takes nothing returns nothing
		local unit u
		
		set u = CreateUnit(Player(0), 'hpea', 0, 0, 270)
		call RemoveUnit(u)
		
		set u = CreateUnit(Player(0), 'hkni', 0, 0, 270)
		call RemoveUnit(u)
		
		set u = null
	endmethod
endstruct