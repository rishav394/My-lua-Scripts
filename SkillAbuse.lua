local SkillAbuse = {}

SkillAbuse.opt = Menu.AddOption({ "Utility", "Skill Abuse" }, "Enable","")
SkillAbuse.key = Menu.AddKeyOption({ "Utility", "Skill Abuse" }, "Key",Enum.ButtonCode.KEY_P)
SkillAbuse.skills ={}
SkillAbuse.Queue = {}

function SkillAbuse.OnUpdate()
	if not Menu.IsEnabled(SkillAbuse.opt) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end

	if Menu.IsKeyDownOnce(SkillAbuse.key) then
		local skill = nil
		for k,v in pairs(SkillAbuse.skills) do
			if Menu.IsEnabled(v) then
				skill = k
				break
			end
		end
		if skill then
			local obj = {
				time = GameRules.GetGameTime(),
				skill = skill,
				processed = false
			}
			table.insert(SkillAbuse.Queue, obj)
		end
	end

	SkillAbuse.ProcessQueue()
end

function SkillAbuse.ProcessQueue()
	for i = 1, #SkillAbuse.Queue do 
		local item = SkillAbuse.Queue[i]
		
		if item.processed and GameRules.GetGameTime() > item.time + Ability.GetCastPoint(item.skill) -NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) then
			Player.HoldPosition(Players.GetLocal(), Heroes.GetLocal())
			table.remove(SkillAbuse.Queue,i)
			break
		elseif not item.processed and not Ability.IsInAbilityPhase(item.skill) then
			Log.Write(Ability.GetCastRange(item.skill))
			if ( Ability.GetBehavior(item.skill) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET  ) ~= 0  then
			    Ability.CastNoTarget(item.skill)
			    item.time = GameRules.GetGameTime()
			end

			-- Cast skills for example zeus skills 2(can target or ground), jugger ulti
			if ( Ability.GetBehavior(item.skill) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET  ) ~= 0  then
			    local test_target = Input.GetNearestHeroToCursor(Entity.GetTeamNum(Heroes.GetLocal()), Enum.TeamType.TEAM_ENEMY)
			    Ability.CastTarget(item.skill, test_target, queue)
			    item.time = GameRules.GetGameTime()
			end
			if (Ability.GetBehavior(item.skill) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
				Ability.CastPosition(item.skill, Input.GetWorldCursorPos())
			end 
			item.time = GameRules.GetGameTime()
			item.processed = true
			break
		end
	end 
end

function SkillAbuse.OnDraw()
	if not Menu.IsEnabled(SkillAbuse.opt) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return end

	for i = 0, 5 do 
		local skill = NPC.GetAbilityByIndex(myHero, i)
		if not SkillAbuse.skills[skill] and Ability.IsCastable(skill,1000) and Ability.GetCastPoint(skill)>0.05 then
			Log.Write(Ability.GetCastPoint(skill)..Ability.GetName(skill))
			SkillAbuse.skills[skill] = Menu.AddOption({ "Utility", "Skill Abuse" },  Ability.GetName(skill),"")
		end
	end
end

function SkillAbuse.OnGameEnd()
	for k,v in pairs(SkillAbuse.skills) do
		Menu.RemoveOption(v)
	end
	SkillAbuse.skills ={}
end

function SkillAbuse.OnScriptUnload()
	for k,v in pairs(SkillAbuse.skills) do
		Menu.RemoveOption(v)
	end
	SkillAbuse.skills ={}
end


return SkillAbuse

