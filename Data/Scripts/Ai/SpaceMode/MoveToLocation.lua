-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/MoveToLocation.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/MoveToLocation.lua $
--
--    Original Author: Steve Copeland
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

	Category = "Return_To_Base | Patrol_Structure_Space"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"
			,"Fighter | Corvette | Frigate | Capital = 1, 5"
		}
	}

	-- Needed for fighters to return to base, because they're frequently given anti-idle orders to attack nearest
	AllowEngagedUnits = true

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	-- Move the target to the desired location, with low tolerance threat avoidance.
	Try_Ability(MainForce, "STEALTH")
	BlockOnCommand(MainForce.Move_To(AITarget, 10))
	MainForce.Guard_Target(AITarget)
	MainForce.Set_Plan_Result(true)
	Sleep(5)
end

