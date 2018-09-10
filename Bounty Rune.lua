local Rune = {}

Rune.Enable = Menu.AddOption({ "Utility", "Bounty Rune Notification" }, "Chatwheel Enable", "Turn it on if you want it to say Rune Check in ChatWheel")
Rune.Time = Menu.AddOption({"Utility", "Bounty Rune Notification"}, "Time At", "The time tick in seconds in which the Notification wil be sent", 30, 58, 2)

function Rune.OnUpdate()
	if Menu.IsEnabled(Rune.Enable) then
		local time = (GameRules.GetGameTime() - GameRules.GetGameStartTime()) % 300
		if time > 240 + Menu.GetValue(Rune.Time) and time < 240 + Menu.GetValue(Rune.Time) + 1 then
			Engine.ExecuteCommand("chatwheel_say 58")
		end
	else
		local time = (GameRules.GetGameTime() - GameRules.GetGameStartTime()) % 300
		if time > 240 + Menu.GetValue(Rune.Time) and time < 240 + Menu.GetValue(Rune.Time) + 1 then
			Alerts.Add("Check Bounty Runes", 5 , true)
		end
	end
end

return Rune