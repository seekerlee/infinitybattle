/*
*	By this point you know how to create standalone structs, libraries, and modules that become local
*	to the struct that they are implemented in. The only thing left is to create structs that become
*	local to the structs they register to.
*
*	Example:
*
*		Suppose you have a struct called Hero. Whenever a hero is made, it creates various things
*		for that hero. Suppose one such thing is a military rank.
*
*		Let's say that you want to give all heroes a number of guards based on their rank. This
*		struct would work off of the Hero struct and depend on rank. As this struct depends on the
*		data of Hero in both indexing and deindexing events, Hero should really implement UnitIndexEx.
*
*		We're going to create the above in the next lab!
*
*	When working off of structs, their local events will be used. ON_DEINDEX is static if the struct
*	has no onUnitIndex declared. Structs that implement UnitIndex can be used as well, but they are much
*	more difficult to work with.
*
*	UnitIndex and UnitIndexEx can be identified by the following
*/
		static constant boolean UNIT_INDEX = true
		static constant boolean UNIT_INDEX_EX = true
/*
*	A struct will only ever have one of the above booleans.
*/