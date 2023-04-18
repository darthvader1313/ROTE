-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/CleanUpDumb.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/CleanUpDumb.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Andre_Arsenault $
--
--            $Change: 55814 $
--
--          $DateTime: 2006/10/02 16:55:52 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

--
-- This should be a low desirability plan, to engage otherwise idle units after all enemies are being handled.
-- This plan does not consider much and should only be enacted once the tactical outcome is obvious.
--

function Definitions()
	
	Category = "Clean_Up"
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"Infantry | Vehicle | Air = 1,50"
		,"LandHero = 0,10"
	}
	}
	
	IgnoreTarget = true
	AllowEngagedUnits = false
	
	closest_enemy = nil
	kill_target = nil
	start_loc = nil
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
		
	QuickReinforce(PlayerObject, AITarget, MainForce)

	Set_Land_AI_Targeting_Priorities(MainForce)

	-- This is a global plan, so we must find our own target
	closest_enemy = Find_Nearest(MainForce, PlayerObject, false)

	if TestValid(closest_enemy) then
		-- Assign appropriate targeting priorities here, once we get the ability to do this per unit type
		BlockOnCommand(MainForce.Attack_Move(closest_enemy))
	end
	
	ScriptExit()
end

-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)

	Default_Unit_Move_Finished(tf, unit)

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
