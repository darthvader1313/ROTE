-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/SellTacticalStructure.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/SellTacticalStructure.lua $
--
--    Original Author: Steve_Copeland
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

-- Sell a tactical structure if we no longer want it 
-- and the build pad is badly needed for something else.

function Definitions()
	
	Category = "Sell_Tactical_Structure"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
	}
	}

	structure = nil

end

function MainForce_Thread()

	MainForce.Set_As_Goal_System_Removable(false)	

	structure = Target.Get_Build_Pad_Contents()
	if structure then
		DebugMessage("%s -- Selling tactical structure: %s.", tostring(Script), tostring(structure))
		structure.Sell()
		
		-- Give some time for the open build pad and available funds
		-- perceptions to update before letting another sell plan be proposed.
		-- Also, just keep the AI from selling too often.
		Sleep(60)
	end
end




