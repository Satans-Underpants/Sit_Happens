-- refresh spells (used for hot loading)
ReloadStats()

PersistentVars = {}

-- add spells on game startup
function OnSessionLoaded()

    -- Persistent variables are only available after SessionLoaded is triggered!
    print("spawnedItems: ", PersistentVars['spawnedItems'])
end


-- If item is removable - that means if its mapkey is allowed
-- failsafe in case users play around with saves a lot and spawnedItems gets deleted

-- cleans up all spawned items  
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(_,spell, _, _, _)

    -- Cleans up all spawned items
    if spell == "AAA_CleanUp" and PersistentVars['spawnedItems'] then
        for _, item in pairs(PersistentVars['spawnedItems']) do
            Osi.RequestDelete(item)
        end
        PersistentVars['spawnedItems'] = nil
    end
end)


-- maybe it's better to scan the world for all items in FURNITURE? at the start of a save

-- cleans up targeted spawned items  
Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(_, target, spell, _, _, _)

    -- UsingSpellOnTarget returns unique mapkey
    -- unique mapkey is Name_ + UUID

    local targetID = getUUIDByUniqueMapkey(target)

    --Clean up single item if it is furniture
    if spell == "AAA_CleanUp_One" then
        name = getNameByUniqueMapkey(target)
        if FURNITURE[name] then
            Osi.RequestDelete(targetID)
            if contains(PersistentVars['spawnedItems'], targetID) then
                table.remove(PersistentVars['spawnedItems'], getIndex(PersistentVars['spawnedItems'],targetID))
            end
        end
    end

    -- Toggle movement on chosen furniture
    if spell == "AAA_Toggle_Movement" then
        if contains(PersistentVars['spawnedItems'], targetID) then
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
    -- Variable will be restored after the savegame finished loading
    if not PersistentVars['spawnedItems'] then
        PersistentVars['spawnedItems'] = {}
    end

    -- check if spell is supposed to spawn furniture
    if FURNITURE[spell] then
        local spawnedFurniture = Osi.CreateAt(FURNITURE[spell], x, y, z, 1, 0, "")
        table.insert(PersistentVars['spawnedItems'], spawnedFurniture)
    end

end)



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