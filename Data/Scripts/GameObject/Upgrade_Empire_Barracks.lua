--
--  Function to upgrade special structure from previous level to the current.
--  Made by That One Bullet & MaxiM for AotR 2.7
--
require("PGStateMachine")
require("libUpgradeFunctions")

function Definitions()

    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() == "Land" or Get_Game_Mode() == "Space" then
            ScriptExit()
        end

        player = Object.Get_Owner()
        planet = Object.Get_Planet_Location()

        if Object.Get_Type().Get_Name() == "Early_Empire_Command_Center_lvl1" then
            has_higher_level = false
            has_higher_level = Check_For_Higher_Level(planet, player, Object, "Early_Empire_Command_Center_lvl2", "TEXT_BUILDING_ABORTED_BARRACKS")
            if not has_higher_level == false then
				Object.Despawn()
            end

        elseif Object.Get_Type().Get_Name() == "Upgrade_Early_Empire_Command_Center_1_TO_2_DUMMY" then

            Upgrade_Structure(planet, player, "Early_Empire_Command_Center_lvl1", "Early_Empire_Command_Center_lvl2")
            Object.Despawn()

        end
    end

    ScriptExit()
end