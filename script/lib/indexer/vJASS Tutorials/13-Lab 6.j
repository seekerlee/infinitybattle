/*
*	The module does not have to be used in order to capture unit index events
*/

scope CaptureUnitIndexing initializer init
	private function DeindexMahUnit takes nothing returns boolean
		call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60000, GetUnitName(UnitIndexer.eventUnit) + " was deindexed")
	
		return false
	endfunction
	
	private function ThisIsMyOnIndex takes nothing returns boolean
		/*
		*	the unit deindex event is unit specific, so it needs
		*	to be registered for each unit
		*/
		
		/*
		*	UnitIndexer provides two fields that give access to the
		*	unit being acted upon
		*
		*		static readonly thistype eventIndex
		*			-	the indexed unit's index
		*
		*		static readonly unit eventUnit
		*			-	the indexed unit
		*/
		
		/*
		*	only capture knights
		*/
		if (GetUnitTypeId(UnitIndexer.eventUnit) == 'hkni') then
			/*
			*	each UnitIndex has its own Indexer. Use these to get to the unit specific events.
			*/
			call UnitIndexer.eventIndex.indexer.Event.ON_DEINDEX.register(Condition(function DeindexMahUnit))
		endif
		
		return false
	endfunction

	private function init takes nothing returns nothing
		/*
		*	this will register ThisIsMyOnIndex to UnitIndexer ON_INDEX event
		*
		*	this captures all unit index events
		*/
		call UnitIndexer.GlobalEvent.ON_INDEX.register(Condition(function ThisIsMyOnIndex))
		
		call RemoveUnit(CreateUnit(Player(0), 'hfoo', 0, 0, 270))
		call RemoveUnit(CreateUnit(Player(0), 'hkni', 0, 0, 270))
	endfunction
endscope