-- add spells on game startup
function OnSessionLoaded()

    -- add spells for all partymembers

    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local party = Osi.DB_PartyMembers:Get(nil)
        for i = #party, 1, -1 do
            addChairSpells(party[i][1])
        end
    end)

    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(actor)
        addChairSpells(actor)
    end)
end


-- Add spell if actor doesn't have it yet
function TryAddSpell(actor, spellName)
    if  Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end

function addChairSpells(entity)
    TryAddSpell(entity, "Sit_Happens_UTILS")
    TryAddSpell(entity, "Sit_Happens_BENCHES")
    TryAddSpell(entity, "Sit_Happens_CHAIRS")
    if Ext.Mod.IsModLoaded("af31ce51-252c-4698-99f9-021dbe019d74")==true then
        TryAddSpell(entity, "Sit_Happens_3rdParty")
    end
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)