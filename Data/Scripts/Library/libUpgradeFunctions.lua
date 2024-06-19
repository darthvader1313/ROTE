-- Author MaxiM --

require("PGSpawnUnits")
require("libBasicFunctions")


--- Function that checks if there already is a higher level structure on a planet. If thats the case, it returns
--  money and throws an error message.
--
-- @param planet planet, where the building that needs checking is
-- @param player playerobject
-- @param object object being built
-- @param higher_level_structure name of the higher level structure
-- @param error_message error message that will be thrown if the player has a higher level building
-- @return true if a higher level structure exists, false if not
--
function Check_For_Higher_Level(planet, player, object, higher_level_structure, error_message)
    higher_level_structure = Find_Object_Type(higher_level_structure)
    higher_level_structure_list = Find_All_Objects_Of_Type(higher_level_structure)
    money = object.Get_Type().Get_Build_Cost() * 0.8
    has_higher_level = false

    for _,unit in pairs(higher_level_structure_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet then
            has_higher_level = true
            if player.Is_Human() then
                player.Give_Money(money)
                Game_Message(error_message)
            end
        end
    end

    return has_higher_level
end


--- Function that checks if there are too many structures on a planet. If thats the case, it returns
--  money and throws an error message.
--
-- @param planet planet, where the building that needs checking is
-- @param player playerobject
-- @param object object being built
-- @param structure_name name of the structure to count
-- @param count structure count to check against
-- @param error_message error message that will be thrown if the player has a higher level building
-- @return true if too many structures on a planet, false if not
function Check_For_Structure_Count(planet, player, object, structure_name, count, error_message)
    higher_level_structure = Find_Object_Type(structure_name)
    higher_level_structure_list = Find_All_Objects_Of_Type(structure_name)
    money = object.Get_Type().Get_Build_Cost() * 0.8
    has_reached_count = false
    current_count = 0

    for _,unit in pairs(higher_level_structure_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet then
            current_count = current_count + 1

            if current_count > count then
                has_reached_count = true
                if player.Is_Human() then
                    player.Give_Money(money)
                    Game_Message(error_message)
                    break
                end
            end
        end
    end

    return has_reached_count
end




--- Function that sets a structure on a given planet. Is used for all level 1 structures and replaceable structures, like
-- rebel warehouses.
--
-- @param planet planet, where the building should be set
-- @param player playerobject
-- @param structure_name name of the structure to set
-- @param money money that the player gets, if the structure is already set
-- @param error_message error message if the structure on that planet already exists
--
function Set_Structure(planet, player, structure_name, error_message)
    structure = Find_Object_Type(structure_name)
    structure_list = Find_All_Objects_Of_Type(structure)
    money = structure.Get_Build_Cost() * 0.8
    already_set = false

    for _, unit in pairs(structure_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet then
            already_set = true
            if player.Is_Human() then
                player.Give_Money(money)
                Game_Message(error_message)
            end
        end
    end

    if already_set == false then
        SpawnList({structure_name}, planet, player, false, false)
    end
end

--- Function that upgrades a building to a higher level. If the building was already upgraded, the player gets money
--  back.
--
-- @param planet planet, where the building to upgrade is
-- @param player playerobject
-- @param previous_structure_name name of the structure to upgrade
-- @param upgraded_structure_name name of the upgraded structure
--
function Upgrade_Structure(planet, player, previous_structure_name, upgraded_structure_name)
    previous_structure = Find_Object_Type(previous_structure_name)
    previous_structure_list = Find_All_Objects_Of_Type(previous_structure)
    already_upgraded = false
    money = (Find_Object_Type(upgraded_structure_name).Get_Build_Cost() - previous_structure.Get_Build_Cost()) * 0.8

    for _, unit in pairs(previous_structure_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet then
            unit.Despawn()
            already_upgraded = true
            SpawnList({upgraded_structure_name}, planet, player, false, false)
        end
    end
    --Despawn all dummies, the orbital structures will ensure to respawn their assigned dummy
    orbital_dummy_name = previous_structure_name.."_ORBITAL_DUMMY"
    orbital_dummy = Find_Object_Type(orbital_dummy_name)
    if TestValid(orbital_dummy) then
        orbital_dummy_list = Find_All_Objects_Of_Type(orbital_dummy)

        for _, unit in pairs(orbital_dummy_list) do
            if TestValid(unit) and unit.Get_Planet_Location() == planet then
                unit.Despawn()
            end
        end
    end

    if already_upgraded == false then
        player.Give_Money(money)
    end

    return already_upgraded
end

--- Function that downgrades a structure and returns the player money.
--
-- @param planet planet, where the structure to downgrade is
-- @param player playerobject
-- @param previous_structure_name name of the structure to downgrade
-- @param downgraded_structure_name name of the downgraded structure
--
function Downgrade_Structure(planet, player, previous_structure_name, downgraded_structure_name)
    previous_structure = Find_Object_Type(previous_structure_name)
    previous_structure_list = Find_All_Objects_Of_Type(previous_structure)
    already_downgraded = false
    money = (previous_structure.Get_Build_Cost() - Find_Object_Type(downgraded_structure_name).Get_Build_Cost()) * 0.5 + 1

    for _,unit in pairs(previous_structure_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet then
            unit.Despawn()
            already_downgraded = true
            SpawnList({downgraded_structure_name}, planet, player, false, false)
            player.Give_Money(money)
        end
    end

    --Despawn all dummies, the orbital structures will ensure to respawn their assigned dummy
    orbital_dummy_name = previous_structure_name.."_ORBITAL_DUMMY"
    orbital_dummy = Find_Object_Type(orbital_dummy_name)
    if TestValid(orbital_dummy) then
        orbital_dummy_list = Find_All_Objects_Of_Type(orbital_dummy)

        for _, unit in pairs(orbital_dummy_list) do
            if TestValid(unit) and unit.Get_Planet_Location() == planet then
                unit.Despawn()
            end
        end
    end

    if already_downgraded == false then
        player.Give_Money(1)
    end

    return already_downgraded
end

--- Function that replaces a building for the Object that was build instead. Returns money to make up for the replaced
--  building.
--
-- @param planet planet, where the structure to be replaced is
-- @param player playerobject
-- @param replaced_structure name of the structure to be replaced
-- @param money amount of money the player gets, to make up for the replaced structure
-- @return true if a structure was replaced, false if not
--
function Replace_Structure(planet, player, replaced_structure, placed_structure, money)
    replaced_structure = Find_Object_Type(replaced_structure)
    replaced_structure_list = Find_All_Objects_Of_Type(replaced_structure)
    has_replaced = false

    for _,unit in pairs(replaced_structure_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet then
            has_replaced = true
            unit.Despawn()
            SpawnList({placed_structure}, planet, player, false, false)
            player.Give_Money(money)
        end
    end

    return has_replaced
end

--- Function used for a simple deletion of a building.
--
-- @param planet planet where the building to be removed is
-- @param player playerobject
-- @param building name of the building to be removed
-- @param money amount of money the player gets for removing the building
--
function Delete_Building(planet, player, object)
    delete_dummy_name = object.Get_Type().Get_Name()
    object_name = string.gsub(delete_dummy_name, "DELETE_STRUCTURE_", "")
    building = Find_Object_Type(object_name)
    building_list = Find_All_Objects_Of_Type(building)
    money = (building.Get_Build_Cost() / 2) + 1
    structure_removed = false

    for _,unit in pairs(building_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet and not structure_removed then
            unit.Despawn()
            structure_removed = true
            player.Give_Money(money)
            break
        end
    end

    --Despawn all dummies, the orbital structures will ensure to respawn their assigned dummy
    orbital_dummy_name = object_name.."_ORBITAL_DUMMY"
    orbital_dummy = Find_Object_Type(orbital_dummy_name)
    if TestValid(orbital_dummy) then
        orbital_dummy_list = Find_All_Objects_Of_Type(orbital_dummy)

        for _, unit in pairs(orbital_dummy_list) do
            if TestValid(unit) and unit.Get_Planet_Location() == planet then
                unit.Despawn()
                break
            end
        end
    end

    return structure_removed
end


function Delete_Building_By_Type(planet, player, object_type)
    object_name = object_type.Get_Name()
    building_list = Find_All_Objects_Of_Type(object_type)
    money = (object_type.Get_Build_Cost() / 2) + 1
    structure_removed = false

    for _,unit in pairs(building_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet and not structure_removed then
            unit.Despawn()
            structure_removed = true
            player.Give_Money(money)
            break
        end
    end

    --Despawn all dummies, the orbital structures will ensure to respawn their assigned dummy
    orbital_dummy_name = object_name.."_ORBITAL_DUMMY"
    orbital_dummy = Find_Object_Type(orbital_dummy_name)
    if TestValid(orbital_dummy) then
        orbital_dummy_list = Find_All_Objects_Of_Type(orbital_dummy)

        for _, unit in pairs(orbital_dummy_list) do
            if TestValid(unit) and unit.Get_Planet_Location() == planet then
                unit.Despawn()
            end
        end
    end

    return structure_removed
end







function Delete_First_Object_On_Planet(planet, player, object_list)
    structure_removed = false
    
    randomized_object_list = Randomize_List(object_list)

    for i, unit_name in pairs(randomized_object_list) do
        building = Find_Object_Type(unit_name)
        if Delete_Building_By_Type(planet, player, building) then
            return true
        end
    end

    return structure_removed
end







--- Function used to upgrade a unit.
--
-- @param planet planet where the unit to be upgraded is
-- @param player playerobject
-- @param unit_to_upgrade name of the unit, that should be upgraded
-- @param upgraded_unit name of the upgraded unit
--
function Upgrade_Unit(planet, player, unit_to_upgrade, upgraded_unit)
    unit_to_upgrade = Find_Object_Type(unit_to_upgrade)
    unit_to_upgrade_list = Find_All_Objects_Of_Type(unit_to_upgrade)
    units_removed = false

    for _,unit in pairs(unit_to_upgrade_list) do
        if TestValid(unit) and unit.Get_Planet_Location() == planet and not units_removed then
            units_removed = true
            unit.Despawn()
            SpawnList({upgraded_unit}, planet, player, false, false)
        end
    end
end