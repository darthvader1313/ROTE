-- Author MaxiM --
require("PGStateMachine")
require("PGSpawnUnits")


function Definitions()
    ServiceRate = 1
	DebugMessage("%s -- In Definitions", tostring(Script))
    Define_State("State_Init", State_Init);
end


function State_Init(message)
    if message == OnEnter then
        if Get_Game_Mode() ~= "Land" then
            ScriptExit()
        end

        player = Object.Get_Owner()

        Object.Make_Invulnerable(true)
        Object.Prevent_All_Fire(true)
        Hide_Sub_Object(Object, 1, "Cylinder01")

        company_to_spawn = string.gsub(string.upper(Object.Get_Type().Get_Name()), "_SPAWNER", "")
        company_to_spawn = company_to_spawn.."_DUMMY"

        spawned_units = SpawnList({company_to_spawn}, Object.Get_Position(), player, true, true)

        Object.Change_Owner(Find_Player("NEUTRAL"))

        spawned_unit_amount = 0
        for _,spawned_unit in pairs(spawned_units) do
            if TestValid(spawned_unit) and spawned_unit.Get_Contained_Object_Count ~= nil then
                spawned_unit_object_count = spawned_unit.Get_Contained_Object_Count()
                DebugMessage("%s -- Adding amount %s from Object %s to spawned_unit_amount", tostring(Script), tostring(spawned_unit_object_count), tostring(spawned_unit))
                spawned_unit_amount = spawned_unit_amount + spawned_unit_object_count
            elseif TestValid(spawned_unit) then
                DebugMessage("%s -- Adding amount 1 from Object %s to spawned_unit_amount", tostring(Script), tostring(spawned_unit))
                spawned_unit_amount = spawned_unit_amount + 1
            end
        end

        cutoff_amount = spawned_unit_amount / 2
        DebugMessage("%s -- Starting spawned_unit_amount: %s cutoff_amount: %s", tostring(Script), tostring(spawned_unit_amount), tostring(cutoff_amount))
    elseif message == OnUpdate then
        existing_unit_amount = 0
        new_dummy_position = nil
        for _,spawned_unit in pairs(spawned_units) do
            if TestValid(spawned_unit) and spawned_unit.Get_Contained_Object_Count ~= nil then
                spawned_unit_object_count = spawned_unit.Get_Contained_Object_Count()
                new_dummy_position = spawned_unit.Get_Position()
                DebugMessage("%s -- Adding amount %s from Object %s to existing_unit_amount", tostring(Script), tostring(spawned_unit_object_count), tostring(spawned_unit))
                existing_unit_amount = existing_unit_amount + spawned_unit_object_count
            elseif TestValid(spawned_unit) then
                DebugMessage("%s -- Adding amount 1 from Object %s to existing_unit_amount", tostring(Script), tostring(spawned_unit))
                existing_unit_amount = existing_unit_amount + 1
                new_dummy_position = spawned_unit.Get_Position()
            end
        end

        DebugMessage("%s -- Current existing_unit_amount: %s cutoff_amount: %s", tostring(Script), tostring(existing_unit_amount), tostring(cutoff_amount))

        if existing_unit_amount < cutoff_amount then
            DebugMessage("%s -- Went below cutoff_amount, despawning company_dummy", tostring(Script))
            Object.Change_Owner(player)
            Object.Take_Damage(10000)
            ScriptExit()
        else
            DebugMessage("%s -- Above cutoff_amount, teleporting company_dummy", tostring(Script))
            if TestValid(new_dummy_position) then
                Object.Teleport(new_dummy_position)
            end
            Hide_Sub_Object(Object, 1, "Cylinder01")
        end
    end
end
