library Configuration initializer Init requires ChatCommands

    private function Init takes nothing returns nothing
        call RegisterBuiltinDefinition("upgrade first", "-play birth upgrade then stand upgrade first")
        call RegisterBuiltinDefinition("upgrade second", "-play birth upgrade first then stand upgrade second")
        call RegisterBuiltinDefinition("upgrade third", "-play birth upgrade second then stand upgrade third")
        call RegisterBuiltinDefinition("morph", "-play Morph")
        call RegisterBuiltinDefinition("morph", "-tag Alternate")
    endfunction

endlibrary