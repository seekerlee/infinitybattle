/*
*	isDeindexing tells whether the unit is currently in the process of being deindexed or
*	not. A unit is deindexing when the undefend ability that unit indexer relies on to catch
*	indexing is 0 and the unit is currently indexed.
*
*	This will always return true in the onUnitDeindexed method.
*/

	static method isDeindexing takes unit whichUnit returns boolean
	
/*
*	Given a unit index, that index can be converted back into a unit via the unit field (lab 0)
*/

	readonly unit unit