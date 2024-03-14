function ReloadStats()
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/chair_spell.txt", 0)     
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/chair_object.txt", 0)
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/sit_happens_spell.txt", 0)
end


-- lua sucks
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