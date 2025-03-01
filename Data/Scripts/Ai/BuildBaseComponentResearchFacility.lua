-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildBaseComponentResearchFacility.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildBaseComponentResearchFacility.lua $
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

-- This plan handles both the first research facility, built under the MajorItem purchase template scheme
-- and subsequent research facilities, built under Infrastructure, by other perceptions.

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Build_Base_Component_Research_Facility | Build_Base_Component_Research_Facility_2"
	IgnoreTarget = true
	TaskForce = {
	{
		"BaseForce",
		"E_Ground_Research_Facility | R_Ground_Research_Facility | Early_Empire_Ground_Research_Facility | Terrorists_Ground_Research_Facility | CIS_Remnant_Ground_Research_Facility | Trade_Federation_Ground_Research_Facility | Commerce_Guild_Ground_Research_Facility | Techno_Union_Ground_Research_Facility | Banking_Clan_Ground_Research_Facility | Mandalorians_Ground_Research_Facility | Galactic_Empire_Ground_Research_Facility | Rebel_Alliance_Ground_Research_Facility | Pyke_Syndicate_Ground_Research_Facility | Corporate_Sector_Ground_Research_Facility | Hapan_Consortium_Ground_Research_Facility | Crimson_Dawn_Ground_Research_Facility | Black_Sun_Ground_Research_Facility | Hutt_Cartel_Ground_Research_Facility | New_Republic_Ground_Research_Facility | Remnant_Rax_Ground_Research_Facility | Remnant_Gratloe_Ground_Research_Facility | Remnant_Loring_Ground_Research_Facility | Remnant_Adelhard_Ground_Research_Facility | First_Order_Ground_Research_Facility | Chiss_Ascendancy_Ground_Research_Facility = 1"
	}
	}

	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function BaseForce_Thread()
	DebugMessage("%s -- In BaseForce_Thread.", tostring(Script))
	
	Sleep(1)
	
	BaseForce.Set_As_Goal_System_Removable(false)
	AssembleForce(BaseForce)
	
	BaseForce.Set_Plan_Result(true)
	DebugMessage("%s -- BaseForce done!", tostring(Script));
	ScriptExit()
end

function BaseForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end


