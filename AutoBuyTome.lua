local AutoBuyTome = {}

AutoBuyTome.Enable = Menu.AddOption({ "Utility", "Auto Tome v0.2" }, "Auto Buy Tome of Knowledge", "Buy every 10 minuts Tome of Knowledge if you have 150 gold")
AutoBuyTome.EnableAlways = Menu.AddOption({ "Utility", "Auto Tome v0.2" }, "Auto Buy Tome of Knowledge Always", "Buy always, if off then buy if you have worst xp")

AutoBuyTome.Delay = 0

function AutoBuyTome.OnGameStart()
	AutoBuyTome.Delay = 0
end
function AutoBuyTome.OnUpdate()
	if not Menu.IsEnabled(AutoBuyTome.Enable) then
		return
	end

	local myHero = Heroes.GetLocal()

	if not myHero then
		return
	end
	if NPC.GetCurrentLevel(myHero) ~= 25 and (GameRules.GetGameTime() - GameRules.GetGameStartTime()) / 60 % 10 < 0.01 and GameRules.GetGameTime() > AutoBuyTome.Delay then
		local myHero_xp = Hero.GetCurrentXP(myHero)
		local lowest_xp = myHero_xp
		for i, Unit in pairs(Heroes.GetAll()) do
			if Entity.IsSameTeam(myHero, Unit) and not NPC.IsIllusion(Unit) then
				local xp = Hero.GetCurrentXP(Unit)
				if lowest_xp > xp then
					lowest_xp = xp
				end
			end
		end

		if lowest_xp == myHero_xp or Menu.IsEnabled(AutoBuyTome.EnableAlways) then
			Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PURCHASE_ITEM, 257, Vector(0, 0, 0), 257, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_PASSED_UNIT_ONLY, myHero, false, true)
			AutoBuyTome.Delay = GameRules.GetGameTime() + 0.2
		end
	end
end

return AutoBuyTome