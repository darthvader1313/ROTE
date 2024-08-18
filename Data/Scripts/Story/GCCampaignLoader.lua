require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
StoryUtil = require("eawx-util/StoryUtil")

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	StoryModeEvents = { Universal_Story_Start = Set_Tech }
end

function Set_Tech(message)
  if message == OnEnter then

    --Match the order of the index in factions.xml
	liveFactionTable = {
      ["REBEL"] = 0,
      ["EMPIRE"] = 1,
      --"HUTT_CARTELS" 2,
      --"NEUTRAL" 3,
      --"HOSTILE" 4,
      ["EMPIREOFTHEHAND"] = 5,
      --"UNDERWORLD" 6,
      ["PIRATES"] = 7,
      ["HUTTS"] = 8,
      --"CHISS" 9,
      --"CORELLIA" 10,
      ["SSIRUUVI_IMPERIUM"] = 11, 
      ["HAPES_CONSORTIUM"] = 12,
      ["CORPORATE_SECTOR"] =13,
      ["PENTASTAR"] = 14,
      ["TERADOC"] = 15,
      --"WARLORDS"
    }

    local faction_index = 0
    local credits = 0
    local faction_name = "REBEL"
	for faction, id in pairs(liveFactionTable) do
		if Find_Player(faction).Is_Human() then
            faction_index = id
            faction_name = faction
			credits = Find_Player(faction).Get_Credits()
      Find_Player(faction).Give_Money(10000-credits)
			break
		end
	end

	local era = (credits / 1000) + 1

		if era >= 8 then
			era = 7
		end

  local give_credits = 10000 - credits

	if Find_Player("Pirates").Is_Human() then
		if era >= 2 then
			era = 2
		end
	elseif Find_Player("Pentastar").Is_Human() then
		if era >= 6 then
			era = 6
		end
	elseif Find_Player("Hutts").Is_Human() then
		if era >= 6 then
			era = 6
		end
	elseif Find_Player("Teradoc").Is_Human() then
		if era >= 6 then
			era = 6
		end
	end

    

    plot = Get_Story_Plot("Conquests\\Progressive\\GCLoader.xml")

    local all_planets = FindPlanet.Get_All_Planets()

    for _, planet in ipairs(all_planets) do
        planet_name = planet.Get_Type().Get_Name()
    end

 
        loadEvent = plot.Get_Event("Load_Another_GC")

        StoryUtil.ShowScreenText(planet_name.."_"..faction_name.."_Era_"..tostring(era), 10)

        local name = planet_name.."_"..faction_name.."_Era_"..tostring(era)

        loadEvent.Set_Reward_Parameter(0, name)
        loadEvent.Set_Reward_Parameter(1, faction_index)

	
    Story_Event("LOAD_CAMPAIGN_EVENT")

  elseif message == OnUpdate then
	ScriptExit()
  end
end