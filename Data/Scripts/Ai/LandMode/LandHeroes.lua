-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/LandHeroes.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/LandHeroes.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 52591 $
--
--          $DateTime: 2006/08/25 14:25:09 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

-- This plan just tries to land any purchased heroes for skirmish (they don't count toward unit cap)

function Definitions()
	
	Category = "Land_Heroes"
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"LandHero = 1,5"
	}
	}
	
	IgnoreTarget = true
	AllowEngagedUnits = false
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	--Immediately release anybody that was already landed
	MainForce.Release_Forces(1.0)

	-- find something to reinforce near
	friendly_loc = FindTarget(MainForce, "Space_Area_Is_Hidden", "Tactical_Location", 1.0)
	if not TestValid(friendly_loc) then
		friendly_loc = FindTarget(MainForce, "Is_Friendly_Start", "Tactical_Location", 1.0)
	end
	if not TestValid(friendly_loc) then
		ScriptExit()
	end
	
	WaitForAllReinforcements(MainForce, friendly_loc)
	
	MainForce.Release_Forces(1)
    MainForce.Set_Plan_Result(true)
	Sleep(15)
end




