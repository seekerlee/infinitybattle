/*
*	There is also a global deindex event
*
*		readonly static Trigger GlobalEvent.ON_DEINDEX
*
*	Global deindex events run after unit specific deindex events
*
*	The reason for the order is as follows
*
*		Global creation events generally set up data for local creation events
*
*		If a combat system is a global creation event, then damage modifiers that work with that combat
*		system would be local. These local events depend on the global event. It is never the other way around.
*		The reason it is impossible the other way around is because a local event may or may not exist. A global
*		event always exists.
*
*		Global destruction generally destroys data that local events rely on. This means that if a global event
*		runs before a local event, that data gets lost. Global events can never rely on the data of local events
*		because that data may or may not exist
*
*		Thus, the order should be as follows for the lifetime of any given event
*
*			Global Create
*			Local Create
*			Local Destroy
*			Global Destroy
*
*		And for UnitIndexer
*
*			ON_INDEX
*			ON_DEINDEX local
*			ON_DEINDEX global
*/

struct UnitIndexGlobal extends array
	private method onUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + ": Global Deindex Event Via Module")
	endmethod
	
	implement UnitIndex
endstruct

struct UnitIndexLocal extends array
	private method onUnitIndex takes nothing returns boolean
		return true
	endmethod
	
	private method onUnitDeindex takes nothing returns nothing
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(unit) + ": Local Deindex Event Via Module")
	endmethod
	
	implement UnitIndex
endstruct

/*
*	The above struct gets registered first, meaning that it's deindex event will run after the below code.
*	Remember that Triggers can be reversed (mentioned in Lab 7). This is the reason why the order is the way it is.
*/
scope CaptureUnitIndexing initializer init
	private function DeindexMahUnit takes nothing returns boolean
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(UnitIndexer.eventUnit) + ": Global Deindex Event Via Function")
	
		return false
	endfunction

	private function init takes nothing returns nothing
		call UnitIndexer.GlobalEvent.ON_DEINDEX.register(Condition(function DeindexMahUnit))
		
		call RemoveUnit(CreateUnit(Player(0), 'hfoo', 0, 0, 270))
		call RemoveUnit(CreateUnit(Player(0), 'hkni', 0, 0, 270))
	endfunction
endscope