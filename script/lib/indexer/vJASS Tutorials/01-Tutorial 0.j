/*
*	Unit Indexer is best used with structs
*
*	To use Unit Indexer, just implement the module at the bottom of your struct
*
*	This will convert your struct into a global UnitIndex.
*/
/*
*	Unit Indexer is best used with structs
*
*	To use Unit Indexer, just implement the module at the bottom of your struct
*
*	This will convert your struct into a global UnitIndex. It will also inherit from UnitIndexer.
*
*	A global unit index is a unit index that is from the set of all unit indexes
*/

	struct UseUnitIndexer extends array
		implement GlobalUnitIndex
	endstruct
	
/*
*	There are two unit index events. When the methods are declared in your struct, they
*	will be called.
*/

	private method onUnitIndex takes nothing returns nothing
	
	private method onUnitDeindex takes nothing returns nothing
	
/*
*	onUnitIndex is called whenever any unit is indexed
*
*	onUnitDeindex is called whenever any unit is deindexed
*/