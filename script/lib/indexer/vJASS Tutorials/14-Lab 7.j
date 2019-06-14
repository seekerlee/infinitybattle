/*
*	UnitIndexer uses Trigger to handle events, meaning that you can set up entry points
*	to the UnitIndexer indexing events. This is useful to do stages of unit indexing.
*
*	Triggers run before registered code.
*/

scope CaptureUnitIndexing initializer init
	globals
		Trigger customOnIndex
	endglobals
	
	private function DeindexMahUnit takes nothing returns boolean
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(UnitIndexer.eventUnit) + " was deindexed")
	
		return false
	endfunction
	
	private function ThisIsMyOnIndex takes nothing returns boolean
		if (GetUnitTypeId(UnitIndexer.eventUnit) == 'hkni') then
			call UnitIndexer.eventIndex.indexer.Event.ON_DEINDEX.register(Condition(function DeindexMahUnit))
		endif
		
		return false
	endfunction

	private function init takes nothing returns nothing
		/*
		*	false here refers to whether the Trigger should run in reverse or not
		*	reversed triggers are good for things like deindex events
		*/
		set customOnIndex = Trigger.create(false)
		call UnitIndexer.GlobalEvent.ON_INDEX.reference(customOnIndex)
		
		/*
		*	now you can register code to your custom trigger and have it run
		*
		*	this works the same way with deindexing
		*/
		call customOnIndex.register(Condition(function ThisIsMyOnIndex))
		
		call RemoveUnit(CreateUnit(Player(0), 'hfoo', 0, 0, 270))
		call RemoveUnit(CreateUnit(Player(0), 'hkni', 0, 0, 270))
	endfunction
endscope