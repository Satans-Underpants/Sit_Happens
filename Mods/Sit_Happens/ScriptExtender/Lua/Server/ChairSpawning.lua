-- refresh spells (used for hot loading)
ReloadStats()

PersistentVars = {}

function spawnedItems()
    return PersistentVars['spawnedItems']
end


-- cleans up all spawned items  
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(_,spell, _, _, _)

    if (spell == "AAA_CleanUp" or spell == "AAAA_UNINSTALL") and spawnedItems() then
        for _, item in pairs(spawnedItems()) do
            Osi.RequestDelete(item)
        end
        PersistentVars['spawnedItems'] = nil
    end
end)


Ext.Osiris.RegisterListener("UsingSpellOnTarget", 6, "after", function(_, target, spell, _, _, _)

    -- UsingSpellOnTarget returns unique mapkey
    -- unique mapkey is Name_ + UUID

    local targetID = getUUIDByUniqueMapkey(target)

    --Clean up single item if it is furniture
    if spell == "AAA_CleanUp_One" then
        name = getNameByUniqueMapkey(target)
        if FURNITURE[name] then
            Osi.RequestDelete(targetID)
            if contains(spawnedItems(), targetID) then
                table.remove(spawnedItems(), getIndex(spawnedItems(),targetID))
            end
        end
    end

    -- Toggle movement on chosen furniture
    if spell == "AAA_Toggle_Movement" then
        if contains(spawnedItems(), targetID) then
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
    if not PersistentVars['spawnedItems'] then
        PersistentVars['spawnedItems'] = {}
    end

    -- check if spell is supposed to spawn furniture
    if FURNITURE[spell] then
        local spawnedFurniture = Osi.CreateAt(FURNITURE[spell], x, y, z, 1, 0, "")
        table.insert(spawnedItems(), spawnedFurniture)
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