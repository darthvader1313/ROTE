-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TacticalMultiplayerBuildSpaceUnitsGeneric.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/TacticalMultiplayerBuildSpaceUnitsGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 54441 $
--
--          $DateTime: 2006/09/13 15:08:39 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Space_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
		{
		"ReserveForce"
		,"RS_Level_Two_Starbase_Upgrade | RS_Level_Three_Starbase_Upgrade | RS_Level_Four_Starbase_Upgrade | RS_Level_Five_Starbase_Upgrade = 0,1"
		,"ES_Level_Two_Starbase_Upgrade | ES_Level_Three_Starbase_Upgrade | ES_Level_Four_Starbase_Upgrade | ES_Level_Five_Starbase_Upgrade = 0,1"
		,"US_Level_Two_Starbase_Upgrade | US_Level_Three_Starbase_Upgrade | US_Level_Four_Starbase_Upgrade | US_Level_Five_Starbase_Upgrade = 0,1"
		,"Pirate_Fighter_Squadron | IPV1_SYSTEM_PATROL_CRAFT | PIRATE_FRIGATE = 0,2"
		,"Imperial_Arquitens | Imperial_Escort_Carrier | Victory_Destroyer | VictoryII_Destroyer | Victory_DestroyerIII | Raider_Corvette | Imperial_Gozanti_Cruiser | Immobilizer | Template_Dreadnaught | TIE_fighter_advanced_Squadron | TIE_Interceptor_Royal_Squadron | TIE_PrototypeX1_Squadron | TIE_Defender_Squadron | Star_Destroyer_1_Template | Generic_Star_Destroyer | Star_Destroyer-III | Tector_Star_Destroyer | Venator | Star_Destroyer_Xyston | Star_Destroyer_XystonII | Executor_Super_Star_Destroyer_Regular | Finalizer_Star_Destroyer | Allegiance | Dominator = 0,3"
		,"Rebel_X-Wing_Squadron | Y-Wing_Squadron | A_Wing_Squadron | Corellian_Corvette | Pelta_Frigate | Dauntless | B-Wing_Squadron | Liberator_Carrier | Nebulon_B_Frigate | MC40b | MC40 | Calamari_MC60 | Rebel_U_Wing_Squadron | Home_One_Regular | Mc50 | Calamari_MC75 | Mc80_Liberty | Mc80a_Calamari_Cruiser | MC_80b | Mc90 | Mc90B_Cruiser | MC_Heavy_Carrier | Profundity_Cruiser | Viscount_Star_Defender  = 0,3"
		,"Rogue_Squadron_Space | Sundered_Heart | Han_Solo_Team_Space_MP | Home_One = 0,1"
		,"Boba_Fett_Team_Space_MP | Accuser_Star_Destroyer | Darth_Team_Space_MP | Executor_Super_Star_Destroyer | Admonitor_Star_Destroyer = 0,1"
		,"Bossk_Team_Space_MP | IG88_Team_Space_MP | The_Peacebringer = 0,1" 
				
				
		}
	}
	RequiredCategories = {"Fighter | Bomber | Corvette | Frigate | Capital | SpaceHero"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
		
	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 2000
	max_sleep_seconds = 30
	if tech_level == 2 then
		min_credits = 4000
		max_sleep_seconds = 50
	elseif tech_level >= 3 then
		min_credits = 6000
		max_sleep_seconds = 80
	end
	
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end

	ScriptExit()
end