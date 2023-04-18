-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/HideSurpriseUnits.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/HideSurpriseUnits.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 44927 $
--
--          $DateTime: 2006/05/23 17:53:49 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()

	AllowEngagedUnits = false
	Category = "Hide_Surprise_Units"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce",
			"Marauder_Missile_Cruiser | Broadside_Class_Cruiser = 0,2",
			"Bomber = 0, 2"
		},
		{
			"EscortForce",
			"Fighter = 0,2"
		}
	}
	
	-- Make sure we don't have an EscortForce only
	RequiredCategories = {"Bomber | Corvette"} 

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	-- What easier way to keep units hidden than simply not bringing them to the map?
	if MainForce.Are_All_Units_On_Free_Store() == false then
		ScriptExit()
	end
	
	obscured = false
	repeat
		
		if obscured and not FindDeadlyEnemy(MainForce) then
			Sleep(10)
			MainForce.Set_Plan_Result(true)
		else
			Sleep(1)
		end

		Try_Ability(MainForce, "STEALTH")
		BlockOnCommand(MainForce.Move_To(AITarget, 10))
		obscured = Obscure(MainForce, 1500, true, "ASTEROID | NEBULA")
		
		-- Try to find a nearby hiding spot, but look farther if none found
		AITarget = FindTarget(MainForce, "Desire_To_Hide_At_Location", "Tactical_Location", 0.8, 1000)
		if not AITarget then
			AITarget = FindTarget(MainForce, "Desire_To_Hide_At_Location", "Tactical_Location", 0.8, 4000)
		end
		
	-- For some reason zeroed desirability isn't propagating to this plan and cancelling it, so use a failsafe
	until (not AITarget)-- or (EvaluatePerception("Game_Age", PlayerObject) > 80)

	ScriptExit()
end 


-- Always run away from any attacker
function MainForce_Unit_Damaged(tf, unit, attacker, deliberate)
	if TestValid(unit) and TestValid(attacker) then
		GoKite(tf, unit, Project_By_Unit_Range(attacker, unit), false)
	end
end


function EscortForce_Thread()
	BlockOnCommand(EscortForce.Produce_Force())
	
	-- Give an initial order to put the escorts in a state that the Escort function expects
	EscortForce.Guard_Target(MainForce)

	EscortAlive = true
	while EscortAlive do
		Escort(EscortForce, MainForce)
	end
end

function MainForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function EscortForce_No_Units_Remaining()
	EscortAlive = false
end

