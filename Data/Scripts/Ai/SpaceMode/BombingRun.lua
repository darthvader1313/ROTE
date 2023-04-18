-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/BombingRun.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/SpaceMode/BombingRun.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 52287 $
--
--          $DateTime: 2006/08/22 10:41:09 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()

	AllowEngagedUnits = false
	IgnoreTarget = true
	Category = "Bomb_Unit"
	TaskForce = {
	{
		"BomberForce"						
		,"Bomber = 3,10"
	},
	{
		"FighterForce"		
		,"Fighter = 1,4"
	}
	}

	direction_table = {
		"back"
		,"left"
		,"right" 
	}

	convenient_space_field_range = 2000
	path_through = "ASTEROID | NEBULA" -- "ASTEROID | NEBULA | ION_FIELD"
	time_to_drop_bombs = 2
	bombers_reinforced = false
	rallied = false
	send_fighters = false
	
end

function BomberForce_Thread()

	BlockOnCommand(BomberForce.Produce_Force())
	BomberForce.Set_As_Goal_System_Removable(false)

	QuickReinforce(PlayerObject, AITarget, BomberForce, FighterForce)
	bombers_reinforced = true
	
	-- Do some setup if the bombers arent' already too close
	-- Also, don't bother with this setup if the tactical game is well underway
	if (BomberForce.Get_Distance(AITarget) > 1000) and (EvaluatePerception("Game_Age", PlayerObject) < 360) then

		BomberForce.Set_Targeting_Priorities("Bomber_Hit_And_Run", "Bomber")
		send_fighters = true

		BomberForce.Activate_Ability("SPOILER_LOCK", true)
		
		-- Try to let the fighters get ahead of the bombers
		while not Fighters_Closer_To_Target() and not Fighters_Engaged_Target() do
			Obscure(BomberForce, 1000, true, "ASTEROID | NEBULA")
			Sleep(1)
		end
    
	end

	DebugMessage("bomber force target: %s", tostring(AITarget))
	BlockOnCommand(BomberForce.Attack_Target(AITarget, BomberForce.Get_Self_Threat_Max()))
	
	ScriptExit()
end


function Fighters_Closer_To_Target()
	if BomberForce.Get_Force_Count == 0 or (not TestValid(FighterForce)) or FighterForce.Get_Force_Count == 0 then
		return false
	elseif FighterForce.Get_Distance(AITarget) < BomberForce.Get_Distance(AITarget) then
		return true
	end
end


function Fighters_Engaged_Target()
	return TestValid(FighterForce) and (FindDeadlyEnemy(FighterForce) == AITarget)
end


-- Handle a hardpoint achieving range on the attack target
function BomberForce_Hardpoint_Target_In_Range(tf, unit, target)

	BomberForce.Activate_Ability("SPOILER_LOCK", false)

	-- Create a timer for this squadron to flee after it's had a chance to drop the rest of it's bombs
	--Register_Timer(Repeat_Attack, time_to_drop_bombs, unit)
end


function Repeat_Attack(unit)
	run_target = FindTarget(BomberForce, "Good_Space_Artillery_Area", "Tactical_Location", 0.8, 3000.0)
	if run_target then
		MessageBox("%s %.3f -- Bomber squad fleeing to %s.", tostring(Script), GetCurrentTime(), tostring(run_target))
		GoKite(BomberForce, unit, run_target, false)
		Sleep(4)
	end
	
	unit.Attack_Target(AITarget)
	
	-- Once one attack is done, we'll let desirability drops end the plan
	BomberForce.Set_As_Goal_System_Removable(true)
end


function FighterForce_Thread()
	BlockOnCommand(FighterForce.Produce_Force())

	QuickReinforce(PlayerObject, AITarget, FighterForce, BomberForce)

   	SetClassPriorities(FighterForce, "Attack_Move")
   	
	Try_Ability(FighterForce, "STEALTH")
	
	if (EvaluatePerception("Game_Age", PlayerObject) < 360) then
		while not bombers_reinforced do
			reinforce_target = FindTarget(FighterForce, "Space_Area_Is_Hidden", "Tactical_Location", 0.8, 3000.0)
			if reinforce_target then
				BlockOnCommand(FighterForce.Move_To(reinforce_target), -1, Bombers_Have_Reinforced)
			else
				Sleep(1)
			end
		end
	
	--	BlockOnCommand(FighterForce.Move_To(BomberForce, FighterForce.Get_Self_Threat_Max()))
		rallied = true
	
		while not send_fighters do
			Escort(FighterForce, BomberForce)
		end
	end

	BlockOnCommand(FighterForce.Attack_Target(AITarget))

end

function Bombers_Have_Reinforced()
	return bombers_reinforced
end

--function Fighters_Have_Rallied()
--	return rallied
--end


function BomberForce_Original_Target_Destroyed()
	DebugMessage("%s-- killed plan because original target destroyed", tostring(Script))
	ScriptExit()
end

function FighterForce_Original_Target_Destroyed()
	DebugMessage("%s-- killed plan because original target destroyed", tostring(Script))
	ScriptExit()
end
