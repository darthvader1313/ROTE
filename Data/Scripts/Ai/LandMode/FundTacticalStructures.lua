-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/FundTacticalStructures.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/FundTacticalStructures.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 51272 $
--
--          $DateTime: 2006/08/12 10:24:05 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

-- Provide nominal funding for tactical structure building from galactic cash.  Note that
-- additional cash may still be provided for by unspent cash in various budgets as defined
-- in the player template.

function Definitions()
	
	Category = "Fund_Tactical_Structures"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
	}
	}

end

function MainForce_Thread()

	-- Never remove this plan
	MainForce.Set_As_Goal_System_Removable(false)	
    
	if PlayerObject.Get_Credits() == 0 then
		
		-- Pirates work as individual cells and have no galactic coordination of cash.
		-- Also, they always have a level one base, so they get a fixed amount of free cash for structures.
		-- if EvaluatePerception("Is_Pirate", PlayerObject, Target) then
		if PlayerObject.Get_Faction_Name() == "PIRATES" or PlayerObject.Get_Faction_Name() == "HUTTS" then
			cash_amount = 15000
			PlayerObject.Give_Money(cash_amount)
			DebugMessage("%s -- Tactical funding (free for Pirates) %.2f", tostring(Script), cash_amount)
			
		-- Other factions pull a calculated amount of funds from their galactic pool.
		else
			cash_amount = Evaluate_In_Galactic_Context("Land_Tactical_Budget_Clamped", PlayerObject)
			--cash_amount = Evaluate_In_Galactic_Context("Land_Tactical_Budget", PlayerObject)
			PlayerObject.Release_Credits_For_Tactical(cash_amount)
			DebugMessage("%s -- Tactical funding %.2f", tostring(Script), cash_amount)
		end
	end
		
	-- Don't let this script exit, so that each instance of land tactical will only be funded once
	while true do
		Sleep(20)
	end
end



