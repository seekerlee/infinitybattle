/*
*	enabled controls whether UnitIndexer is enabled or not. This only controls
*	onUnitIndex. onUnitDeindex will always run given onUnitIndex returned true.
*	If onUnitIndex isn't declared, onUnitDeindex always runs.
*
*	if enabled is false, onUnitIndex will not run and units will not be indexed.
*	However, this is only true if onUnitIndex exists. If it does not exist, the
*	struct can't be disabled.
*
*	This was done for efficiency purposes. If you want to be able to disable the
*	struct but don't want onUnitIndex, then just do
*
*		private method onUnitIndex takes nothing returns boolean
*			return true
*		endmethod
*
*	This is inherited from UnitIndexer (see API).
*/

	static boolean enabled