print("Loaded Teleport.lua")

-- cleans up all spawned items  
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(_,spell, _, _, _)

    if spell == "AATeleport" then
        local previousLocationx, previousLocationy, previousLocationz = Osi.GetPosition(Osi.GetHostCharacter())
        print(previousLocationx, previousLocationy, previousLocationz)
        TeleportPartiesToLevelWithMovie("SCL_CIN_PrivateCampRoom_B", "", "")
    end

end)