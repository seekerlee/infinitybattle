/*
*	The UnitIndex module is for standalone structs. These structs don't play nicely with
*	other resources, like Unit Event. They are good if you don't plan on using any other
*	resources in them that rely on local indexing events.
*
*	UnitIndexEx provides local indexing events for a struct.
*/
		readonly static Trigger ON_INDEX
		
		readonly Trigger ON_DEINDEX	
		readonly static Trigger ON_DEINDEX
/*
*	While these events exist, it is not recommend that you use them directly because the resulting code is
*	relatively complex and is always the same for any given module. As such, UnitIndexer has a textmacro
*	that you can use.
*
*/
		//! textmacro CREATE_LOCAL_UNIT_INDEX
/*
*	This textmacro works both with UnitIndex and UnitIndexEx. The reason for both of these modules will be
*	covered later. The events won't be covered in until later.
*
*	The textmacro is meant to be implemented in custom user modules that latch on to local UnitIndex events.
*
*	Rather than onUnitIndex and onUnitDeindex, the macro provides
*/
		private method onLocalUnitIndex takes nothing returns nothing
		private method onLocalUnitDeindex takes nothing returns nothing
/*
*	The reason onLocalUnitIndex does not return a boolean is because only the struct can filter indexes.
*	The most you can do is listen in.
*
*	Besides this, a method is also provided to replace onInit. The macro depends on onInit. As such, you can't
*	use it in your modules.
*/
		private static method localInit takes nothing returns nothing
/*
*	A full example of using the macro. The methods are all optional as usual.
*/

	module MyCustomModule
		private method onLocalUnitIndex takes nothing returns nothing
		endmethod
		
		private method onLocalUnitDeindex takes nothing returns nothing
		endmethod
		
		private static method localInit takes nothing returns nothing
		endmethod
	
		//! runtextmacro CREATE_LOCAL_UNIT_INDEX()
	endmodule
/*
*	The thing to really keep in mind is that these events are local to the struct. If a unit gets indexed
*	but doesn't make it through the struct's filter, these will never run.
*/