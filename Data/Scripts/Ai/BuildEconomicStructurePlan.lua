-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildEconomicStructurePlan.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildEconomicStructurePlan.lua $
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
	
	Category = "Build_Economic_Structure"
	IgnoreTarget = true
	TaskForce = {
	{
		"StructureForce",
		"Rebel_Ground_Mining_Facility | Empire_Ground_Mining_Facility | Early_Empire_Ground_Mining_Facility | Terrorists_Ground_Mining_Facility | CIS_Remnant_Ground_Mining_Facility | Black_Sun_Ground_Mining_Facility | Hutt_Cartel_Ground_Mining_Facility | Mandalorians_Ground_Mining_Facility | Galactic_Empire_Ground_Mining_Facility | Rebel_Alliance_Ground_Mining_Facility | Pyke_Syndicate_Ground_Mining_Facility | Corporate_Sector_Ground_Mining_Facility | Hapan_Consortium_Ground_Mining_Facility | Crimson_Dawn_Ground_Mining_Facility | New_Republic_Ground_Mining_Facility | Remnant_Rax_Ground_Mining_Facility | Remnant_Gratloe_Ground_Mining_Facility | Remnant_Loring_Ground_Mining_Facility | Remnant_Adelhard_Ground_Mining_Facility | First_Order_Ground_Mining_Facility | Early_Empire_Space_Facility | Terrorists_Space_Facility | CIS_Remnant_Space_Facility | Black_Sun_Space_Facility | Hutt_Cartel_Space_Facility | Mandalorians_Space_Facility | Galactic_Empire_Space_Facility | Rebel_Alliance_Space_Facility | Pyke_Syndicate_Space_Facility | Corporate_Sector_Space_Facility | Hapan_Consortium_Space_Facility | Crimson_Dawn_Space_Facility | New_Republic_Space_Facility | Remnant_Rax_Space_Facility | Remnant_Gratloe_Space_Facility | Remnant_Loring_Space_Facility | Remnant_Adelhard_Space_Facility | First_Order_Space_Facility = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function StructureForce_Thread()
	DebugMessage("%s -- In StructureForce_Thread.", tostring(Script))
	
	Sleep(1)
	
--	StructureForce.Set_As_Goal_System_Removable(false)
	AssembleForce(StructureForce)
	
	StructureForce.Set_Plan_Result(true)
	DebugMessage("%s -- StructureForce done!", tostring(Script));
	ScriptExit()
end

function StructureForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end