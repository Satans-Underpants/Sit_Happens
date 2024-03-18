function ReloadStats()
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/sit_chair_spells.txt", 0)     
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/sit_happens_spells.txt", 0)
    Ext.Stats.LoadStatsFile("Public/Sit_Happens/Stats/Generated/Data/sit_objects.txt", 0)
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

-- -- Add spell if actor doesn't have it yet
-- function TryAddSpell(actor, spellName)
--     if  Osi.HasSpell(actor, spellName) == 0 then
--         Osi.AddSpell(actor, spellName)
--     end
-- end

-- function TryAddDelayedSpells()
--     Osi.ObjectTimerLaunch(, 200)
-- end


-- -- TODO: Move the function to a separate SexScene.lua or something
-- function SexActor_RegisterCasterSexSpell(sceneData, spellName)
--     sceneData.CasterSexSpells[#sceneData.CasterSexSpells + 1] = spellName
-- end

-- -- TODO: Move the function to a separate SexScene.lua or something
-- function SexActor_AddCasterSexSpell(sceneData, casterData, timerName)
--     if sceneData.NextCasterSexSpell <= #sceneData.CasterSexSpells then
--         TryAddSpell(casterData.Actor, sceneData.CasterSexSpells[sceneData.NextCasterSexSpell])

--         sceneData.NextCasterSexSpell = sceneData.NextCasterSexSpell + 1
--         if sceneData.NextCasterSexSpell <= #sceneData.CasterSexSpells then
--             -- A pause greater than 0.1 sec between two (Try)AddSpell calls in needed 
--             -- for the spells to appear in the hotbar exactly in the order they are added.
--             Osi.ObjectTimerLaunch(casterData.Actor, timerName, 200)
--         end
--     end
-- end