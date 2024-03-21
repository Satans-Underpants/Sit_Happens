function ReloadStats()
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/sit_chair_spells.txt", 0)     
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/sit_happens_spells.txt", 0)
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/sit_objects.txt", 0)
end

-- get index by item directly
function getIndex(list, item)
    for i, object in ipairs(list) do
        if object == item then
            return i
        end
    end
end

-- for tables
function contains(list, item)
    for i, object in ipairs(list) do
        if object == item then
            return true
        end  
    end
    return false
end


-- for maps
function containsValue(map, item)
    for key, object in pairs(map) do
        if object == item then
            return true
        end
    end
    return false
end