/*
*	The correct events ran and they were in the correct order
*
*		index struct
*		index module
*		deindex module
*		deindex struct
*
*	UnitIndex does not have local events? The module is running independently from the struct.
*	The module gets registered after the struct.
*
*		Register Struct Index
*		Register Module Index
*		Register Struct Deindex
*		Register Module Deindex
*
*	Remember that the deindex trigger is reversed.
*
*	How did the module run the correct events? It conditionally ran/registered events by checking
*	isUnitIndexed, which if you recall, is the set of all indexes for the struct, not the system.
*
*	If both UnitIndex and UnitIndexEx give the same output, why use UnitIndexEx at all?
*
*	UnitIndexEx has local events (the triggers). This means that if you disable your struct, you disable
*	all structs that go through it. UnitIndex does not have this advantage.
*
*	Modules that work off of UnitIndex will register their ON_INDEX events globally to the system. This means
*	that they will always run, whether or not the unit made it through the filter or your struct was even enabled.
*	Remember, they are not dependent on the struct when using UnitIndex, rather they just check to see if the struct
*	let the unit through or not and mimic that. When using UnitIndexEx, they actually depend on the struct.
*
*	UnitIndexEx was originally made because Trigger didn't have a reverse flag, meaning that the order of the
*	events was wrong when using UnitIndex.
*
*		index struct
*		index module
*		deindex struct
*		deindex module
*
*	Since the reverse flag came about, it's safe to use either UnitIndex or UnitIndexEx. Just remember that UnitIndex makes
*	modules and other structs run in parallel with it and UnitIndexEx makes modules and other structs run through it. UnitIndex
*	makes everyone else have to mimic your struct. UnitIndexEx makes your struct a gateway that lets other structs through.
*/