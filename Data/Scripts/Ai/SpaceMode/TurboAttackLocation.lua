-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TurboAttackLocation.lua#2 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TurboAttackLocation.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Andre_Arsenault $
--
--            $Change: 55814 $
--
--          $DateTime: 2006/10/02 16:55:52 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

--
-- Plan for corvettes to exploit their anti-fighter capabilities while using turbo or power to weapons.
--


function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	Category = "Turbo_Attack_Location"
	TaskForce = {
	-- First Task Force
	{
		"MainForce"
		,"DenyHeroAttach"
		,"Corellian_Corvette | Corellian_Gunboat | Tartan_Patrol_Cruiser | Slave_I | Sundered_Heart = 1, 3"
	}
	}

	IgnoreTarget = true
	AllowEngagedUnits = true

	needs_turbo = false
	was_attacked = false

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force());
	
	QuickReinforce(PlayerObject, AITarget, MainForce)

	MainForce.Enable_Attack_Positioning(false)
	
	-- Move into position while avoiding threat and without stopping for attacks on the way
	needs_turbo = true
	Try_Ability(MainForce, "Turbo")
	BlockOnCommand(MainForce.Move_To(AITarget))
	MainForce.Activate_Ability("Turbo", false)
	needs_turbo = false
	
	-- Clear out the area, while it remains favorable for this type of attack.
	MainForce.Set_As_Goal_System_Removable(false)
	while (EvaluatePerception("Good_Turbo_Attack_Location_Opportunity", PlayerObject, AITarget) > 0) do
		enemy = Find_Nearest(MainForce, "SmallShip", PlayerObject, false)
		--enemy = Find_Nearest(MainForce, "Fighter", PlayerObject, false)
		if TestValid(enemy) then -- FIX and (MainForce.Get_Distance(enemy) < 1000) then
			BlockOnCommand(MainForce.Attack_Target(enemy))
		else
			break
		end
	end
	
	-- Try to flee to a safe spot after the tactical strike
	if was_attacked then
		escape_loc = FindTarget(MainForce, "Space_Area_Is_Hidden", "Tactical_Location", 1.0, 5000.0)
		if escape_loc then
			needs_turbo = true
			MainForce.Activate_Ability("Turbo", true)	
			BlockOnCommand(MainForce.Move_To(escape_loc))
		end
	end

	ScriptExit()
end

-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)

	if Attacking and not unit.Has_Attack_Target() then
		DebugMessage("%s -- %s reached end of move, giving new order", tostring(Script), tostring(unit))
	
		-- Assist the tf with whatever is holding it up
		kill_target = FindDeadlyEnemy(tf)
		if TestValid(kill_target) then
			unit.Attack_Target(kill_target)
		else
			unit.Attack_Move(tf)
		end
	end
end

-- Try to recover use of turbo or power to weapons if it was lost while we were trying to use it.
function MainForce_Unit_Ability_Ready(tf, unit, ability)

	--MessageBox("%s -- Recovering %s for %s!", tostring(Script), ability, tostring(unit))
	if ability == "Turbo" and needs_turbo then
		unit.Activate_Ability("Turbo", true)
	end
	
	-- Default handler behavior is still desired
	Default_Unit_Ability_Ready(tf, unit, ability)
end

-- Register if we were attacked, and use default behavior as well.
function MainForce_Unit_Damaged(tf, unit, attacker, deliberate)
	if deliberate then
		was_attacked = true
	end
	
	-- Default handler behavior is still desired
	Default_Unit_Damaged(tf, unit, attacker, deliberate)
end
