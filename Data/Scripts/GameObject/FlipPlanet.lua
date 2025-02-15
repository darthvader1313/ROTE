--*****************************************************************************
--*    Упрощённый скрипт инициализации галактической кампании
--*   @Author:    [EaWX]Pox (адаптация)
--*   @License:   MIT
--*****************************************************************************

require("PGDebug")
require("PGStoryMode")

-- Конфигурация
local PLUGIN_FOLDER = "eawx-plugins/galactic/"
local SERVICE_RATE = 0.1

function Definitions()
    DebugMessage("%s -- Инициализация скрипта", tostring(Script))
    StoryModeEvents = {Universal_Story_Start = Main_GC}
end

function Main_GC(message)
    if message == OnEnter then
        -- Инициализация плагинов
        local plugins = Load_Plugins(PLUGIN_FOLDER)
        
        -- Контекст для передачи данных
        local context = {
            planets = {},
            faction = "Empire"
        }

        -- Инициализация планет
        Init_Planets(context)
        
        -- Запуск плагинов
        for _, plugin in pairs(plugins) do
            if plugin.init then
                plugin.init(context)
            end
        end

        -- Запуск периодического обновления
        Timer_Thread()
    end
end

function Load_Plugins(folder)
    local plugins = {}
    
    -- Пример списка плагинов (реализация через game API)
    local plugin_files = {
        "economy_plugin.lua",
        "military_plugin.lua",
        "diplomacy_plugin.lua"
    }

    for _, file in ipairs(plugin_files) do
        local ok, plugin = pcall(require, folder .. file:gsub(".lua", ""))
        if ok then
            table.insert(plugins, plugin)
            DebugMessage("Загружен плагин: " .. file)
        else
            DebugMessage("Ошибка загрузки " .. file .. ": " .. tostring(plugin))
        end
    end
    
    return plugins
end

function Init_Planets(context)
    -- Пример инициализации планет
    local planet_names = {"Coruscant", "Tatooine", "Hoth"}
    
    for _, name in ipairs(planet_names) do
        context.planets[name] = {
            name = name,
            owner = "Neutral",
            resources = math.random(50, 200)
        }
    end
end

function Timer_Thread()
    while true do
        Update_Game_Logic()
        Wait(SERVICE_RATE)
    end
end

function Update_Game_Logic()
    -- Здесь можно добавить обновление состояния игры
    -- Например: проверка условий победы, экономические расчёты
end