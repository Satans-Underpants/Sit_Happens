

-- cleans up all spawned items  
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(_,spell, _, _, _)

    if spell == "AATeleport" then
        local previousLocation = Osi.GetPosition(Osi.GetHostCharacter())
        print(previousLocation)
    end
    
end)