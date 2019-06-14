/*
*	Lab 3 will throw a warning. This is because the first unit isn't indexed but the code
*	tries to access its index.
*
*	If you want to avoid this warning, you can use the following method, which is
*	inherited from UnitIndex
*/

	static method exists takes unit whichUnit returns boolean
	
/*
*	This will determine whether or not a unit is indexed for the struct
*/