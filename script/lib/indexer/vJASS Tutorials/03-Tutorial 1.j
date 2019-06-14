/*
*	GlobalUnitIndex only has things that work with plain unit indexes. It's goal to be as
*	light as possible while providing a nice API. Be sure to check the documentation in the
*	UnitIndexer trigger to see the rest of the API for GlobalUnitIndex.
*
*	The next type of module is called UnitIndex.
*/

	struct UseUnitIndexer extends array
		implement UnitIndex
	endstruct
	
/*
*	Just like GlobalUnitIndex, it has the two unit index events.
*/

	private method onUnitIndex takes nothing returns boolean
	
	private method onUnitDeindex takes nothing returns nothing
	
/*
*	There is one key difference. onUnitIndex returns a boolean!
*
*	UnitIndex structs are subsets of all unit indexes. The boolean states whether to allocate the unit index
*	for your struct or not.
*
*	onUnitDeindex will only run for units indexed in the struct
*/

	private method onUnitIndex takes nothing returns boolean
		/*
		*	because this always returns false, no unit is ever indexed
		*	for this struct
		*
		*	this means that onUnitDeindex will never run
		*/
		return false
	endmethod