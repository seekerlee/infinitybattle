library ChatCommands initializer Init

    globals
        private group selectedUnits         = CreateGroup()
        private string attachmentPath       = ""
        private string lastCommand          = ""
        private player newOwner             = null
        private hashtable hash              = InitHashtable()
        private hashtable defines           = InitHashtable()
        private constant integer ANIM       = 1
        private constant integer TAG        = 2
        private constant integer ATTACHMENT = 3
        private constant integer POINT      = 4
        private constant string  WARNING    = "|cffff0000WARNING:|r "
        private constant string  HIGHLIGHT  = "|cffffcc00"
    endglobals
    
    private struct Attachment 
        effect model
        string point 
        thistype next
        
        static method create takes unit target, string path, string point, thistype next returns thistype
            local thistype this = thistype.allocate()
            set this.model      = AddSpecialEffectTarget(path, target, point)
            set this.point      = point
            set this.next       = next
            
            return this
        endmethod
        
        method onDestroy takes nothing returns nothing
            call DestroyEffect(model)
        endmethod
    endstruct
    
    private function EnumAddTag takes nothing returns nothing
        local string tag = LoadStr(hash, TAG, 0)
        local integer handleid = GetHandleId(GetEnumUnit())
        local boolean add = true
        
        if tag == null then
            return
        endif
        
        if HaveSavedBoolean(hash, handleid, StringHash(tag)) then
            set add = not LoadBoolean(hash, handleid, StringHash(tag))
        endif
        call SaveBoolean(hash, handleid, StringHash(tag), add)
        
        call AddUnitAnimationProperties(GetEnumUnit(), tag, add)
        
        set tag = null
    endfunction
    
    private function EnumSetAnim takes nothing returns nothing
        local integer i = 0
        
        loop
            exitwhen not HaveSavedString(hash, ANIM, i)
            if i == 0 then
                call SetUnitAnimation(GetEnumUnit(), LoadStr(hash, ANIM, i))
            else
                call QueueUnitAnimation(GetEnumUnit(), LoadStr(hash, ANIM, i))
            endif
            set i = i+1
        endloop
    endfunction
    
    private function EnumSetAnimIndex takes nothing returns nothing
        local integer anim = LoadInteger(hash, ANIM, 0)
        
        if anim < 0 then
            return 
        endif
        
        call SetUnitAnimationByIndex(GetEnumUnit(), anim)
    endfunction
    
    private function EnumClearAttachments takes nothing returns nothing
        local Attachment current = 0
        local Attachment next
        local integer handleid = GetHandleId(GetEnumUnit())
        
        if HaveSavedInteger(hash, handleid, ATTACHMENT) then
            set current = LoadInteger(hash, handleid, ATTACHMENT)
        endif
        
        loop
            exitwhen current == 0
            set next = current.next
            
            call current.destroy()
            
            set current = next
        endloop
        call RemoveSavedInteger(hash, handleid, ATTACHMENT)
    endfunction
    
    private function UnitRemoveAttachment takes unit whichunit, string remove returns nothing
        local Attachment current = 0
        local Attachment next
        local Attachment prev = 0
        local Attachment first
        local integer handleid = GetHandleId(whichunit)
        
        if HaveSavedInteger(hash, handleid, ATTACHMENT) then
            set first = LoadInteger(hash, handleid, ATTACHMENT)
            set current = first
        endif
        
        loop
            exitwhen current == 0
            set next = current.next
            
            if current.point == remove then
                if current == first then
                    set first = current.next
                endif
                if prev != 0 then
                    set prev.next = next
                endif
                call current.destroy()
            else
                set prev = current
            endif
            
            set current = next
        endloop
        
        call SaveInteger(hash, handleid, ATTACHMENT, first)
    endfunction
    
    private function EnumRemoveAttachment takes nothing returns nothing
        local integer handleid = GetHandleId(GetEnumUnit())
        local integer i = 0
        
        if not HaveSavedString(hash, POINT, 0) then
            call BJDebugMsg(WARNING+"You must specify an attachment point!")
            return
        endif
        
        loop
            exitwhen not HaveSavedString(hash, POINT, i)
            call UnitRemoveAttachment(GetEnumUnit(), LoadStr(hash, POINT, i))
            set i = i+1
        endloop
    endfunction
    
    private function EnumAddAttachment takes nothing returns nothing
        local string path = LoadStr(hash, ATTACHMENT, 0)
        local string point
        local integer handleid = GetHandleId(GetEnumUnit())
        local integer i = 0
        local Attachment attachment = 0
        
        if path == null then
            call BJDebugMsg(WARNING+"You must specify a model path!")
            return
        elseif not HaveSavedString(hash, POINT, 0) then
            call BJDebugMsg(WARNING+"You must specify an attachment point using the 'to' keyword!")
            return
        endif
        
        if HaveSavedInteger(hash, handleid, ATTACHMENT) then
            set attachment = LoadInteger(hash, handleid, ATTACHMENT)
        endif
        
        loop
            exitwhen not HaveSavedString(hash, POINT, i)
            set point = LoadStr(hash, POINT, i)
            set attachment = Attachment.create(GetEnumUnit(), attachmentPath+path, point, attachment)
            set i = i+1
        endloop
        
        call SaveInteger(hash, handleid, ATTACHMENT, attachment)
        
        set path = null
        set point = null
    endfunction
    
    private function EnumChangeOwner takes nothing returns nothing
        call SetUnitOwner(GetEnumUnit(), newOwner, true)
    endfunction
    
    private function EnumSetTransparency takes nothing returns nothing
        call SetUnitVertexColor(GetEnumUnit(), 255, 255, 255, R2I(255*LoadReal(hash, ANIM, 0)))
    endfunction
    
    private function EnumKillUnits takes nothing returns nothing
        call KillUnit(GetEnumUnit())
    endfunction
    
    private function EnumUpgradeUnits takes nothing returns nothing
        local unit u = GetEnumUnit()
        
        //Not yet implemented....
        
        set u = null
    endfunction
    
    private function IsMdlx takes string s returns boolean
        return s == ".mdl" or s == ".mdx"
    endfunction
    
    private function ParseAttachmentPoints takes string message returns nothing
        local string s = message
        local integer i = 0
        local integer n = 0
        local integer d = StringLength(" and ")
        
        loop
            exitwhen i+d > StringLength(s)
            if SubString(s, i, i+d) == " and " then
                call SaveStr(hash, POINT, n, SubString(s, 0, i))
                set s = SubString(s, i+d, StringLength(s))
                set n = n+1
            endif
            
            set i = i+1
        endloop
        
        call SaveStr(hash, POINT, n, SubString(s, 0, StringLength(s)))
        
        set message = null
    endfunction
    
    private function IsStringInteger takes string source returns boolean
        local integer i = 0
        local string s
        
        loop
            exitwhen i+1 > StringLength(source)
            set s = SubString(source, i, i+1)
            if S2I(s) == 0 and s != "0" then
                set s = null
                return false
            endif
            set i = i+1
        endloop
    
        set s = null
        return true
    endfunction
    
    private function StringContains takes string source, string reg returns boolean
        return SubString(reg, 0, StringLength(reg)) == SubString(source, 0, StringLength(reg))
    endfunction
    
    private function ParseModelPath takes string path returns string
        local string s = path
        
        if s == "#brilliance" or StringContains("#brilliance", path) then
            set s = "Abilities\\Spells\\Human\\Brilliance\\Brilliance"
        elseif s == "#bloodlust" or StringContains("#bloodlust", path) then
            set s = "Abilities\\Spells\\Orc\\Bloodlust\\BloodLustTarget"
        elseif s == "#ensnare" or StringContains("#ensnare", path) then
            set s = "Abilities\\Spells\\Orc\\Ensnare\\ensnareTarget"
        elseif s == "#spikes" or StringContains("#spikes", path) then
            set s = "Abilities\\Spells\\Orc\\SpikeBarrier\\SpikeBarrier"
        elseif s == "#innerfire" or StringContains("#innerfire", path) then
            set s = "Abilities\\Spells\\Human\\InnerFire\\InnerFireTarget"
        elseif s == "#magicsentry" or StringContains("#magicsentry", path) then
            set s = "Abilities\\Spells\\Human\\MagicSentry\\MagicSentryCaster"
        elseif s == "#frostarmor" or StringContains("#frostarmor", path) then
            set s = "Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorTarget"
        elseif s == "#fire" or StringContains("#fire", path) then
            set s = "Environment\\SmallBuildingFire\\SmallBuildingFire0"
        elseif s == "#sleep" or StringContains("#sleep", path) then
            set s = "Abilities\\Spells\\Other\\CreepSleep\\CreepSleepTarget"
        endif
        
        if not IsMdlx(SubString(s, StringLength(s)-4, StringLength(s))) then
            set s = s + ".mdl"
        endif
        
        return s
    endfunction
    
    private function ParseAnimString takes string message returns nothing
        local integer i = 0
        local integer d = StringLength(" then ")
        local integer n = 0
        local string s = message
        
        loop
            exitwhen i+d > StringLength(s)
            
            if SubString(s, i, i+d) == " then " then
                call SaveStr(hash, ANIM, n, SubString(s, 0, i))
                set s = SubString(s, i+d, StringLength(s))
                set n = n+1
            endif
            set i = i+1
        endloop
        
        call SaveStr(hash, ANIM, n, SubString(s, 0, StringLength(s)))
    endfunction
    
    private function ParseAttachmentString takes string s returns boolean
        local integer i = 0
        local integer d = StringLength(" to ")
        
        loop
            exitwhen i+d > StringLength(s)
            
            if SubString(s, i, i+d) == " to " then
                call ParseAttachmentPoints(SubString(s, i+d, StringLength(s)))
                call SaveStr(hash, ATTACHMENT, 0, ParseModelPath(SubString(s, 0, i)))
                return true
            endif
            
            set i = i+1
        endloop
        
        return false
    endfunction
    
    private function ParseCommand takes string s, string command returns string
        if SubString(s, 0, StringLength(command)) == command then
            return SubString(s, StringLength(command), StringLength(s))
        endif   
        return null
    endfunction
    
    private function GetNextStatement takes string s returns string
        local integer i = 0
        
        loop
            exitwhen i+1 > StringLength(s)
            if SubString(s, i, i+1) == " " then
                return SubString(s, 0, i)
            endif
            set i = i+1
        endloop
        return null
    endfunction
    
    private function DisplayHelpMessage takes nothing returns nothing 
        local string s = ""
        
        set s = s + HIGHLIGHT+"-play [name]/[index]|r Plays animation [name] (or [index]) on selected units.\n"
        set s = s + HIGHLIGHT+"-tag [name]|r Toggles animation tag on selected units.\n"
        set s = s + HIGHLIGHT+"-attach [name] to [point]|r Attaches model with path [name] to attachment point [point].\n"
        set s = s + HIGHLIGHT+"-remove [name]|r Removes all attachments at point [name] from selected units.\n"
        set s = s + HIGHLIGHT+"-clear|r Clears all attachments from selected units.\n"
        set s = s + HIGHLIGHT+"-create [name]|r Creates a unit with name [name] at the center of your screen.\n"
        set s = s + HIGHLIGHT+"-owner [value]|r Changes the owner of selected units to a player id between 0-11.\n"
        set s = s + HIGHLIGHT+"-path [name]|r Adds the path [name] to all your attachment names.\n"
        set s = s + HIGHLIGHT+"-l|r Repeats the last accepted command.\n"
        set s = s + HIGHLIGHT+"-kill|r Kills all selected units.\n"
        set s = s + HIGHLIGHT+"-alpha [value]|r Sets the transparency of all selected untis to [value] 0-100\n"
        set s = s + HIGHLIGHT+"-time [value]|r Sets the current time of day to [value] between 0-24"

        call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, s)
    endfunction
    
    private function ParseDefine takes string message returns boolean
        local integer i = 0
        local integer n = 0
        local integer d = StringLength(" as ")
        local string name = null
        local string s = message
        
        loop
            exitwhen i+1 > StringLength(s)
            
            if SubString(s, i, i+1) == " " then
                set name = SubString(s, 0, i)
                set s = SubString(s, i, StringLength(s))
                exitwhen true
            endif
            set i = i+1
        endloop
        
        loop
            exitwhen not HaveSavedString(defines, StringHash(name), n)
            set n = n+1
        endloop
        
        //call BJDebugMsg("Definition is "+I2S(n)+" lines long")
        
        set i = 0
        loop
            exitwhen i+d > StringLength(s)
            
            if SubString(s, i, i+d) == " as " then
                set s = SubString(s, i+d, StringLength(s))
                call SaveStr(defines, StringHash(name), n, s)
                set name = null
                set s = null
                return true
            endif
            
            set i = i+1
        endloop
        
        call BJDebugMsg(WARNING+"-define must contain an 'as' clause!")
        
        set name = null
        set s = null
        return false
    endfunction
    
    function RegisterBuiltinDefinition takes string name, string command returns nothing
        call ParseDefine(name+" as "+command)
    endfunction
    
    private function ParseMessage takes string msg returns nothing
        local string message = msg
        local string statement = GetNextStatement(message)
        
        if statement == null then
            if StringContains("-upgrade", message) then
                call ForGroup(selectedUnits, function EnumUpgradeUnits)
            elseif StringContains("-kill", message) then
                call ForGroup(selectedUnits, function EnumKillUnits)
                set lastCommand = msg
            elseif StringContains("-help", message) then
                call DisplayHelpMessage()
                set lastCommand = msg
            elseif StringContains("-clear", message) then
                call ForGroup(selectedUnits, function EnumClearAttachments)
            endif
            return
        endif
        
        if StringContains("-play", statement) then
            set message = ParseCommand(message, statement+" ")
            call FlushChildHashtable(hash, ANIM)
            
            if IsStringInteger(message) then
                call SaveInteger(hash, ANIM, 0, S2I(message))
                call ForGroup(selectedUnits, function EnumSetAnimIndex)
            else
                call ParseAnimString(message)
                call ForGroup(selectedUnits, function EnumSetAnim)
            endif
            set lastCommand = msg
        elseif StringContains("-index", statement) then
            set message = ParseCommand(message, statement+" ")
            call SaveInteger(hash, ANIM, 0, S2I(message))
            call ForGroup(selectedUnits, function EnumSetAnimIndex)
            set lastCommand = msg
        elseif StringContains("-tag", statement) then
            set message = ParseCommand(message, statement+" ")
            call SaveStr(hash, TAG, 0, message)
            call ForGroup(selectedUnits, function EnumAddTag)
            set lastCommand = msg
        elseif StringContains("-attach", statement) then
            set message = ParseCommand(message, statement+" ")
            call FlushChildHashtable(hash, POINT)
            
            if attachmentPath != "" then
                call BJDebugMsg(HIGHLIGHT+"Note:|r Your current path is "+attachmentPath)
            endif
            
            if ParseAttachmentString(message) then
                call ForGroup(selectedUnits, function EnumAddAttachment)
                set lastCommand = msg
            else         
                call BJDebugMsg(WARNING+"You must specify an attachment point using the 'to' keyword!")
            endif
        elseif StringContains("-remove", statement) then
            set message = ParseCommand(message, statement+" ")
            call FlushChildHashtable(hash, POINT)
            call ParseAttachmentPoints(message)
            call ForGroup(selectedUnits, function EnumRemoveAttachment)
            set lastCommand = msg
        elseif StringContains("-path", statement) then
            set attachmentPath = ParseCommand(message, statement+" ")
        elseif StringContains("-create", statement) then
            set message = ParseCommand(message, statement+" ")
            if CreateUnitByName(GetTriggerPlayer(), message, GetCameraTargetPositionX(), GetCameraTargetPositionY(), 0) == null then
                call BJDebugMsg(WARNING+" A unit with this name could not be created.") 
            else
                set lastCommand = msg
            endif
        elseif StringContains("-owner", statement) then
            set message = ParseCommand(message, statement+" ")
            if S2I(message) >= 0 and S2I(message) <= 11 then
                set newOwner = Player(S2I(message))
                call ForGroup(selectedUnits, function EnumChangeOwner)
                set lastCommand = msg
            else
                call BJDebugMsg(WARNING+"-owner must be followed by a number between 0 and 11!") 
            endif
        elseif StringContains("-alpha", statement) then
            set message = ParseCommand(message, statement+" ")
            if S2I(message) >= 0 and S2I(message) <= 100 then
                call SaveReal(hash, ANIM, 0, I2R(S2I(message))/100.0)
                call ForGroup(selectedUnits, function EnumSetTransparency)
                set lastCommand = msg
            else
                call BJDebugMsg(WARNING+" Value must be in the range of 0-100!") 
            endif
        elseif StringContains("-time", statement) then
            set message = ParseCommand(message, statement+" ")
            if S2I(message) >= 0 and S2I(message) <= 24 then
                call SetFloatGameState(GAME_STATE_TIME_OF_DAY, S2I(message))
                set lastCommand = msg
            else
                call BJDebugMsg(WARNING+" Value must be in the range of 0-24!") 
            endif
        elseif StringContains("-define", statement)then
            set message = ParseCommand(message, statement+" ")
            call ParseDefine(message)
        elseif StringContains("-undefine", statement) then
            set message = ParseCommand(message, statement+" ")
            call FlushChildHashtable(defines, StringHash(message))
        endif
    endfunction

    private function OnChatMessage takes nothing returns boolean
        local string message = GetEventPlayerChatString()
        local string tmp = message
        local integer i = 0
        
        call ClearTextMessages()
        
        call GroupEnumUnitsSelected(selectedUnits, GetTriggerPlayer(), null)
        
        if message == "-l" then
            set message = lastCommand
        endif
        
        if HaveSavedString(defines, StringHash(message), 0) then
            loop
                exitwhen not HaveSavedString(defines, StringHash(message), i)
                call ParseMessage(LoadStr(defines, StringHash(message), i))
                set i = i+1
            endloop
        else
            call ParseMessage(message)
        endif
        
        set message = null
        return false
    endfunction
    
    private function OnUnitDeath takes nothing returns boolean
        local Attachment current = LoadInteger(hash, GetHandleId(GetTriggerUnit()), ATTACHMENT)
        local Attachment next
        
        loop
            exitwhen current == 0
            set next = current.next
            
            call current.destroy()
            
            set current = next
        endloop
        
        call FlushChildHashtable(hash, GetHandleId(GetTriggerUnit()))
        return false
    endfunction
    
    private function Init takes nothing returns nothing
        local integer i = 0
        local trigger t = CreateTrigger()
        
        
        loop
            exitwhen i > 11
            call TriggerRegisterPlayerChatEvent(t, Player(i), "", false)
            set i = i+1
        endloop
        call TriggerAddCondition(t, Condition(function OnChatMessage))
        
        set i = 0
        set t = CreateTrigger()
        
        loop
            exitwhen i > 11
            call TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_DEATH, null)
            set i = i+1
        endloop
        call TriggerAddCondition(t, Condition(function OnUnitDeath))
        
        call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, HIGHLIGHT+"[HINT]:|r Type -help in chat to get a list of available commands.")
    endfunction

endlibrary