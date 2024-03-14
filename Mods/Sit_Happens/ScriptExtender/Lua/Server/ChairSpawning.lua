
-- refresh spells (used for hot loading)
ReloadStats()

-- all currently spawned items
local spawnedItems  
local spawnLocation

-- add spells on game startup
function OnSessionLoaded()

    -- add spells for all partymembers
    print("Adding Spell")

    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local party = Osi.DB_PartyMembers:Get(nil)
        for i = #party, 1, -1 do
            TryAddSpell(party[i][1], "Sit Happens")
            spawnLocation = party[i][1]
            print("Spawnlocation at ",party[i][1])
        end
    end)

    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(actor)
        TryAddSpell(actor, "SitHappens")
    end)

    -- initiate spawnedItems
    if not spawnedItems then
        spawnedItems = {}
    end

end


function TryAddSpell(actor, spellName)
    if Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end

function spawnItem(itemId, spawnLocation)
    local newItem = Osi.CreateAtObject(itemId, spawnLocation, 1, 0, "", 1)
    spawnedItems.insert(spawnedItems, newItem)
end


-- TODO - check if items can be spawned in certain directon or moved

-- cleans up all spawned items  
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster,spell, _, _, _)

    -- Cleans up all spawned items
    if spell == "AAACleanUp" then
        for _, item in pairs(spawnedItems) do
            print("item: " ,item)
            Osi.RequestDelete(item)
        end
    end
end)

-- TODO - maybe some error handling
-- Furniture Spawning
Ext.Osiris.RegisterListener("UsingSpellAtPosition", 8, "after", function(caster, x, y, z, spell, spellType, spellElement, storyActionID)

    -- check if spell is supposed to spawn furniture
    for furnitureName, furnitureID in pairs(FURNITURE) do
        if furnitureName == spell then
            local spawnedFurniture = Osi.CreateAt(furnitureID, x, y, z, 1, 0, "")
            table.insert(spawnedItems, spawnedFurniture)
        end
    end

    -- Else check if it's in FURNITURE_NEW (placeholder, later migrate all)
    for furnitureName, furnitureID in pairs(FURNITURE_NEW) do
        if furnitureName == spell then
            print("New furniture found: ", furnitureName)
        
            furnitureID = GetCustomFurnitureID(furnitureName)
            print("furnitureID = ", furnitureID)
            local spawnedFurniture = Osi.CreateAt(furnitureID, x, y, z, 1, 0, "")
            print("spawnedFurniture = ", spawnedFurniture)
            table.insert(spawnedItems, spawnedFurniture)
        end
    end

end)



--Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(_, target, spell, _, _, _)
    
 --   print("Spell: ", spell)
  --  print("target ", target)
  --  print("targetLocation: ", Osi.GetPosition(target))
    
--end)




Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)