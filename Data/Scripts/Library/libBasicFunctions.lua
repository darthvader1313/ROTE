--Author MaxiM--
require("PGBase")

function Get_Current_Week()
    return ((EvaluatePerception("Game_Age", player) / 45) + 0.5)
end

function Compare_Str(string1, string2)
    return string.upper(string1) == string.upper(string2)
end

function Compare_Str_List(string, string_list)
    for _, list_item in pairs(string_list) do
        if Compare_Str(string, list_item) then
            return true
        end
    end
    return false
end

function Min(num1, num2) 
    if num1 < num2 then
        return num1
    end
    return num2
end

function Max(num1, num2) 
    if num1 > num2 then
        return num1
    end
    return num2
end

function Compare_Obj(object, string)
    return string.upper(object.Get_Type().Get_Name()) == string.upper(string)
end

function Has_Similar_Name(string1, partial_name)
    return string.find(string.upper(string1), string.upper(partial_name)) ~= nil
end

function Clean_Type_Name(type_string)
    type_string = string.upper(type_string)
    type_string = string.gsub(type_string, "_WEB", "") --Remove the _WEB variants from name to normalize the planet name
    type_string = string.gsub(type_string, "_BIG", "") --Also Remove the _BIG variants 
    type_string = string.gsub(type_string, "_TUT", "") --Also Remove the _TUT variants
    type_string = string.gsub(type_string, "_SPAWNER", "")
    type_string = string.gsub(type_string, "_TEMPLATE", "")
    type_string = string.gsub(type_string, "T_", "")
    type_string = string.gsub(type_string, "_", " ")
    return type_string
end

--NOTE: This will not work with a non-array integer indexed list.
--@param free_random = (boolean) use free_random or not?
function Get_Random_From_List(list, free_random)
    if not list then
        Debug_Text(tostring(Script) .. ": Get random from list has a nil list.")
        return nil
    end
    
    listcount = table.getn(list)

    if listcount == 0 then
        Debug_Text(tostring(Script) .. ": Get random from list has an empty list.")
        return nil
    elseif listcount == 1 then
        return list[1]
    else
        random = 1
        if free_random then
            random = GameRandom.Free_Random(1, listcount)
        else 
            random = GameRandom(1, listcount)
    end
    return list[random]
    end
end

function Is_In_Table(object, table)
    for _, table_object in pairs(table) do
        if table_object == object then
            return true
        end
    end
    return false
end

function Get_Length_Of_Dictionary(dict)
    length = 0;
    for _, v in pairs(dict) do
        length = length + 1;
    end
    return length
end

function Is_Dictionary_Empty(dict)
    return next(dict) == nil 
end


function Contains_Str(str, char)
    return string.find(str, char) ~= nil
end

function Split_Str(str, delimiter)
    local result = {}
    local start = 1

    while true do
        local pos = string.find(str, delimiter, start, true)

        if not pos then
            table.insert(result, string.sub(str, start))
            break
        end

        table.insert(result, string.sub(str, start, pos - 1))
        start = pos + string.len(delimiter)
    end

    return result
end

function Get_Child_Objects(parent, player, categories)
    possible_units = nil
    child_objects = {}
    DebugMessage("%s -- Parent %s", tostring(Script), tostring(parent))
    if categories ~= nil then
        possible_units = Find_All_Objects_Of_Type(player, categories)
    else
        possible_units = Find_All_Objects_Of_Type(player)
    end

    DebugMessage("%s -- possible units", tostring(Script))
    DebugPrintTable(possible_units)

    for _,possible_unit in pairs(possible_units) do
        DebugMessage("%s -- Possible Unit %s", tostring(Script), tostring(possible_unit))
        if TestValid(possible_unit) and possible_unit.Get_Parent_Object ~= nil then
            local_parent = possible_unit.Get_Parent_Object()
            DebugMessage("%s -- Parent of possible Unit %s", tostring(Script), tostring(local_parent))
            if possible_unit.Get_Parent_Object() == parent then
                table.insert(child_objects, possible_unit)
            end
        end
    end

    return child_objects
end

function Find_Human_Player()
    human_player = Find_Player("local")

    if TestValid(human_player) then
        return human_player
    end

    if TestValid(Find_Player("Empire")) and Find_Player("Empire").Is_Human() then
        human_player = Find_Player("Empire")
    elseif TestValid(Find_Player("Rebel")) and Find_Player("Rebel").Is_Human() then
        human_player = Find_Player("Rebel")
    elseif TestValid(Find_Player("Underworld")) and Find_Player("Underworld").Is_Human() then
        human_player = Find_Player("Underworld")
    elseif TestValid(Find_Player("Hostile")) and Find_Player("Hostile").Is_Human() then
        human_player = Find_Player("Hostile")
    elseif TestValid(Find_Player("Hutts")) and Find_Player("Hutts").Is_Human() then
        human_player = Find_Player("Hutts")
    elseif TestValid(Find_Player("Hapans")) and Find_Player("Hapans").Is_Human() then
        human_player = Find_Player("Hapans")
    elseif TestValid(Find_Player("CSA")) and Find_Player("CSA").Is_Human() then
        human_player = Find_Player("CSA")
    end

    return human_player
end

--- Finds an existing enemy player
-- @param player The PlayerObject an enemy should be found for
--
function Find_Enemy_Player(player)
    enemy_player = nil

    if TestValid(Find_Player("Empire")) and player ~= Find_Player("Empire") then
        enemy_player = Find_Player("Empire")
    elseif TestValid(Find_Player("Rebel")) and player ~= Find_Player("Rebel") then
        enemy_player = Find_Player("Rebel")
    elseif TestValid(Find_Player("Underworld")) and player ~= Find_Player("Underworld") then
        enemy_player = Find_Player("Underworld")
    elseif TestValid(Find_Player("Hostile")) and player ~= Find_Player("Hostile") then
        enemy_player = Find_Player("Hostile")
    elseif TestValid(Find_Player("Pirates")) and player ~= Find_Player("Pirates") then
        enemy_player = Find_Player("Pirates")
    elseif TestValid(Find_Player("Independent")) and player ~= Find_Player("Independent") then
        enemy_player = Find_Player("Independent")
    elseif TestValid(Find_Player("Hutts")) and player ~= Find_Player("Hutts") then
        enemy_player = Find_Player("Hutts")
    elseif TestValid(Find_Player("Hapans")) and player ~= Find_Player("Hapans") then
        enemy_player = Find_Player("Hapans")
    elseif TestValid(Find_Player("CSA")) and player ~= Find_Player("CSA") then
        enemy_player = Find_Player("CSA")
    end

    return enemy_player
end

function Find_Attacking_Player(land_battle, sleep)

    if land_battle then
        attacker_entry = Find_First_Object("Attacker Entry Position")

        if not TestValid(attacker_entry) then
            return nil
        end

        Sleep(0.5)

        starting_unit = Find_Nearest(attacker_entry, "Infantry|Droid|SmallVehicle|Vehicle|BigVehicle|Air|LandHero")

        if TestValid(starting_unit) and starting_unit.Get_Distance(attacker_entry) < 100 then
            return starting_unit.Get_Owner()
        else
            return nil
        end
    else
        if sleep == true then
            Sleep(5)
        end

        DebugMessage("%s -- Set Attacker", tostring(Script))
        attacker_entry_list = Find_All_Objects_Of_Type("Attacker Entry Position")

        for _,attacker_entry in pairs(attacker_entry_list) do
            starting_unit = Find_Nearest(attacker_entry, "SpaceUnit")
            DebugMessage("%s -- Attacker starting unit %s", tostring(Script), tostring(starting_unit))
            if TestValid(starting_unit) then
                if attacker_entry.Get_Distance(starting_unit) < 4000 then
                    DebugMessage("%s -- Set Attacker Marker", tostring(Script))
                    return starting_unit.Get_Owner()
                end
            end
        end
    end
end

function Find_Defending_Player(land_battle, sleep)

    defending_player = nil
    if land_battle then
        defender_entry_list = Find_All_Objects_Of_Type("Defending Forces Position")

        for _,defender_entry in pairs(defender_entry_list) do
            starting_unit = Find_Nearest(defender_entry, "Infantry|Droid|SmallVehicle|Vehicle|BigVehicle|Air")
            if TestValid(starting_unit) and not TestValid(defending_player) then
                if defender_entry.Get_Distance(starting_unit) < 50 then
                    defending_player = starting_unit.Get_Owner()
                    break
                end
            end
        end

        if not TestValid(defending_player) then
            in_base_structure_list = Find_All_Objects_Of_Type("In Base Special Structure Position")

            for _,in_base_structure in pairs(in_base_structure_list) do
                starting_unit = Find_Nearest(in_base_structure, "Structure")
                if TestValid(starting_unit) and not TestValid(defending_player) then
                    if in_base_structure.Get_Distance(starting_unit) < 50 then
                        defending_player = starting_unit.Get_Owner()
                        break
                    end
                end
            end
        end

        if not TestValid(defending_player) then
            out_base_structure_list = Find_All_Objects_Of_Type("Out Base Special Structure Position")

            for _,out_base_structure in pairs(out_base_structure_list) do
                starting_unit = Find_Nearest(out_base_structure, "Structure")
                if TestValid(starting_unit) and not TestValid(defending_player) then
                    if out_base_structure.Get_Distance(starting_unit) < 50 then
                        defending_player = starting_unit.Get_Owner()
                        break
                    end
                end
            end
        end

        if not TestValid(defending_player) then
            power_gen_marker = Find_First_Object("Power Generator Structure Position")

            if TestValid(power_gen_marker) then
                starting_unit = Find_Nearest(power_gen_marker, "Structure")
                if TestValid(starting_unit) then
                    if power_gen_marker.Get_Distance(starting_unit) < 50 then
                        defending_player = starting_unit.Get_Owner()
                    end
                end
            end
        end
    else
        if sleep == true then
            Sleep(3)
        end
        DebugMessage("%s -- Set Defender", tostring(Script))
        defender_entry_list = Find_All_Objects_Of_Type("Defending Forces Position")

        for _,defender_entry in pairs(defender_entry_list) do
            starting_unit = Find_Nearest(defender_entry, "SpaceUnit")
            DebugMessage("%s -- Starting_unit", tostring(Script), tostring(starting_unit))
            if TestValid(starting_unit) and not TestValid(defending_player) then
                if defender_entry.Get_Distance(starting_unit) < 4000 then
                    defending_player = starting_unit.Get_Owner()
                    DebugMessage("%s -- Set Defender Marker", tostring(Script))
                    break
                end
            end
        end

        if not TestValid(defending_player) then
            marker_list = Find_All_Objects_Of_Type("Space Station Position")

            for _,marker in pairs(marker_list) do
                starting_unit = Find_Nearest(marker, "SpaceStructure")
                if TestValid(starting_unit) and not TestValid(defending_player) then
                    if marker.Get_Distance(starting_unit) < 1000 then
                        defending_player = starting_unit.Get_Owner()
                        DebugMessage("%s -- Set Defender Station", tostring(Script))
                        break
                    end
                end
            end
        end

        if not TestValid(defending_player) then
            marker_list = Find_All_Objects_Of_Type("Orbital Special Structure Position")

            for _,marker in pairs(marker_list) do
                starting_unit = Find_Nearest(marker, "SpaceStructure")
                if TestValid(starting_unit) and not TestValid(defending_player) then
                    if marker.Get_Distance(starting_unit) < 1000 then
                        defending_player = starting_unit.Get_Owner()
                        DebugMessage("%s -- Set Defender Orbital", tostring(Script))
                        break
                    end
                end
            end
        end

        if not TestValid(defending_player) then
            marker_list = Find_All_Objects_Of_Type("Defensive Orbital Structure Position")

            for _,marker in pairs(marker_list) do
                starting_unit = Find_Nearest(marker, "SpaceStructure")
                if TestValid(starting_unit) and not TestValid(defending_player) then
                    if marker.Get_Distance(starting_unit) < 1000 then
                        defending_player = starting_unit.Get_Owner()
                        DebugMessage("%s -- Set Defender Defensive", tostring(Script))
                        break
                    end
                end
            end
        end
    end

    if defending_player ~= nil then
        name = defending_player.Get_Faction_Name()
        DebugMessage("%s -- Set Defender to %s", tostring(Script), tostring(name))
    end
    return defending_player
end

function Get_Unit_Categories(object, ground, include_anti)
    category_string = ""
    first_category = true

    anti_categories = {
        "AntiFighter",
        "AntiLight",
        "AntiMedium",
        "AntiHeavy",
        "AntiInfantry",
        "AntiVehicle",
        "AntiAir",
        "AntiStructure"
    }

    loop_categories = {}

    if (ground == true) then
        loop_categories = {
            "Infantry",
            "Droid",
            "SmallVehicle",
            "Vehicle",
            "BigVehicle",
            "Air",
            "Structure",
            "LandHero"
        }
    else
        loop_categories = {
            "Fighter",
            "Bomber",
            "Transport",
            "Corvette",
            "Frigate",
            "Cruiser",
            "Capital",
            "Super",
            "SpaceHero",
            "SpaceStructure"
        }
    end

    if (include_anti) then
        for _,element in pairs(anti_categories) do
            table.insert(loop_categories, element)
        end
    end

    for _,category in pairs(loop_categories) do
        if object.Is_Category(category) then
            if first_category then
                first_category = false
            else
                category_string = category_string .. " | "
            end
            category_string = category_string .. category
        end
    end

    return category_string
end

function Is_Ground_Category(object)
    if object.Is_Category("Infantry")
            or object.Is_Category("Droid")
            or object.Is_Category("Air")
            or object.Is_Category("Vehicle")
            or object.Is_Category("SmallVehicle")
            or object.Is_Category("BigVehicle")
            or object.Is_Category("LandHero")
            or object.Is_Category("Structure") then
        return true
    end
end

function Is_Space_Category(object)
    if object.Is_Category("Fighter")
            or object.Is_Category("Bomber")
            or object.Is_Category("Transport")
            or object.Is_Category("Corvette")
            or object.Is_Category("Frigate")
            or object.Is_Category("Cruiser")
            or object.Is_Category("Capital")
            or object.Is_Category("Super")
            or object.Is_Category("SpaceHero")
            or object.Is_Category("SpaceStructure") then
        return true
    end
end

--returns true if passed object is the highest level object in GC and able to be used as a GC container object
function Is_GC_Object(object) 
    --If the unit's parent is a planet (for a ground unit) or the galactic_fleet,
    -- we know its something spawnable (like a company/squadron/team or actual unit without a team)
    return TestValid(object) 
    and object.Get_Parent_Object ~= nil 
    and object.Get_Parent_Object() ~= nil
    and (object.Get_Parent_Object().Get_Type().Get_Name() == "GALACTIC_FLEET" 
        or (object.Is_Category("GroundUnit") and object.Get_Parent_Object() == planet ))
end

function Concat_Tables(t1,t2)
    if t2 ~= nil then
        for i=1,table.getn(t2) do
            t1[table.getn(t1)+1] = t2[i]
        end
    end
    return t1
end

function Randomize_List(object_list)

    randomized_object_list = {}
    for _, value in ipairs(object_list) do
        table.insert(randomized_object_list, value)
    end

    randomized_object_size = table.getn(randomized_object_list)

    for i = 1, randomized_object_size, 1 do
        local a = GameRandom(1, randomized_object_size)
        local b = GameRandom(1, randomized_object_size)
        randomized_object_list[a], randomized_object_list[b] = randomized_object_list[b], randomized_object_list[a]
    end

    return randomized_object_list
end

function Get_Unit_Table(faction_name)
    if faction_name == "REBEL" then
        return require("libUnitTableRebelV2")
    elseif faction_name == "EMPIRE" then
        return require("libUnitTableEmpireV2")
    elseif faction_name == "UNDERWORLD" then
        return require("libUnitTableUnderworldV2")
    end
    return {}
end

function Get_Unit_From_Unit_Table(unit_table, unit_name)
    if unit_table == nil or not next(unit_table) then
        Error_Text(tostring(Script) .. " Get_Unit_From_Unit_Table: while searching for " .. unit_name .. ", table not found or is empty!")
    end

    return unit_table[string.upper(unit_name)]
end

--- Get the middle of two positions
---@param pos1 intended to be the destination (enemy)
---@param pos2 intended to be the start point (object)
---@return new vector
function Get_Middle_Position(pos1, pos2)
    pos1_x, pos1_y, pos1_z = pos1.Get_XYZ()
	pos2_x, pos2_y, pos2_z = pos2.Get_XYZ()

	new_x = (pos1_x + pos2_x) / 2
	new_y = (pos1_y + pos2_y) / 2
	new_z = (pos1_z + pos2_z) / 2

    return Create_Position(new_x, new_y, new_z)
end

--- Get Maginitude of two vectors
---@param pos1 intended to be the destination (enemy)
---@param pos2 intended to be the start point (object)
---@return new vector
function Get_Magnitude(pos1, pos2)
    pos1_x, pos1_y = pos1.Get_XYZ()
	pos2_x, pos2_y = pos2.Get_XYZ()

	vector_x = pos1_x - pos2_x
	vector_y = pos1_y - pos2_y

    return vector_x, vector_y
end

function Flip_Vector_Left(vector_x, vector_y)
    return -vector_y, vector_x
end

function Flip_Vector_Right(vector_x, vector_y)
    return vector_y, -vector_x
end

function Unit_In_Range(object, target, additional_range)
    if additional_range == nil then
        additional_range = 0
    end

    max_range = object.Get_Type().Get_Max_Range() + additional_range

    object_x, object_y = object.Get_Position().Get_XYZ()
    target_x, target_y = target.Get_Position().Get_XYZ()

    distance_squared = ((object_x - target_x) * (object_x - target_x) + (object_y - target_y) * (object_y - target_y))
    max_range_squared = max_range * max_range

    DebugMessage("%s -- Unit_In_Range Distance: %s Max_Range: %s", tostring(Script), tostring(distance_squared), tostring(max_range_squared))

    if distance_squared < max_range_squared then
        return true
    end
    return false
end

function Air_Unit_Recalculate_Movement(object)
    if object.Is_Category("Air") and object.Has_Attack_Target() then
        local attack_target = object.Get_Attack_Target() 
        if TestValid(attack_target) then
            object.Attack_Target(attack_target)
        end
    end
end

function Get_Sqr_Distance(object, target)
    object_pos = object.Get_Position()
    if target.Get_Position ~= nil then
        target_pos = target.Get_Position()
    else --if Get Position is nil then target is a position object. 
        target_pos = target
    end

    object_x, object_y = object_pos.Get_XYZ()
    target_x, target_y = target_pos.Get_XYZ()

    final_x = target_x - object_x
    final_y = target_y - object_y
    
    return (final_x * final_x) + (final_y * final_y);
end

function Get_Position_Distance(pos1, pos2)
    object_x, object_y = pos1.Get_XYZ()
    target_x, target_y = pos2.Get_XYZ()

    final_x = target_x - object_x
    final_y = target_y - object_y
    
    return (final_x * final_x) + (final_y * final_y);
end

function Create_Nearby_Position(current_position, max_distance)
    current_position_x, current_position_y, current_position_z = current_position.Get_XYZ()
    new_position_x = GameRandom(-max_distance, max_distance) + current_position_x
    new_position_y = GameRandom(-max_distance, max_distance) + current_position_y
    return Create_Position(new_position_x, new_position_y, current_position_z)
end

function Get_Build_Limit_In_Progress(build_limit_id, player)
    build_limit_id = string.upper(build_limit_id)

    local build_in_progress = GlobalValue.Get(PlayerSpecificName(player, "BUILD_IN_PROGRESS_"..build_limit_id))

    if build_in_progress == nil then
        build_in_progress = 0
    end

    return build_in_progress
end

function Get_Single_Build_Limit_Unit_Count(unit_entry, player)
    local build_in_progress = Get_Build_Limit_In_Progress(unit_entry.UnitName, player)
    DebugMessage("%s -- Get_Single_Build_Limit_Unit_Count unit %s has %s builds in progress", tostring(Script), tostring(unit_entry.UnitName), tostring(build_in_progress))

    return table.getn(Find_All_Objects_Of_Type(unit_entry.UnitName, player)) + build_in_progress
end

function Get_Group_Build_Limit_Unit_Count(build_limit_group, player)
    local build_in_progress = Get_Build_Limit_In_Progress(build_limit_group.Name, player)
    DebugMessage("%s -- Get_Group_Build_Limit_Unit_Count group %s has %s builds in progress", tostring(Script), tostring(build_limit_group.Name), tostring(build_in_progress))

    local all_units_count = build_in_progress

    for _, unit_name in pairs(build_limit_group.Units) do
        all_units_count = all_units_count + table.getn(Find_All_Objects_Of_Type(unit_name, player))
    end

    return all_units_count
end

function Get_Build_Limit_Group(group_name)
    local build_limit_group_table = require("libBuildLimitGroupTable")
    for _,group in pairs (build_limit_group_table) do
        if Compare_Str(group_name, group.Name) then
            return group
        end
    end
end