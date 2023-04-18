-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/BurnUnitsLand.lua#8 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/BurnUnitsLand.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #8 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	
	AllowEngagedUnits = true
	IgnoreTarget = true
	Category = "Burn_Units_Land"
	TaskForce = {
	{
		"MainForce"
		, "TaskForceRequired"
		, "DenySpecialWeaponAttach"
	}
	}

end

function MainForce_Thread()

	-- Cheat to wrap the game up if this is a firesale
	if (EvaluatePerception("Should_Firesale_Land", PlayerObject) > 0) then
		reveal_ai = FogOfWar.Reveal_All(PlayerObject)
		MainForce.Set_As_Goal_System_Removable(false)
		
		-- We're now also revealing FOW here for the human player (was previously handled by a hard-coded system)
		-- Make sure that there isn't a scripted scenario underway that doesn't want automatic FOW reveals
		if Is_Multiplayer_Mode() == false and ((EvaluatePerception("Is_Skirmish_Mode", PlayerObject) == 1) or
						(GlobalValue.Get("Allow_AI_Controlled_Fog_Reveal") == 1)) then
			reveal_human = FogOfWar.Reveal_All(Find_Player("local"))
		end
	end

	-- Do this at least once (it may just be an attempt to burn off extra units, rather than a firesale)
	repeat
		-- Cancel all goals
		Purge_Goals(PlayerObject)
		
		--Eject garrisons from structures so they can be burned along with everything else.
		garrison_table = Find_All_Objects_Of_Type("CanContainGarrison", PlayerObject)
		if garrison_table then
			for i,unit in pairs(garrison_table) do
				if not unit.Is_Category("Vehicle") then
					unit.Eject_Garrison()
				end
			end
			Sleep(1)
		end		
		
		Sleep(1)
		
		-- Use all idle units, mapwide
		MainForce.Collect_All_Free_Units()
	
		-- form up any spread out infantry
		MainForce.Activate_Ability("SPREAD_OUT", false)
		
		Set_Land_AI_Targeting_Priorities(MainForce)
		
		-- Have each unit attack its nearest enemy structure until success or death
		nearest_enemy = Find_Nearest(MainForce, "InBase", PlayerObject, false)
		if not TestValid(nearest_enemy) then
			nearest_enemy = Find_Nearest(MainForce, PlayerObject, false)
		end
		
		while TestValid(nearest_enemy) do
			MainForce.Collect_All_Free_Units()
			BlockOnCommand(MainForce.Attack_Move(nearest_enemy), 20)
		end
			
		-- Only let this happen every so often
		Sleep(5) 
		MainForce.Set_Plan_Result(true)

	-- If this is a firesale condition, continue to burn off units
	-- This must be done within the same plan because we don't want to destroy the
	-- reveal objects turning FOW back on (which would result in the FOW being toggled repeatedly).
	until (EvaluatePerception("Should_Firesale_Land", PlayerObject) == 0)
	
	MainForce.Release_Forces(1.0)
	
	Sleep(30)	
end

-- Override default event to prevent plan from ending under firesale conditions
-- We want the fog of war reveal for the player to persist.
function MainForce_No_Units_Remaining()
end

function MainForce_Unit_Damaged(tf, unit, attacker, deliberate)
	--Override self preservation behavior - the whole purpose of this plan is to kill or be killed
end