-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildBaseComponentHeavyVehicleFactory.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildBaseComponentHeavyVehicleFactory.lua $
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


function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Build_Base_Component_Heavy_Vehicle_Factory"
	IgnoreTarget = true
	TaskForce = {
	{
		"BaseForce",
		"E_Ground_Heavy_Vehicle_Factory | R_Ground_Heavy_Vehicle_Factory | Early_Empire_Ground_Heavy_Vehicle_Factory | Terrorists_Ground_Heavy_Vehicle_Factory | CIS_Remnant_Ground_Heavy_Vehicle_Factory | Trade_Federation_Ground_Heavy_Vehicle_Factory | Commerce_Guild_Ground_Heavy_Vehicle_Factory | Techno_Union_Ground_Heavy_Vehicle_Factory | Banking_Clan_Ground_Heavy_Vehicle_Factory | Mandalorians_Ground_Heavy_Vehicle_Factory | Galactic_Empire_Ground_Heavy_Vehicle_Factory | Rebel_Alliance_Ground_Heavy_Vehicle_Factory | Pyke_Syndicate_Ground_Heavy_Vehicle_Factory | Corporate_Sector_Ground_Heavy_Vehicle_Factory | Hapan_Consortium_Ground_Heavy_Vehicle_Factory | Crimson_Dawn_Ground_Heavy_Vehicle_Factory | Black_Sun_Ground_Heavy_Vehicle_Factory | Hutt_Cartel_Ground_Heavy_Vehicle_Factory | New_Republic_Ground_Heavy_Vehicle_Factory | Remnant_Rax_Ground_Heavy_Vehicle_Factory | Remnant_Gratloe_Ground_Heavy_Vehicle_Factory | Remnant_Loring_Ground_Heavy_Vehicle_Factory | Remnant_Adelhard_Ground_Heavy_Vehicle_Factory | First_Order_Ground_Heavy_Vehicle_Factory | Chiss_Ascendancy_Ground_Heavy_Vehicle_Factory = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function BaseForce_Thread()
	DebugMessage("%s -- In BaseForce_Thread.", tostring(Script))
	
	Sleep(1)
	
--	BaseForce.Set_As_Goal_System_Removable(false)
	AssembleForce(BaseForce)
	
	BaseForce.Set_Plan_Result(true)
	DebugMessage("%s -- BaseForce done!", tostring(Script));
	ScriptExit()
end

function BaseForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end



