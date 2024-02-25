
-- refresh spells (used for hot loading)
ReloadStats()

-- add spells on game startup
function OnSessionLoaded()
    print("Adding Spell")

    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local party = Osi.DB_PartyMembers:Get(nil)
        for i = #party, 1, -1 do
            TryAddSpell(party[i][1], "SummonBed")
        end
    end)

    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(actor)
        TryAddSpell(actor, "SummonBed")
    end)
end


function TryAddSpell(actor, spellName)
    if Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)