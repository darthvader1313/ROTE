-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/SpaceScout.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/SpaceScout.lua $
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

	Category = "Space_Scout"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce",
			"Fighter | Corvette = 1"
		}
	}

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	MainForce.Set_As_Goal_System_Removable(false)
	QuickReinforce(PlayerObject, AITarget, MainForce)
	
	MainForce.Activate_Ability("Turbo", true)
	MainForce.Activate_Ability("SPOILER_LOCK", true)
 	Try_Ability(MainForce, "STEALTH")
   
-- 	Removing this loop to give other plans a chance.  If the AI still wants to scout, the plan will be proposed again.
--	while AITarget do
		
		if TestValid(AITarget) then
			BlockOnCommand(MainForce.Move_To(AITarget))
			MainForce.Set_As_Goal_System_Removable(true)
			BlockOnCommand(MainForce.Explore_Area(AITarget), 10)
			MainForce.Set_Plan_Result(true)
		else
			DebugMessage("%s -- Unable to find a target for MainForce.", tostring(Script))
		end

--		AITarget = FindTarget(MainForce, "Space_Area_Needs_Scouting", "Tactical_Location", 0.8, 3000.0)
--	end
	
	ScriptExit()
end

function MainForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function MainForce_Target_Destroyed()
	DebugMessage("%s -- Target destroyed!  Exiting Script.", tostring(Script))
	ScriptExit()
end