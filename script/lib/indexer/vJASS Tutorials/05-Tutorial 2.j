/*
*	onUnitIndex and onUnitDeindex are both optional.
*
*	Depending on what is implemented, the UnitIndex struct has a different behavior
*
*	If onUnitIndex is implemented, it has standard behavior.
*
*	If it isn't implemented, then all indexed units are allocated for the struct.
*
*	To determine whether a unit is allocated for a struct or not, isUnitIndexed is used
*
*	Be sure to check the documentation to see the differences in wording between GlobalUnitIndex's isUnitIndexed
*	and UnitIndex's isUnitIndexed
*/

	readonly boolean isUnitIndexed