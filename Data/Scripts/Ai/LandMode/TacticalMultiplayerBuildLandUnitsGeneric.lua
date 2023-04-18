-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/TacticalMultiplayerBuildLandUnitsGeneric.lua#7 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/TacticalMultiplayerBuildLandUnitsGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 56734 $
--
--          $DateTime: 2006/10/24 14:15:48 $
--
--          $Revision: #7 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Land_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"DenySpecialWeaponAttach"
		,"DenyHeroAttach"	
		,"RC_Level_Two_Tech_Upgrade | RC_Level_Three_Tech_Upgrade = 0,1"
		,"EC_Level_Two_Tech_Upgrade | EC_Level_Three_Tech_Upgrade = 0,1"
		,"UC_Level_Two_Tech_Upgrade | UC_Level_Three_Tech_Upgrade = 0,1"		
		,"Inferno_Team | Darth_Team_Land_MP | General_Veers_Team | Emperor_Palpatine_Team | Grand_Admiral_Thrawn_Team = 0,1"
		,"Han_Solo_Team_Land_MP | Rogue_One_Team | Ahsoka_Tano_Team | Luke_Skywalker_Jedi_Team | Garm_Bel_Iblis_Team = 0,1"
		,"Urai_Fen_Team | Bossk_Team | Silri_Team | Tyber_Zann_Team | IG88_Team = 0,1"
		,"Rebel_Infiltrator_Team | RN_Rebel_Pod_Walker_Company | Rebel_Pirate_Skiff_Team | Rebel_Pirate_Swamp_Speeder_Team | Rebel_Urban_Trooper_Squad | Urban_Plex_Soldier_Squad | Rebel_Commando_Squad | Rebel_Elite_Light_Squad | Desert_Plex_Soldier_Squad | Rebel_Deserttrooper_Squad | Alliance_Grenadier_Squad | Forest_Plex_Soldier_Squad | Rebel_Forest_trooper_Squad | Rebel_Vanguard_Infantry_Squad | Rebel_Rifleman_Squad | Rebel_RiflemanV2_Squad | Rebel_Saboteur_Squad | Snow_Plex_Soldier_Squad | Rebel_Snowtrooper_Squad | Rebel_Sniper_Squad | Rebel_Sniper_Squad_Forest | Rebel_Sniper_Snow_Squad | Rebel_Guard_Trooper_Squad | Rebel_Elite_Soldier_Squad | Rebel_T1B_Tank_Brigade | T2B_Tank_Brigade | Rebel_V_19_landspeeder_Brigade | Rebel_Tank_AAC_Brigade | Gallofree_HTT_Company | Snowspeeder_Company | Rebel_Gargantuan_Advanced_Brigade = 0,3"
		,"EN_Imperial_Pod_Walker_Company | Empire_Pirate_Skiff_Team | Empire_Pirate_Swamp_Speeder_Team | Imperial_Stormtrooper_Squad | Dark_Trooper_Squad | Imperial_Rifleman_Squad | Imperial_Clonetrooper_Squad | 501st_Stormtrooper_Squad | DarkTrooperSoldier_Squad | Imperial_Deathtrooper_Squad | Stormtrooper_flame_Squad | Imperial_Engineer_Squad | Magmatrooper_Squad | Mimban_Stormtrooper_Squad | Mustafar_Trooper_Squad | Imperial_Novatrooper_Squad | Imperial_Purge_Trooper_Squad | Sandtrooper_Squad | Shadowtrooper_Squad | Shock_Trooper_Squad | Shoretrooper_Squad | Snowtrooper_Squad | SuperCommando_Squad | AT_ST_Squad | Imperial_AT-DP_Squad | Imperial_ATDT_Squad | AT_PT_Company | HAV_Juggernaut_Company | TIE_Striker_Squadron | AT_AT_Company = 0,3"
		,"Canderous_Assault_Tank_Company | Destroyer_Droid_Company | Underworld_Disruptor_Merc_Squad | MAL_Rocket_Vehicle_Company | Underworld_Merc_Squad | Night_Sister_Company | MZ8_Pulse_Cannon_Tank_Company | Underworld_Pod_Walker_Company | Underworld_Skiff_Team | Underworld_Swamp_Speeder_Team = 0,3"
		,"Rebel_Speeder_Wing | Gallofree_HTT_Company | Rebel_MDU_Company = 0,1"
		,"HAV_Juggernaut_Company | Lancet_Air_Wing | Imperial_Anti_Aircraft_Company | Empire_MDU_Company = 0,1"
		,"Vornskr_Wolf_Pack | F9TZ_Cloaking_Transport_Company | Underworld_MDU_Company = 0,1"
		}
	}
	RequiredCategories = {"Infantry | Vehicle | LandHero | Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force())

	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 2000
	max_sleep_seconds = 30
	if tech_level == 2 then
		min_credits = 3000
		max_sleep_seconds = 45
	elseif tech_level >= 3 then
		min_credits = 4000
		max_sleep_seconds = 60
	end
	
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end
		
	ScriptExit()
end