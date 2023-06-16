require("deepcore/std/class")

---@class Planet
---@field private gameObject GameObject
---@field private __step_calculated boolean
---@field private __orbital_structures_in_current_step table<string, number>
Planet = class()


---@param name string
---@param human_player PlayerObject
function Planet:new(name)
    ---@private
    self.gameObject = FindPlanet(name)

    ---@private
    self.human_player = Find_Player("local")

    ---@private
    self.__step_calculated = false

    ---@private
    self.__orbital_structures_in_current_step = {}

    ---@private
    self.__readable_name = self:get_readable_name()
end

function Planet:get_owner()
    return self.gameObject.Get_Owner()
end

function Planet:get_game_object()
    return self.gameObject
end

function Planet:get_name()
    return self.gameObject.Get_Type().Get_Name()
end

function Planet:get_readable_name()
    if self.__readable_name then
        return self.__readable_name
    end

    local name = self:get_name()
    name = string.gsub(name, "_", " ")
    self.__readable_name = name

    return name
end

function Planet:has_structure(structure_name)
    local all_structures = Find_All_Objects_Of_Type(structure_name)
    for _, structure in pairs(all_structures) do
        if structure.Get_Planet_Location() == self.gameObject then
            return true
        end
    end

    return false
end

function Planet:get_orbital_structure_types_and_amount()
    local object_library = ModContentLoader.get("GameObjectLibrary")
    local structure_information = {}
    for structure_name, structure_info in pairs(object_library.OrbitalStructures) do
        structure_information[structure_name] = self:__count_structure_occurences(structure_name, structure_info)
    end

    return structure_information
end

function Planet:get_orbital_structure_information()
    if self.__step_calculated then
        return self.__orbital_structures_in_current_step
    end

    local object_library = ModContentLoader.get("GameObjectLibrary")
    local structure_information = {}
    for structure_name, structure_info in pairs(object_library.OrbitalStructures) do
        structure_information[structure_info.Text] = self:__count_structure_occurences(structure_name, structure_info)
    end

    self.__orbital_structures_in_current_step = structure_information

    return structure_information
end

---Returns the number of structures on the planet with the given structure name. Tries to evaluate an AI Equation to determine the amount. Counts manually otherwise
---@private
---@param structure_name string The name of the structure
---@param structure_info table<string, any> The structure information from GameObjectLibrary
function Planet:__count_structure_occurences(structure_name, structure_info)
    if structure_info.Equation then
        return EvaluatePerception(structure_info.Equation, self.human_player, self.gameObject)
    end

    return self:__count_structures_manually(structure_name)
end

---Returns the number of structures with the given name on the Planet. Serves as fallback if no AI Equation is available.
---@private
---@param structure_name string The name of the structure
function Planet:__count_structures_manually(structure_name)
    local all_structures = Find_All_Objects_Of_Type(structure_name)
    local structures_on_planet = 0
    for _, structure in pairs(all_structures) do
        if structure.Get_Planet_Location() == self.gameObject then
            structures_on_planet = structures_on_planet + 1
        end
    end

    return structures_on_planet
end

return Planet
