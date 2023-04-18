-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/EwokHuntPlan.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/EwokHuntPlan.lua $
--
--    Original Author: Steve_Copeland
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
-- One basic plan, since there are only infantry units and probably not many of them.
-- They will attack with very low contrast ratio, but learn and eventually rally troops to escalate the attack.

function Definitions()
	
	Category = "Ewok_Hunt"
	MinContrastScale = 0.0001
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"Infantry= 1,50"
	}
	}
	
	--IgnoreTarget = false
	PerFailureContrastAdjust = 0.2
	AllowEngagedUnits = false
	
	closest_enemy = nil
	kill_target = nil
	start_loc = nil
	
	staging = false
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	MainForce.Set_Plan_Result(true)

	-- Don't seem to be getting an effective stage
	--DebugMessage("%s -- Got Stage: %s", tostring(Script), tostring(MainForce.Get_Stage()))
	--BlockOnCommand(MainForce.Move_To(MainForce.Get_Stage()), 10)	

	-- Just stage at the spawner nearest the plan's target, if there is one.
	spawner = Find_Nearest(AITarget, "Ewok_Spawn_House")
	if TestValid(spawner) then
		staging = true
		BlockOnCommand(MainForce.Attack_Move(spawner), 10)
		staging = false
	end

	BlockOnCommand(MainForce.Attack_Move(AITarget))

	-- Give the Unit_Move_Finished a chance to find further targets near the AITarget zone
	Sleep(10)
	
	ScriptExit()
end

-- Make sure that units don't sit idle at the end of their move order, waiting for others to let the BlockOn finish
function MainForce_Unit_Move_Finished(tf, unit)

	-- Only perform attack move fix-up behavior if we're not trying to stage units.
	if staging then
		return
	end

	DebugMessage("%s -- %s reached end of move, giving new order", tostring(Script), tostring(unit))

	-- We want this unit to release and attack something, whatever is attacking us or just something close
	kill_target = FindDeadlyEnemy(tf)
	if not TestValid(kill_target) then
		kill_target = Find_Nearest(unit, PlayerObject, false)
	end
	if TestValid(kill_target) then
		unit.Attack_Move(kill_target)
		tf.Release_Unit(unit)
		DebugMessage("%s-- Unit %s only Attack_Move to %s", tostring(Script), tostring(unit), tostring(kill_target))
	end
end

function MainForce_No_Units_Remaining()
	--MessageBox("%s -- All units dead or non-buildable.  RAISING CONTRAST. Abandonning plan.", tostring(Script))
	MainForce.Set_Plan_Result(false) 
	ScriptExit()
end
