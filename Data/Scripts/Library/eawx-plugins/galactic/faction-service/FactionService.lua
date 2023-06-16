require("PGSpawnUnits")
require("deepcore/std/class")

---@class FactionService
FactionService = class()

---@param planets table<string, Planet>
function FactionService:new(planets)
    self.planets = {}
    for _, planet in pairs(planets) do
        self.planets[planet] = {
            owner = nil
        }
    end
end

---@param planet Planet
function FactionService:update(planet)
    local planet_stats = self.planets[planet]
    planet_stats.owner = planet:get_owner()

    if planet:get_owner() == Find_Player("Neutral") then
        return
    end

    self:attach_particle(planet)
end

function FactionService:attach_particle(planet)
    planet:get_game_object().Attach_Particle_Effect("GC_Display_" .. tostring(planet:get_owner().Get_Faction_Name()))
end
