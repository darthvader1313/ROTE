--Author MaxiM--
--Thanks to Kad_Venku--

require("libFilterFunctions")

--DOCUMENTATION: Starts the Filter System and creates a Global Instance of the Unit Table
function Definitions()

    StoryModeEvents =
    {
        Universal_Story_Start = Initialise_Filters,
        CLICK_Pause = Toggle_Pause,
        CLICK_Space_Tab = Unpause_SpaceTab,
        CLICK_Ground_Tab = Unpause_GroundTab,
        CLICK_Filter_Space_Buildings = Unpause,
        CLICK_Filter_Space_Capitals = Unpause,
        CLICK_Filter_Space_Frigates = Unpause,
        CLICK_Filter_Space_Corvettes_Fighters = Unpause,
        CLICK_Filter_Ground_Buildings = Unpause,
        CLICK_Filter_Ground_Vehicles = Unpause,
        CLICK_Filter_Ground_Infantry = Unpause,
        CLICK_Filter_Ground_Upgrades = Unpause,
        FORCE_CLICK_Pause = Flush,
    }

    _GUnitList = require("libUnitTableEmpire")
    filter_xml = "Filter_Empire.xml"
    player = Find_Player("Early_Empire")
    is_paused = false
    need_to_pause = false
    reset_pause = true
end

--DOCUMENTATION: Starts a Thread for the Filter System
function Initialise_Filters(message)
    if message == OnEnter then
        Create_Thread("ThreadUI", 0.1)
    end
end

--Toggle is_paused, since fast clicking breaks it anyways, so no different functions needed
function Toggle_Pause(message)
    if message == OnEnter then
        if is_paused then
            is_paused = false
            --Debug_Text("DEBUG_SCRIPT_START")
        elseif not is_paused then
            is_paused = true
            --Debug_Text("DEBUG_SCRIPT_END")
        end
        Create_Thread("PauseCheck")
    end
end

--if the thread runs, the game is not paused, so change the state appropriatly if it wasnt running becuase of a filter being pressed
function PauseCheck()
    Sleep(0.1)
    if reset_pause then
        is_paused = false
        --Debug_Text("DEBUG_FLUSH")
    end
end

function Unpause(message)
    if message == OnEnter then
        if is_paused == true then
            Story_Event("TRIGGER_PAUSE_NOTIFICATION")
            need_to_pause = true
        end
    end
end

function Unpause_SpaceTab(message)
    if message == OnEnter then
        if is_paused == true
                and (filter_space_buildings
                or filter_space_units
                or filter_space_frigates
                or filter_space_corvettes_fighters)
        then
            need_to_pause = true
            Story_Event("TRIGGER_PAUSE_NOTIFICATION")
        end
    end
end

function Unpause_GroundTab(message)
    if message == OnEnter then
        if is_paused == true
                and (filter_ground_buildings
                or filter_ground_vehicles
                or filter_ground_infantry
                or filter_ground_upgrades)
        then
            need_to_pause = true
            Story_Event("TRIGGER_PAUSE_NOTIFICATION")
        end
    end
end

function Flush(message)
    if message == OnEnter then
        --do nothing
    end
end

function ThreadUI(tick)
    --Booleans for saving if the Filters are activated or not
    filter_space_buildings = false
    filter_space_units = false
    filter_space_frigates = false
    filter_space_corvettes_fighters = false
    filter_ground_buildings = false
    filter_ground_vehicles = false
    filter_ground_infantry = false
    filter_ground_upgrades = false

    --Lock all units and Unlock only allowed units afterwards, so we dont need Locks in XMLs anymore
    unit_table = GetAllUnits(_GUnitList, "Lock")
    Lock_List(unit_table, filter_xml)
    unit_table = GetAllUnits(_GUnitList, "Unlock")
    Unlock_List(unit_table, filter_xml)

    while true do
        --Reset the filters if the tab was clicked
        if Check_Story_Flag(player, "SpaceTab", nil, true ) then
            if filter_space_buildings then
                Story_Event("Force_Space_Buildings")
            elseif filter_space_capitals then
                Story_Event("Force_Space_Units")
            elseif filter_space_frigates then
                Story_Event("Force_Space_Frigates")
            elseif filter_space_corvettes_fighters then
                Story_Event("Force_Space_Corvettes_Fighters")
            end
            unit_table = GetAllUnitsSpace(_GUnitList, true)
            Unlock_List(unit_table, filter_xml)
            filter_space_buildings = false
            filter_space_capitals = false
            filter_space_frigates = false
            filter_space_corvettes_fighters = false
        end

        if Check_Story_Flag(player, "GroundTab", nil, true ) then
            if filter_ground_buildings then
                Story_Event("Force_Ground_Buildings")
            elseif filter_ground_vehicles then
                Story_Event("Force_Ground_Units")
            elseif filter_ground_infantry then
                Story_Event("Force_Ground_Infantry")
            elseif filter_ground_upgrades then
                Story_Event("Force_Ground_Upgrades")
            end
            unit_table = GetAllUnitsGround(_GUnitList, true)
            Unlock_List(unit_table, filter_xml)
            filter_ground_buildings = false
            filter_ground_vehicles = false
            filter_ground_infantry = false
            filter_ground_upgrades = false
        end
        
        --Check if the button was clicked, then either lock or unlock the units
        if Check_Story_Flag(player, "SpaceBuildings", nil, true ) then
            if filter_space_buildings == false then
                unit_table = GetAllUnitsSpace(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                unit_table = GetAllUnitsSpace(_GUnitList, false)
                unit_table = GetBuildableWithoutCategory(unit_table, "SpaceBuildings")
                Lock_List(unit_table, filter_xml)
                filter_space_buildings = true
                filter_space_capitals = false
                filter_space_frigates = false
                filter_space_corvettes_fighters = false
            elseif filter_space_buildings == true then
                unit_table = GetAllUnitsSpace(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                filter_space_buildings = false
            end
        end

        if Check_Story_Flag(player, "SpaceUnits", nil, true ) then
            if filter_space_units == false then
                unit_table = GetAllUnitsSpace(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                unit_table = GetAllUnitsSpace(_GUnitList, false)
                unit_table = GetBuildableWithoutCategory(unit_table, "SpaceUnits")
                Lock_List(unit_table, filter_xml)
                filter_space_units = true
                filter_space_buildings = false
                filter_space_frigates = true
                filter_space_corvettes_fighters = true
            elseif filter_space_units == true then
                unit_table = GetAllUnitsSpace(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                filter_space_units = false
            end
        end

        if Check_Story_Flag(player, "SpaceFrigates", nil, true ) then
            if filter_space_frigates == false then
                unit_table = GetAllUnitsSpace(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                unit_table = GetAllUnitsSpace(_GUnitList, false)
                unit_table = GetBuildableWithoutCategory(unit_table, "SpaceFrigates")
                Lock_List(unit_table, filter_xml)
                filter_space_frigates = true
                filter_space_buildings = false
                filter_space_capitals = false
                filter_space_corvettes_fighters = false
            elseif filter_space_frigates == true then
                unit_table = GetAllUnitsSpace(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                filter_space_frigates = false
            end
        end

        if Check_Story_Flag(player, "SpaceCorvettesFighters", nil, true ) then
            if filter_space_corvettes_fighters == false then
                unit_table = GetAllUnitsSpace(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                unit_table = GetAllUnitsSpace(_GUnitList, false)
                unit_table = GetBuildableWithoutCategory(unit_table, "SpaceCorvettesFighters")
                Lock_List(unit_table, filter_xml)
                filter_space_corvettes_fighters = true
                filter_space_buildings = false
                filter_space_capitals = false
                filter_space_frigates = false
            elseif filter_space_corvettes_fighters == true then
                unit_table = GetAllUnitsSpace(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                filter_space_corvettes_fighters = false
            end
        end

        if Check_Story_Flag(player, "GroundBuildings", nil, true ) then
            if filter_ground_buildings == false then
                unit_table = GetAllUnitsGround(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                unit_table = GetAllUnitsGround(_GUnitList, false)
                unit_table = GetBuildableWithoutCategory(unit_table, "GroundBuildings")
                Lock_List(unit_table, filter_xml)
                filter_ground_buildings = true
                filter_ground_vehicles = false
                filter_ground_infantry = false
                filter_ground_upgrades = false
            elseif filter_ground_buildings == true then
                unit_table = GetAllUnitsGround(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                filter_ground_buildings = false
            end
        end

        if Check_Story_Flag(player, "GroundUnits", nil, true ) then
            if filter_ground_vehicles == false then
                unit_table = GetAllUnitsGround(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                unit_table = GetAllUnitsGround(_GUnitList, false)
                unit_table = GetBuildableWithoutCategory(unit_table, "GroundUnits")
                Lock_List(unit_table, filter_xml)
                filter_ground_units = true
                filter_ground_buildings = false
                filter_ground_infantry = false
                filter_ground_upgrades = false
            elseif filter_ground_units == true then
                unit_table = GetAllUnitsGround(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                filter_ground_units = false
            end
        end

        if Check_Story_Flag(player, "GroundInfantry", nil, true ) then
            if filter_ground_infantry == false then
                unit_table = GetAllUnitsGround(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                unit_table = GetAllUnitsGround(_GUnitList, false)
                unit_table = GetBuildableWithoutCategory(unit_table, "GroundInfantry")
                Lock_List(unit_table, filter_xml)
                filter_ground_infantry = true
                filter_ground_buildings = false
                filter_ground_vehicles = false
                filter_ground_upgrades = false
            elseif filter_ground_infantry == true then
                unit_table = GetAllUnitsGround(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                filter_ground_infantry = false
            end
        end

        if Check_Story_Flag(player, "GroundUpgrades", nil, true ) then
            if filter_ground_upgrades == false then
                unit_table = GetAllUnitsGround(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                unit_table = GetAllUnitsGround(_GUnitList, false)
                unit_table = GetBuildableWithoutCategory(unit_table, "GroundUpgrades")
                Lock_List(unit_table, filter_xml)
                filter_ground_upgrades = true
                filter_ground_buildings = false
                filter_ground_vehicles = false
                filter_ground_infantry = false
            elseif filter_ground_upgrades == true then
                unit_table = GetAllUnitsGround(_GUnitList, true)
                Unlock_List(unit_table, filter_xml)
                filter_ground_upgrades = false
            end
        end

        if Check_Story_Flag(player, "Lock_Executor", nil, true ) then
            unit_table1 = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Lock_List(unit_table, filter_xml)
            SetBuildable(_GUnitList, "Executor_Star_Dreadnought_P1", false)
            unit_table = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Unlock_List(unit_table, filter_xml)
        end

        if Check_Story_Flag(player, "Unlock_Executor", nil, true ) then
            SetBuildable(_GUnitList, "Executor_Star_Dreadnought_P1", true)
            unit_table = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Unlock_List(unit_table, filter_xml)
        end

        if Check_Story_Flag(player, "Lock_Piett", nil, true ) then
            unit_table1 = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Lock_List(unit_table, filter_xml)
            SetBuildable(_GUnitList, "Piett_Executor_P1", false)
            unit_table = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Unlock_List(unit_table, filter_xml)
        end

        if Check_Story_Flag(player, "Unlock_Piett", nil, true ) then
            SetBuildable(_GUnitList, "Piett_Executor_P1", true)
            unit_table = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Unlock_List(unit_table, filter_xml)
        end

        if Check_Story_Flag(player, "Lock_Eclipse", nil, true ) then
            unit_table1 = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Lock_List(unit_table, filter_xml)
            SetBuildable(_GUnitList, "Eclipse_Star_Dreadnought_P1", false)
            unit_table = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Unlock_List(unit_table, filter_xml)
        end

        if Check_Story_Flag(player, "Unlock_Eclipse", nil, true ) then
            SetBuildable(_GUnitList, "Eclipse_Star_Dreadnought_P1", true)
            unit_table = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Unlock_List(unit_table, filter_xml)
        end

        if Check_Story_Flag(player, "KuatOff", nil, true ) then
            unit_table1 = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Lock_List(unit_table, filter_xml)
            SetBuildable(_GUnitList, "Star_Destroyer", false)
            SetBuildable(_GUnitList, "Star_Destroyer_II", false)
            SetBuildable(_GUnitList, "Star_Destroyer_Ion", false)
            SetBuildable(_GUnitList, "Dominator_Star_Destroyer", false)
            SetBuildable(_GUnitList, "Allegiance_Star_Destroyer", false)
            SetBuildable(_GUnitList, "Titan_Star_Destroyer", false)
            SetBuildable(_GUnitList, "Puifier_Super_Star_Destroyer", false)
            SetBuildable(_GUnitList, "Annihilator_Super_Star_Destroyer", false)
            SetBuildable(_GUnitList, "Arc_Hammer", false)
            SetBuildable(_GUnitList, "Predominant_Star_Destroyer", false)
            SetBuildable(_GUnitList, "Singularity_Star_Destroyer", false)
            SetBuildable(_GUnitList, "Empire_Fleet_Commander_Admiral", false)
            SetBuildable(_GUnitList, "Gorgon_Star_Destroyer_II", false)
            SetBuildable(_GUnitList, "Titan_Star_Destroyer_ImperatorsWill", false)
            SetBuildable(_GUnitList, "Supremacy", false)
            SetBuildable(_GUnitList, "Death_Star_II", false)
            unit_table = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Unlock_List(unit_table, filter_xml)
        end

        if Check_Story_Flag(player, "KuatOn", nil, true ) then
            SetBuildable(_GUnitList, "Star_Destroyer", true)
            SetBuildable(_GUnitList, "Star_Destroyer_II", true)
            SetBuildable(_GUnitList, "Star_Destroyer_Ion", true)
            SetBuildable(_GUnitList, "Dominator_Star_Destroyer", true)
            SetBuildable(_GUnitList, "Allegiance_Star_Destroyer", true)
            SetBuildable(_GUnitList, "Titan_Star_Destroyer", true)
            SetBuildable(_GUnitList, "Puifier_Super_Star_Destroyer", true)
            SetBuildable(_GUnitList, "Annihilator_Super_Star_Destroyer", true)
            SetBuildable(_GUnitList, "Arc_Hammer", true)
            SetBuildable(_GUnitList, "Predominant_Star_Destroyer", true)
            SetBuildable(_GUnitList, "Singularity_Star_Destroyer", true)
            SetBuildable(_GUnitList, "Empire_Fleet_Commander_Admiral", true)
            SetBuildable(_GUnitList, "Gorgon_Star_Destroyer_II", true)
            SetBuildable(_GUnitList, "Titan_Star_Destroyer_ImperatorsWill", true)
            SetBuildable(_GUnitList, "Supremacy", true)
            SetBuildable(_GUnitList, "Death_Star_II", true)
            unit_table = GetBuildableWithCategory(_GUnitList, "SpaceCapitals")
            Unlock_List(unit_table, filter_xml)
        end

        Sleep(tick)

        if need_to_pause == true then
            Story_Event("TRIGGER_PAUSE_NOTIFICATION")
            need_to_pause = false
            reset_pause = false
        else
            reset_pause = true
        end
    end
end