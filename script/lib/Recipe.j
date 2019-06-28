
//=======================================================================================================
// Recipe System
// By Fredbrik(Diablo-dk)
// https://www.hiveworkshop.com/threads/recipe-system.103261/
//=======================================================================================================
library Recipe initializer init
    globals
        private integer               udg_RN=0 // Recipe number.
        private boolean               udg_RC=true
        private integer array         udg_itemid1
        private integer array         udg_itemid2
        private integer array         udg_itemid3
        private integer array         udg_itemid4
        private integer array         udg_itemid5
        private integer array         udg_itemid6
        private integer array         udg_ic //item count
        private integer array         udg_output
    endglobals
    //=======================================================================================================
    // User changeable constants
    //=======================================================================================================
    constant function Recipe_Effect takes nothing returns string
        return "Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl" //An effect that comes whenever a recipe is made.
    endfunction

    constant function Recipe_AP takes nothing returns string
        return "origin" //Attachment point for Recipe_Effect()
    endfunction
    //=======================================================================================================
    // This function will return the first item of entered Id in the unit's inventory.
    function GetItem takes unit u, integer Id returns item
        local integer i=0
        local item it
        loop
            exitwhen i==6
            if GetItemTypeId(UnitItemInSlot(u,i)) == Id then
                return UnitItemInSlot(u,i)
            set i=5
            endif
            set i=i+1
        endloop
        return null
    endfunction
    //==============================
    function HasItems takes unit u, integer i returns boolean
        local integer index=0
        local integer id=-1
        local integer b1=0
        local integer b2=0
        local integer b3=0
        local integer b4=0
        local integer b5=0
        local integer b6=0
        loop
            exitwhen index==6
            set id=GetItemTypeId(UnitItemInSlot(u,index))
            if id == 0 then
                set id=-1
            endif
            if id == udg_itemid1[i] and b1 == 0 then
                set b1=1
                set id=-1
            endif
            if id == udg_itemid2[i] and b2 == 0 then
                set b2=1
                set id=-1
            endif
            if id == udg_itemid3[i] and b3 == 0 then
                set b3=1
                set id=-1
            endif
            if id == udg_itemid4[i] and b4 == 0 then
                set b4=1
                set id=-1
            endif
            if id == udg_itemid5[i] and b5 == 0 then
                set b5=1
                set id=-1
            endif
            if id == udg_itemid6[i] and b6 == 0 then
                set b6=1
                set id=-1
            endif
            if b1+b2+b3+b4+b5+b6 == udg_ic[i] then
                return true
            endif
            set index=index+1
        endloop
        return false
    endfunction
    //=======================================================================================================
    // User Functions:
    // Recipe Creating:
    //
    //=======================================================================================================
    private function CreateRecipe takes integer i1,integer i2,integer i3,integer i4,integer i5,integer i6,integer output returns nothing
        set udg_RN=udg_RN+1
        set udg_itemid1[udg_RN]=i1
        set udg_itemid2[udg_RN]=i2
        set udg_ic[udg_RN]=2
        if i3 != 0 then
            set udg_itemid3[udg_RN]=i3
            set udg_ic[udg_RN]=udg_ic[udg_RN]+1
        endif
        if i4 != 0 then
            set udg_itemid4[udg_RN]=i4
            set udg_ic[udg_RN]=udg_ic[udg_RN]+1
        endif
        if i5 != 0 then
            set udg_itemid5[udg_RN]=i5
            set udg_ic[udg_RN]=udg_ic[udg_RN]+1
        endif
        if i6 != 0 then
            set udg_itemid6[udg_RN]=i6
            set udg_ic[udg_RN]=udg_ic[udg_RN]+1
        endif
        set udg_output[udg_RN]=output
    endfunction
    function CreateRecipe2 takes integer i1,integer i2,integer i3 returns nothing
        set udg_RN=udg_RN+1
        set udg_itemid1[udg_RN]=i1
        set udg_itemid2[udg_RN]=i2
        set udg_output[udg_RN]=i3
        set udg_ic[udg_RN]=2
    endfunction

    // Creates a recipe that requires 2 items to combine into a new item. i3 is the combined item.
    // Example: call CreateRecipe2('I000','I001','I002')
    function CreateRecipe3 takes integer i1,integer i2,integer i3,integer i4 returns nothing
        set udg_RN=udg_RN+1
        set udg_itemid1[udg_RN]=i1
        set udg_itemid2[udg_RN]=i2
        set udg_itemid3[udg_RN]=i3
        set udg_output[udg_RN]=i4
        set udg_ic[udg_RN]=3
    endfunction

    // The same as CreateRecipe2 except this requires 3 items to combine. i4 is the combined item.
    function CreateRecipe4 takes integer i1,integer i2,integer i3,integer i4,integer i5 returns nothing
        set udg_RN=udg_RN+1
        set udg_itemid1[udg_RN]=i1
        set udg_itemid2[udg_RN]=i2
        set udg_itemid3[udg_RN]=i3
        set udg_itemid4[udg_RN]=i4
        set udg_output[udg_RN]=i5
        set udg_ic[udg_RN]=4
    endfunction

    // The same as CreateRecipe2 except this requires 4 items to combine. i5 is the combined item.
    function CreateRecipe5 takes integer i1,integer i2,integer i3,integer i4,integer i5,integer i6 returns nothing
        set udg_RN=udg_RN+1
        set udg_itemid1[udg_RN]=i1
        set udg_itemid2[udg_RN]=i2
        set udg_itemid3[udg_RN]=i3
        set udg_itemid4[udg_RN]=i4
        set udg_itemid5[udg_RN]=i5
        set udg_output[udg_RN]=i6
        set udg_ic[udg_RN]=5
    endfunction

    // The same as CreateRecipe2 except this requires 5 items to combine. i6 is the combined item.
    function CreateRecipe6 takes integer i1,integer i2,integer i3,integer i4,integer i5,integer i6,integer i7 returns nothing
        set udg_RN=udg_RN+1
        set udg_itemid1[udg_RN]=i1
        set udg_itemid2[udg_RN]=i2
        set udg_itemid3[udg_RN]=i3
        set udg_itemid4[udg_RN]=i4
        set udg_itemid5[udg_RN]=i5
        set udg_itemid6[udg_RN]=i6
        set udg_output[udg_RN]=i7
        set udg_ic[udg_RN]=6
    endfunction

    // The same as CreateRecipe2 except this requires 6 items to combine. i7 is the combined item.
    //===================================================================================================
    // This function disassembles a recipe item to its original components.

    function DisItem takes unit u,item it returns boolean
        local integer c=GetItemUserData(it)
        local item array newitem
        local integer i=udg_ic[c]
        if it != null then
            if i <= 6-UnitInventoryCount(u)+1 and i > 0 then
                set udg_RC=false
                if udg_itemid2[c] != null then
                    set newitem[1]=CreateItem(udg_itemid1[c],GetUnitX(u),GetUnitY(u))
                    set newitem[2]=CreateItem(udg_itemid2[c],GetUnitX(u),GetUnitY(u))
                    endif
                if udg_itemid3[c] != null then
                    set newitem[3]=CreateItem(udg_itemid3[c],GetUnitX(u),GetUnitY(u))
                    call UnitAddItem(u,newitem[3])
                endif
                if udg_itemid4[c] != null then
                    set newitem[4]=CreateItem(udg_itemid4[c],GetUnitX(u),GetUnitY(u))
                    call UnitAddItem(u,newitem[4])
                endif
                if udg_itemid5[c] != null then
                    set newitem[5]=CreateItem(udg_itemid5[c],GetUnitX(u),GetUnitY(u))
                    call UnitAddItem(u,newitem[5])
                endif
                if udg_itemid6[c] != null then
                    set newitem[6]=CreateItem(udg_itemid6[c],GetUnitX(u),GetUnitY(u))
                    call UnitAddItem(u,newitem[6])
                endif
                call RemoveItem(it)
                call UnitAddItem(u,newitem[1])
                call UnitAddItem(u,newitem[2])

            set newitem[1]=null
            set newitem[2]=null
            set newitem[3]=null
            set newitem[4]=null
            set newitem[5]=null
            set newitem[6]=null
            set udg_RC=true
            else
                return false
            endif
        endif
        return true
    endfunction
    //=======================================================================================================
    //
    //Main Recipe Function: Do not change unless you know what you are doing
    //
    //=======================================================================================================
    private function Recipe_Main takes nothing returns nothing
        local item it
        local integer i=0
        local unit u=GetManipulatingUnit()
        loop
            exitwhen i==udg_RN
            set i=i+1
            if udg_RC == true then
                if udg_ic[i] == 6 then
                    if HasItems(u,i) then
                        call RemoveItem(GetItem(u,udg_itemid1[i]))
                        call RemoveItem(GetItem(u,udg_itemid2[i]))
                        call RemoveItem(GetItem(u,udg_itemid3[i]))
                        call RemoveItem(GetItem(u,udg_itemid4[i]))
                        call RemoveItem(GetItem(u,udg_itemid5[i]))
                        call RemoveItem(GetItem(u,udg_itemid6[i]))
                        call DestroyEffect(AddSpecialEffectTarget(Recipe_Effect(),u,Recipe_AP()))
                        set it=CreateItem(udg_output[i],GetUnitX(u),GetUnitY(u))
                        call SetItemUserData(it,i) //Used for disassembling.
                        call UnitAddItem(u,it)
                        set i=udg_RN
                    endif
                elseif udg_ic[i] == 5 then
                    if HasItems(u,i) then
                        call RemoveItem(GetItem(u,udg_itemid1[i]))
                        call RemoveItem(GetItem(u,udg_itemid2[i]))
                        call RemoveItem(GetItem(u,udg_itemid3[i]))
                        call RemoveItem(GetItem(u,udg_itemid4[i]))
                        call RemoveItem(GetItem(u,udg_itemid5[i]))
                        call DestroyEffect(AddSpecialEffectTarget(Recipe_Effect(),u,Recipe_AP()))
                        set it=CreateItem(udg_output[i],GetUnitX(u),GetUnitY(u))
                        call SetItemUserData(it,i) //Used for disassembling.
                        call UnitAddItem(u,it)
                        set i=udg_RN
                    endif
                elseif udg_ic[i] == 4 then
                    if HasItems(u,i) then
                        call RemoveItem(GetItem(u,udg_itemid1[i]))
                        call RemoveItem(GetItem(u,udg_itemid2[i]))
                        call RemoveItem(GetItem(u,udg_itemid3[i]))
                        call RemoveItem(GetItem(u,udg_itemid4[i]))
                        call DestroyEffect(AddSpecialEffectTarget(Recipe_Effect(),u,Recipe_AP()))
                        set it=CreateItem(udg_output[i],GetUnitX(u),GetUnitY(u))
                        call SetItemUserData(it,i) //Used for disassembling.
                        call UnitAddItem(u,it)
                        set i=udg_RN
                    endif
                elseif udg_ic[i] == 3 then
                    if HasItems(u,i) then
                        call RemoveItem(GetItem(u,udg_itemid1[i]))
                        call RemoveItem(GetItem(u,udg_itemid2[i]))
                        call RemoveItem(GetItem(u,udg_itemid3[i]))
                        call DestroyEffect(AddSpecialEffectTarget(Recipe_Effect(),u,Recipe_AP()))
                        set it=CreateItem(udg_output[i],GetUnitX(u),GetUnitY(u))
                        call SetItemUserData(it,i) //Used for disassembling.
                        call UnitAddItem(u,it)
                        set i=udg_RN
                    endif
                elseif udg_ic[i] == 2 then
                    if HasItems(u,i) then
                        call RemoveItem(GetItem(u,udg_itemid1[i]))
                        call RemoveItem(GetItem(u,udg_itemid2[i]))
                        call DestroyEffect(AddSpecialEffectTarget(Recipe_Effect(),u,Recipe_AP()))
                        set it=CreateItem(udg_output[i],GetUnitX(u),GetUnitY(u))
                        call SetItemUserData(it,i) //Used for disassembling.
                        call UnitAddItem(u,it)
                        set i=udg_RN
                    endif
                endif
            endif
        endloop
        set it=null
        set u=null
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        set udg_RC=true
        call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_PICKUP_ITEM )
        call TriggerAddAction(t, function Recipe_Main)
        set t = null
    endfunction
endlibrary



//call this at map init.