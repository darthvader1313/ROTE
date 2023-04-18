-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildGroundDefensiveStructurePlan.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildGroundDefensiveStructurePlan.lua $
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
	
--	Category = "Build_Ground_Defensive_Structure"
	Category = "AlwaysOff"
	IgnoreTarget = true
	TaskForce = {
	{
		"StructureForce",
		"E_Ground_Base_Shield | R_Ground_Base_Shield | Empire_Ground_Shutter_Shield | Rebel_Ground_Shutter_Shield | E_Galactic_Turbolaser_Tower_Defenses | R_Galactic_Turbolaser_Tower_Defenses | Early_Empire_Ground_Base_Shield | Terrorists_Ground_Base_Shield | CIS_Remnant_Ground_Base_Shield | Black_Sun_Ground_Base_Shield | Hutt_Cartel_Ground_Base_Shield | Mandalorians_Ground_Base_Shield | Galactic_Empire_Ground_Base_Shield | Rebel_Alliance_Ground_Base_Shield | Pyke_Syndicate_Ground_Base_Shield | Corporate_Sector_Ground_Base_Shield | Hapan_Consortium_Ground_Base_Shield | Crimson_Dawn_Ground_Base_Shield | New_Republic_Ground_Base_Shield | Remnant_Rax_Ground_Base_Shield | Remnant_Gratloe_Ground_Base_Shield | Remnant_Loring_Ground_Base_Shield | Remnant_Adelhard_Ground_Base_Shield | First_Order_Ground_Base_Shield | Early_Empire_Galactic_Turbolaser_Tower_Defenses | Terrorists_Galactic_Turbolaser_Tower_Defenses | CIS_Remnant_Galactic_Turbolaser_Tower_Defenses | Black_Sun_Galactic_Turbolaser_Tower_Defenses | Hutt_Cartel_Galactic_Turbolaser_Tower_Defenses | Mandalorians_Galactic_Turbolaser_Tower_Defenses | Galactic_Empire_Galactic_Turbolaser_Tower_Defenses | Rebel_Alliance_Galactic_Turbolaser_Tower_Defenses | Pyke_Syndicate_Galactic_Turbolaser_Tower_Defenses | Corporate_Sector_Galactic_Turbolaser_Tower_Defenses | Hapan_Consortium_Galactic_Turbolaser_Tower_Defenses | Crimson_Dawn_Galactic_Turbolaser_Tower_Defenses | New_Republic_Galactic_Turbolaser_Tower_Defenses | Remnant_Rax_Galactic_Turbolaser_Tower_Defenses | Remnant_Gratloe_Galactic_Turbolaser_Tower_Defenses | Remnant_Loring_Galactic_Turbolaser_Tower_Defenses | Remnant_Adelhard_Galactic_Turbolaser_Tower_Defenses | First_Order_Galactic_Turbolaser_Tower_Defenses | Ground_Magnepulse_Cannon = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function StructureForce_Thread()
	DebugMessage("%s -- In StructureForce_Thread.", tostring(Script))
	
	Sleep(1)
	
	StructureForce.Set_As_Goal_System_Removable(false)
	AssembleForce(StructureForce)
	
	StructureForce.Set_Plan_Result(true)
	DebugMessage("%s -- StructureForce done!", tostring(Script));
	ScriptExit()
end

function StructureForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end