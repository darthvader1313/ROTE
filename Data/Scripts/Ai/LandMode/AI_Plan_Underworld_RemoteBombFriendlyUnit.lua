-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/AI_Plan_Underworld_RemoteBombFriendlyUnit.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/AI_Plan_Underworld_RemoteBombFriendlyUnit.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 45714 $
--
--          $DateTime: 2006/06/05 15:21:34 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////


require("pgevents")

ScriptPoolCount = 3

function Definitions()
	
	Category = "Remote_Bomb_Friendly_Unit"
	AllowEngagedUnits = true
	IgnoreTarget = true
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"		
		,"Underworld_Saboteur = 1"
	}
	}
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	QuickReinforce(PlayerObject, AITarget, MainForce)
	
	unit_table = MainForce.Get_Unit_Table()
	for i,unit in pairs(unit_table) do
		if not unit.Is_Ability_Ready("PLACE_REMOTE_BOMB") then
			MainForce.Release_Unit(unit)
		end
	end	
	
	BlockOnCommand(MainForce.Activate_Ability("PLACE_REMOTE_BOMB", Target))
	MainForce.Set_Plan_Result(true)

	if TestValid(Target) then
		rush_target = Find_Nearest(Target, PlayerObject, false)
		if TestValid(rush_target) then
			Target.Move_To(rush_target)
		end
	end	
	
end