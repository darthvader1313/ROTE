-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/HideTransports.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/HideTransports.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 44927 $
--
--          $DateTime: 2006/05/23 17:53:49 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()

	AllowEngagedUnits = false
	Category = "Hide_Transports"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce",
			"Transport = 1,4"
		},
		{
			"EscortForce",
			"Fighter = 0,2"
		}
	}

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	while true do
		AITarget = FindTarget(MainForce, "Space_Area_Is_Hidden", "Tactical_Location", 0.8, 5000.0)
		
		if TestValid(AITarget) then		
			Try_Ability(MainForce, "STEALTH")
			MainForce.Attack_Target(AITarget, 1)
			Sleep(10)
		else
			Sleep(0.1)
		end
	end
	
	ScriptExit()
end 

function EscortForce_Thread()
	BlockOnCommand(EscortForce.Produce_Force())
	
	-- Give an initial order to put the escorts in a state that the Escort function expects
	EscortForce.Guard_Target(MainForce)

	EscortAlive = true
	while EscortAlive do
		Escort(EscortForce, MainForce)
	end
end

function MainForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function EscortForce_No_Units_Remaining()
	EscortAlive = false
end