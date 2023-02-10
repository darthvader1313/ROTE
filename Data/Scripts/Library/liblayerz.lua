local libLayerZ = { }

libLayerZ.neutralPlayer = "NEUTRAL"
libLayerZ.actualOwner = nil

--- Disables a given GameObject.
-- @tparam GameObject gameObject
-- @tparam Boolean spawnsFighters [optional]
function libLayerZ:disableObject(gameObject, spawnsFighters)
    if not gameObject.Get_Owner().Is_Human() then
        gameObject.Prevent_AI_Usage(true)
        self.actualOwner = gameObject.Get_Owner()
        gameObject.Change_Owner(Find_Player(self.neutralPlayer))
    end
    local spawns = false
    if spawnsFighters then
        spawns = spawnsFighters
    end
    if spawns then
        gameObject.Set_Garrison_Spawn(false)
    end
    gameObject.Make_Invulnerable(true)
    gameObject.Set_Selectable(false)
    gameObject.Prevent_All_Fire(true)
end

--- Enables a given GameObject.
-- @tparam GameObject gameObject
-- @tparam Boolean spawnsFighters [optional]
function libLayerZ:enableObject(gameObject, spawnsFighters)
    local spawns = false
    if spawnsFighters then
        spawns = spawnsFighters
    end
    gameObject.Make_Invulnerable(false)
    gameObject.Set_Selectable(true)
    gameObject.Prevent_All_Fire(false)
    if not gameObject.Get_Owner().Is_Human() then
        gameObject.Change_Owner(self.actualOwner)
        gameObject.Prevent_AI_Usage(false)
    end
    if spawns then
        gameObject.Set_Garrison_Spawn(true)
    end
end

--- Hides a given game object.
-- It's a wrapper around two consecutive GameObject.Hide(true) calls - don't even ask why we need those.
-- @tparam GameObject gameObject
function libLayerZ.hideObject(gameObject)
    gameObject.Hide(true)
    gameObject.Hide(true)
end

--- Teleports the given object to a randomized Z-Layer.
-- @tparam GameObject gameObject
function libLayerZ.setLayerZ(gameObject)
    local layerZObj = Spawn_Unit(Find_Object_Type("LAYER_Z_DUMMY"), gameObject.Get_Position(), gameObject.Get_Owner())
    layerZObj = layerZObj[1]
    local layer = "CORVETTE"
    if gameObject.Get_Type().Get_Name() == "SUBJUGATOR_BATTLECRUISER_E" or
    gameObject.Get_Type().Get_Name() == "SUBJUGATOR_BATTLECRUISER_R" or
    gameObject.Get_Type().Get_Name() == "SUBJUGATOR_BATTLECRUISER_P" or
    gameObject.Get_Type().Get_Name() == "SUBJUGATOR_BATTLECRUISER_U" or
    gameObject.Get_Type().Get_Name() == "ECLIPSE_STAR_DREADNOUGHT" or
    gameObject.Get_Type().Get_Name() == "EXECUTOR_STAR_DREADNOUGHT" or
    gameObject.Get_Type().Get_Name() == "HOSTILE_DREADNOUGHT" or
        gameObject.Get_Type().Get_Name() == "EXECUTOR_STAR_DREADNOUGHT_PIETT" then
        layer = "SSD_LAYER"
    elseif gameObject.Is_Category("Frigate") then
        layer = "FRIGATE"
    elseif gameObject.Is_Category("Capital") then
        layer = "CAPITAL"
    elseif gameObject.Is_Category("Super") then
        layer = "SUPER"
    end
    local layerMarkerTable = {
            ["SSD_LAYER"] = {
            -- TODO: Add bone names!
			"LAYER_00",
			"LAYER_01",
			"LAYER_02",
			"LAYER_03",
			"LAYER_04",
			"LAYER_05",
			"LAYER_06",
			"LAYER_07",
			"LAYER_08",
			"LAYER_09",
			"LAYER_10",
			"LAYER_11",
			"LAYER_12",
			"LAYER_13",
			"LAYER_14",
			"LAYER_15",
			"LAYER_16",
			"LAYER_17",
			"LAYER_18",
			"LAYER_19",
			"LAYER_20",
			"LAYER_21",
			"LAYER_22",
			"LAYER_23",
			"LAYER_24",
			"LAYER_25",
			"LAYER_26",
			"LAYER_27",
			"LAYER_28",
			"LAYER_29",
			"LAYER_30",
			"LAYER_31",
			"LAYER_32",
			"LAYER_33",
			"LAYER_34",
			"LAYER_35",
			"LAYER_36",
			"LAYER_37",
			"LAYER_38",
			"LAYER_39",
			"LAYER_40",
			"LAYER_41",
			"LAYER_42",
			"LAYER_43",
			"LAYER_44",
			"LAYER_45",
			"LAYER_46",
			"LAYER_47",
			"LAYER_48",
			"LAYER_49",
        },
        ["CORVETTE"] = {
            -- TODO: Add bone names!
			"LAYER_00",
			"LAYER_01",
			"LAYER_02",
			"LAYER_03",
			"LAYER_04",
			"LAYER_05",
			"LAYER_06",
			"LAYER_07",
			"LAYER_08",
			"LAYER_09",
			"LAYER_10",
			"LAYER_11",
			"LAYER_12",
			"LAYER_13",
			"LAYER_14",
			"LAYER_15",
			"LAYER_16",
			"LAYER_17",
			"LAYER_18",
			"LAYER_19",
			"LAYER_20",
			"LAYER_21",
			"LAYER_22",
			"LAYER_23",
			"LAYER_24",
			"LAYER_25",
			"LAYER_26",
			"LAYER_27",
			"LAYER_28",
			"LAYER_29",
			"LAYER_30",
			"LAYER_31",
			"LAYER_32",
			"LAYER_33",
			"LAYER_34",
			"LAYER_35",
			"LAYER_36",
			"LAYER_37",
			"LAYER_38",
			"LAYER_39",
			"LAYER_40",
			"LAYER_41",
			"LAYER_42",
			"LAYER_43",
			"LAYER_44",
			"LAYER_45",
			"LAYER_46",
			"LAYER_47",
			"LAYER_48",
			"LAYER_49",
        },
        ["FRIGATE"] = {
            -- TODO: Add bone names!
			"LAYER_00",
			"LAYER_01",
			"LAYER_02",
			"LAYER_03",
			"LAYER_04",
			"LAYER_05",
			"LAYER_06",
			"LAYER_07",
			"LAYER_08",
			"LAYER_09",
			"LAYER_10",
			"LAYER_11",
			"LAYER_12",
			"LAYER_13",
			"LAYER_14",
			"LAYER_15",
			"LAYER_16",
			"LAYER_17",
			"LAYER_18",
			"LAYER_19",
			"LAYER_20",
			"LAYER_21",
			"LAYER_22",
			"LAYER_23",
			"LAYER_24",
			"LAYER_25",
			"LAYER_26",
			"LAYER_27",
			"LAYER_28",
			"LAYER_29",
			"LAYER_30",
			"LAYER_31",
			"LAYER_32",
			"LAYER_33",
			"LAYER_34",
			"LAYER_35",
			"LAYER_36",
			"LAYER_37",
			"LAYER_38",
			"LAYER_39",
			"LAYER_40",
			"LAYER_41",
			"LAYER_42",
			"LAYER_43",
			"LAYER_44",
			"LAYER_45",
			"LAYER_46",
			"LAYER_47",
			"LAYER_48",
			"LAYER_49",
        },
        ["CAPITAL"] = {
            -- TODO: Add bone names!
			"LAYER_00",
			"LAYER_01",
			"LAYER_02",
			"LAYER_03",
			"LAYER_04",
			"LAYER_05",
			"LAYER_06",
			"LAYER_07",
			"LAYER_08",
			"LAYER_09",
			"LAYER_10",
			"LAYER_11",
			"LAYER_12",
			"LAYER_13",
			"LAYER_14",
			"LAYER_15",
			"LAYER_16",
			"LAYER_17",
			"LAYER_18",
			"LAYER_19",
			"LAYER_20",
			"LAYER_21",
			"LAYER_22",
			"LAYER_23",
			"LAYER_24",
			"LAYER_25",
			"LAYER_26",
			"LAYER_27",
			"LAYER_28",
			"LAYER_29",
			"LAYER_30",
			"LAYER_31",
			"LAYER_32",
			"LAYER_33",
			"LAYER_34",
			"LAYER_35",
			"LAYER_36",
			"LAYER_37",
			"LAYER_38",
			"LAYER_39",
			"LAYER_40",
			"LAYER_41",
			"LAYER_42",
			"LAYER_43",
			"LAYER_44",
			"LAYER_45",
			"LAYER_46",
			"LAYER_47",
			"LAYER_48",
			"LAYER_49",
        },
        ["SUPER"] = {
            -- TODO: Add bone names!
			"LAYER_00",
			"LAYER_01",
			"LAYER_02",
			"LAYER_03",
			"LAYER_04",
			"LAYER_05",
			"LAYER_06",
			"LAYER_07",
			"LAYER_08",
			"LAYER_09",
			"LAYER_10",
			"LAYER_11",
			"LAYER_12",
			"LAYER_13",
			"LAYER_14",
			"LAYER_15",
			"LAYER_16",
			"LAYER_17",
			"LAYER_18",
			"LAYER_19",
			"LAYER_20",
			"LAYER_21",
			"LAYER_22",
			"LAYER_23",
			"LAYER_24",
			"LAYER_25",
			"LAYER_26",
			"LAYER_27",
			"LAYER_28",
			"LAYER_29",
			"LAYER_30",
			"LAYER_31",
			"LAYER_32",
			"LAYER_33",
			"LAYER_34",
			"LAYER_35",
			"LAYER_36",
			"LAYER_37",
			"LAYER_38",
			"LAYER_39",
			"LAYER_40",
			"LAYER_41",
			"LAYER_42",
			"LAYER_43",
			"LAYER_44",
			"LAYER_45",
			"LAYER_46",
			"LAYER_47",
			"LAYER_48",
			"LAYER_49",
        },
    }
    local finalBoneTab = layerMarkerTable[layer]
    if finalBoneTab then
        local bone = finalBoneTab[GameRandom(1,table.getn(finalBoneTab))]
        if bone then
            gameObject.Teleport(layerZObj.Get_Bone_Position(bone))
        else
            gameObject.Teleport(layerZObj.Get_Position())
        end
    else
        gameObject.Teleport(layerZObj.Get_Position())
    end
    layerZObj.Despawn()
end

--- Only function that needs to be called from the gameobject script.
--- Call this function with the ":" operator!
-- @tparam GameObject gameObject
function libLayerZ:enterBattlefield(gameObject)
    self:disableObject(gameObject)
    gameObject.Cancel_Hyperspace()
    self.hideObject(gameObject)
    self.setLayerZ(gameObject)
    gameObject.Cinematic_Hyperspace_In(1)
    self:enableObject(gameObject)
end

return libLayerZ
