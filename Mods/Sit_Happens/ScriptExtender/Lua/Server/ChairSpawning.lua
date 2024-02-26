
-- refresh spells (used for hot loading)
ReloadStats()

-- add spells on game startup
-- TODO : modify to add all spells
function OnSessionLoaded()
    print("Adding Spell")

    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local party = Osi.DB_PartyMembers:Get(nil)
        for i = #party, 1, -1 do
            TryAddSpell(party[i][1], "Sit Happens")
        end
    end)

    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(actor)
        TryAddSpell(actor, "SizHappens")
    end)
end


function TryAddSpell(actor, spellName)
    if Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end


-- TODO - only items spawned by host are deleted, not by other player in multiplyer
-- TODO - check if items can be spawned in crtain directon or moved

-- cleans up all spawned items  
Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster,spell, _, _, _)
    if spell == "CleanUp" then
        print("CleanUp activated")
        Osi.RemoveSummons(GetHostCharacter(), 0)
    end
end)


Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)