require("PGStateMachine")
require("PGSpawnUnits")
local LayerUtility = require("libLayerZ")

function Definitions()
    ServiceRate = 1
    Define_State("State_Init", State_Init)
end

function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Space" then
            ScriptExit()
        end
        LayerUtility:enterBattlefield(Object)
    end
end
