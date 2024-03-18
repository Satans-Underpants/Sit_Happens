-- refresh spells (used for hot loading)
ReloadStats()

-- all currently spawned items
local modID = "7396b2b6-0e41-4b3f-bd88-c3b47e85704a"
local spawnedItems  

PersistentVars = {}

-- Variable will be restored after the savegame finished loading
function doStuff()
    PersistentVars['Test'] = 'Something to keep'
    print("Set PersistentVars Test to String")
end

doStuff()



-- add spells on game startup
function OnSessionLoaded()

    -- Persistent variables are only available after SessionLoaded is triggered!
    print("PersistentVars afterloading: ", PersistentVars['Test'])


    -- add spells for all partymembers

    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local party = Osi.DB_PartyMembers:Get(nil)
        for i = #party, 1, -1 do

            TryAddSpell(party[i][1], "Sit_Happens_UTILS")
            TryAddSpell(party[i][1], "Sit_Happens_CHAIRS")
            TryAddSpell(party[i][1], "Sit_Happens_BENCHES")
        end
    end)

    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(actor)
        TryAddSpell(actor, "Sit_Happens_UTILS")
        TryAddSpell(actor, "Sit_Happens_CHAIRS")
        TryAddSpell(actor, "Sit_Happens_BENCHES")
    end)
end

-- TODO function for adding all 3 spells 


-- If item is removable - that means if its mapkey is allowed
-- failsafe in case users play around with saves a lot and spawnedItems gets deleted

-- cleans up all spawned items  
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(_,spell, _, _, _)

    -- Cleans up all spawned items
    if spell == "AAA_CleanUp" and spawnedItems then
        for _, item in pairs(spawnedItems) do
            Osi.RequestDelete(item)
        end
        spawnedItems = nil
    end
end)


-- cleans up targeted spawned items  
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(_, target, spell, _, _, _)

    -- UsingSpellOnTarget returns unique mapkey
    -- unique mapkey is Name_ + UUID

    local targetID = getUUIDByUniqueMapkey(target)

    -- Clean up single item if it is furniture

    --Clean up single item if it is furniture
    if spell == "AAA_CleanUp_One" then
        name = getNameByUniqueMapkey(target)
        if FURNITURE[name] then
            Osi.RequestDelete(targetID)
            if contains(spawnedItems, targetID) then
                table.remove(spawnedItems, getIndex(spawnedItems,targetID))
            end
        end
    end

    -- Toggle movement on chosen furniture
    if spell == "AAA_Toggle_Movement" then
        if contains(spawnedItems, targetID) then
            local isMovable = Osi.IsMovable(targetID)
            if isMovable == 0 then
                Osi.SetMovable(targetID, 1) 
            else
                Osi.SetMovable(targetID, 0)
            end
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

end)


-- Add spell if actor doesn't have it yet
function TryAddSpell(actor, spellName)
    if  Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end


function getUUIDByUniqueMapkey(uniqueMapkey)

    local startPosition = #uniqueMapkey - 35
    local uuid = string.sub(uniqueMapkey, startPosition)
    return uuid
end

function getNameByUniqueMapkey(uniqueMapkey)
    local endPosition = #uniqueMapkey - 37
    local strippedString = string.sub(uniqueMapkey, 1, endPosition)
    return strippedString
end




Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)