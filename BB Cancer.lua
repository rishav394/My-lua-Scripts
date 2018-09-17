local Quillspam = {}

Quillspam.Enable = Menu.AddOption({"Hero Specific","Brisle Back"}, "Enable", "WARNING! Enable only when you feel like you wont have no mana deficiency")

function Quillspam.OnUpdate()
	local myHero = Heroes.GetLocal()

	if NPC.GetUnitName(myHero) ~= "npc_dota_hero_bristleback" then 
		return
	end
	-- Log.Write(tostring(NPC.IsVisible(myHero)))
		
	if Menu.IsEnabled(Quillspam.Enable) then
		local quill = NPC.GetAbilityByIndex(myHero, 1)
		local myMana = NPC.GetMana(myHero)
		
		if Ability.IsCastable(quill, myMana) then
			Ability.CastNoTarget(quill)
		end
	end
end

return Quillspam