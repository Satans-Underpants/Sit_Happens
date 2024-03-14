
-- refresh spells (used for hot loading)
ReloadStats()

-- all currently spawned items
local spawnedItems  

-- add spells on game startup
function OnSessionLoaded()

    -- add spells for all partymembers

    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local party = Osi.DB_PartyMembers:Get(nil)
        for i = #party, 1, -1 do
            TryAddSpell(party[i][1], "Sit Happens")
        end
    end)

    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(actor)
        TryAddSpell(actor, "SitHappens")
    end)
end


-- cleans up all spawned items  
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(_,spell, _, _, _)

    -- Cleans up all spawned items
    if spell == "AAACleanUp" and spawnedItems then
        for _, item in pairs(spawnedItems) do
            Osi.RequestDelete(item)
        end
        spawnedItems = nil
    end
    
end)


-- cleans up targeted spawned items  
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(_, target, spell, _, _, _)

    -- Clean up single item if it is furniture
    if spell == "AAACleanUpOne" then
        if containsValue(FURNITURE, target) then
            Osi.RequestDelete(target)
            table.remove(spawnedItems, getIndex(spawnedItems,target))
            print("FURNITURE contained target")
        end
    end


    if spell == "AAACleanUpOne" then
        if contains(spawnedItems, target) then
            Osi.RequestDelete(target)
            table.remove(spawnedItems, getIndex(spawnedItems,target))
            print("list contained target")
        end
    end

end)


-- Furniture Spawning
Ext.Osiris.RegisterListener("UsingSpellAtPosition", 8, "after", function(_, x, y, z, spell, _, _, _)

    -- initiate spawnedItems
    if not spawnedItems then
        spawnedItems = {}
    end

    -- check if spell is supposed to spawn furniture
    if FURNITURE[spell] then
        local spawnedFurniture = Osi.CreateAt(FURNITURE[spell], x, y, z, 1, 0, "")
        table.insert(spawnedItems, spawnedFurniture)
    end


    for _, furn in pairs(spawnedItems) do
        print(furn)
    end

end)


-- Add spell if actor doesn't have it yet
function TryAddSpell(actor, spellName)
    if  Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end



Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)