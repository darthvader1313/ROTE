-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildBaseComponentBarracks.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/BuildBaseComponentBarracks.lua $
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

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 4

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Build_Initial_Groundbase_Only | Build_Base_Component_Barracks"
	IgnoreTarget = true
	TaskForce = {
	{
		"BaseForce",
		"E_Ground_Barracks | R_Ground_Barracks | Early_Empire_Ground_Barracks | Terrorists_Ground_Barraks | CIS_Remnant_Ground_Barraks | Trade_Federation_Ground_Barracks | Commerce_Guild_Ground_Barracks | Techno_Union_Ground_Barracks | Banking_Clan_Ground_Barracks | Mandalorians_Ground_Barracks | Galactic_Empire_Ground_Barracks | Rebel_Alliance_Ground_Barraks | Pyke_Syndicate_Ground_Barraks | Corporate_Sector_Ground_Barraks | Hapan_Consortium_Ground_Barracks | Crimson_Dawn_Ground_Barracks | Black_Sun_Ground_Barraks | Hutt_Cartel_Ground_Barracks | New_Republic_Ground_Barracks | Remnant_Rax_Ground_Barraks | Remnant_Gratloe_Ground_Barraks | Remnant_Loring_Ground_Barraks | Remnant_Adelhard_Ground_Barracks | First_Order_Ground_Barracks | Chiss_Ascendancy_Ground_Barracks = 1"
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

