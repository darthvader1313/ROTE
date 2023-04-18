-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/Patrol.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/Patrol.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 53121 $
--
--          $DateTime: 2006/08/30 16:32:34 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

ScriptPoolCount = 5

function Definitions()

	Category = "Patrol"
	IgnoreTarget = true
	AllowEngagedUnits = false
	TaskForce = 
	{
		{
			"MainForce",
			"Infantry | Air | Vehicle | LandHero = 1, 3"
		}
	}

end

function MainForce_Thread()

	BlockOnCommand(MainForce.Produce_Force())
	QuickReinforce(PlayerObject, AITarget, MainForce)
	
	Try_Ability(MainForce, "FORCE_CLOAK")
	Try_Ability(MainForce, "STEALTH")

	Set_Land_AI_Targeting_Priorities(MainForce)

	BlockOnCommand(MainForce.Attack_Move(AITarget))

	-- Guard the area until a higher desire goal pulls us away
        BlockOnCommand(MainForce.Guard_Target(AITarget))
end


-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)
	DebugMessage("%s -- Unit move finished: %s.", tostring(Script), tostring(unit))
	unit.Guard_Target(AITarget)
end


