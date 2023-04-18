-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/AI_Plan_Underworld_DeploySaboteur.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/AI_Plan_Underworld_DeploySaboteur.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 54926 $
--
--          $DateTime: 2006/09/19 11:50:46 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	
	--The mechanisms for corrupting a planet and for sabotaging it are identical - which we perform depends on
	--the current corruption state of the target.  This is assessed at the perception level and by the time
	--we execute the plan it makes no difference to our behavior
	Category = "Corrupt_Planet | Sabotage_Planet"
	IgnoreTarget = true
	TaskForce = {
		{
			"MainForce",
			"DenyHeroAttach",
			"Underworld_Saboteur_Team = 1"
		}
	}
end

function MainForce_Thread()
	AssembleForce(MainForce)
	BlockOnCommand(MainForce.Move_To(Target))
	MainForce.Activate_Ability()
	
	Sleep(10)
	
	if MainForce.Get_Goal_Type_Name() == "Corrupt_Planet" then
		if Target.Is_Corrupted() then	
			MainForce.Set_Plan_Result(true)	
		end
	end
	
	--Always treat sabotage as failing so that we won't repeatedly perform it on the same planet (cost goes up)
end

function MainForce_Production_Failed(tf, failed_object_type)
	ScriptExit()
end