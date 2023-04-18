-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LiftBlockadePlan.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LiftBlockadePlan.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Andre_Arsenault $
--
--            $Change: 37816 $
--
--          $DateTime: 2006/02/15 15:33:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

--
-- Galactic Mode Conquer Script
--

function Definitions()
	
	Category = "Lift_Blockade"

	TaskForce = {
	-- First Task Force
	{
		"MainForce"						-- Name of the MainForce, Variable and thread function.
		,"MinimumTotalSize = 4"
		,"MinimumTotalForce = 2500"					
		,"Frigate | Capital | Corvette | Fighter | Bomber = 100%"
	}
	}
	RequiredCategories = { "Corvette | Frigate | Capital | Super" }	
end

function MainForce_Thread()
	
	-- Converge all task force units upon the target simultaneously
	SynchronizedAssemble(MainForce)
	if MainForce.Get_Force_Count() > 0 then
		MainForce.Set_Plan_Result(true)
		MainForce.Release_Forces(1.0)
	end
	
	Sleep(120)
	
	ScriptExit()
end

function MainForce_Production_Failed(tf, failed_object_type)
	ScriptExit()
end

function MainForce_No_Units_Remaining()
	MainForce.Set_Plan_Result(false)
end
