//TESH.scrollpos=9
//TESH.alwaysfold=0
/*
*	this is a module that sets the hero level/rank to something random
*
*	this is not a good example of a module
*
*	think of a big resource like UnitEvent for a good example
*/
module RandomHeroLevel
	private method onLocalUnitIndex takes nothing returns nothing
		local integer level = GetRandomInt(1, 10)
		
		if (level > 1) then
			call SetHeroLevel(unit, level, false)
			
			set rank = GetHeroLevel(unit)
		endif
	endmethod
	
	//! runtextmacro CREATE_LOCAL_UNIT_INDEX()
endmodule

/*
*	hero is the hero
*/
struct Hero extends array
	integer rank

	private method onUnitIndex takes nothing returns boolean
		if (not IsUnitType(unit, UNIT_TYPE_HERO)) then
			return false
		endif
		
		set rank = 1
		
		return true
	endmethod

	implement RandomHeroLevel
endstruct

/*
*	This manages the guards
*/
struct HeroGuard extends array
	private static boolexpr onUnitDeindexExpr
	
	private group guards

	private static method onUnitIndex takes nothing returns boolean
		local thistype this = UnitIndexer.eventIndex
		local integer i
	
		call Hero(this).ON_DEINDEX.register(onUnitDeindexExpr)
		
		set guards = CreateGroup()
		
		set i = Hero(this).rank
		loop
			exitwhen 0 == i
			
			call GroupAddUnit(guards, CreateUnit(GetOwningPlayer(UnitIndexer.eventUnit), 'hfoo', GetUnitX(UnitIndexer.eventUnit), GetUnitY(UnitIndexer.eventUnit), 270))
			
			set i = i - 1
		endloop
	
		return false
	endmethod
	
	/*
	*	don't have to unregister because it's UnitIndexEx
	*	the local event will be destroyed
	*/
	private static method onUnitDeindex takes nothing returns boolean
		local thistype this = UnitIndexer.eventIndex
		local unit guard
		
		loop
			set guard = FirstOfGroup(guards)
			exitwhen guard == null
			
			call GroupRemoveUnit(guards, guard)
			call KillUnit(guard)
		endloop
		
		call DestroyGroup(guards)
		
		set guards = null
	
		return false
	endmethod

	/*
	*	I don't do static ON_DEINDEX here because it doesn't make sense to do so
	*	with the Hero struct. The Hero struct should only ever index heroes, so it
	*	doesn't make sense to expect it not to have a filter.
	*/
	private static method init takes nothing returns nothing
		set onUnitDeindexExpr = Condition(function thistype.onUnitDeindex)
	
		call Hero.ON_INDEX.register(Condition(function thistype.onUnitIndex))
	endmethod

	implement Init
endstruct

/*
*	Heroes are awesome, so if they are ever selected, we're going to remove them
*/
struct RemoveHero extends array
	static if not Hero.UNIT_INDEX_EX then
		private static method error takes nothing returns nothing
			Hero needs to implement UNIT_INDEX_EX
		endmethod
	else
		private static boolexpr onUnitDeindexExpr
		private static boolexpr onUnitSelectExpr
		private trigger onSelect
		
		private static method onUnitSelect takes nothing returns boolean
			call RemoveUnit(GetTriggerUnit())
			
			return false
		endmethod
		
		private static method onUnitIndex takes nothing returns boolean
			local thistype this = UnitIndexer.eventIndex
			
			call Hero(this).ON_DEINDEX.register(onUnitDeindexExpr)
			
			set onSelect = CreateTrigger()
			call TriggerAddCondition(onSelect, onUnitSelectExpr)
			call TriggerRegisterUnitEvent(onSelect, UnitIndexer.eventUnit, EVENT_UNIT_SELECTED)
			
			return false
		endmethod
		
		private static method onUnitDeindex takes nothing returns boolean
			local thistype this = UnitIndexer.eventIndex
			
			call DestroyTrigger(onSelect)
			set onSelect = null
		
			return false
		endmethod
	
		private static method init takes nothing returns nothing
			set onUnitDeindexExpr = Condition(function thistype.onUnitDeindex)
			set onUnitSelectExpr = Condition(function thistype.onUnitSelect)
			
			call Hero.ON_INDEX.register(Condition(function thistype.onUnitIndex))
		endmethod
	
		implement Init
	endif
endstruct

/*
*	for lulz
*
*	this can't work with modules or other structs because it is
*	using GlobalUnitIndex
*/
struct MountainKing extends array
	private method onUnitIndex takes nothing returns nothing
		if (GetUnitTypeId(unit) != 'Hmkg') then
			return
		endif
		
		call SetUnitScale(unit, 2, 2, 2)
	endmethod

	implement GlobalUnitIndex
endstruct

/*
*	we're going to give non-hero units something
*/
struct Colorz extends array
	private method onUnitIndex takes nothing returns nothing
		if (Hero(this).isUnitIndexed) then
			return
		endif
		
		call SetUnitVertexColor(unit, GetRandomInt(0, 255), GetRandomInt(0, 255), GetRandomInt(0, 255), 255)
	endmethod

	implement GlobalUnitIndex
endstruct

/*
*	Create the units
*/
struct Initialize extends array
	private static method onInit takes nothing returns nothing
		local unit u
		
		set u = CreateUnit(Player(0), 'hkni', -200, 0, 270)
		
		set u = CreateUnit(Player(0), 'Hpal', 0, 0, 270)
		
		set u = CreateUnit(Player(0), 'Hmkg', 0, 400, 270)
		
		/*
		*	the following is a hero, but we're not going to make it
		*	a Hero
		*/
		set Hero.enabled = false
		set u = CreateUnit(Player(0), 'Hmkg', 200, 0, 270)
		set Hero.enabled = true
		
		set u = null
	endmethod
endstruct