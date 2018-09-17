local Rune = {}

Rune.Options  = {}

function Rune.InsertData(alias)
    table.insert(Rune.Options, { name = alias})
end

Rune.InsertData("Chatwheel")
Rune.InsertData("Alert")
Rune.InsertData("ChatWheel + Alert")


Rune.OverAll = Menu.AddOption({ "Utility", "Bounty Rune Notification" }, "1. Overall Enabled", "Turn the script on or off (RECOMMENDED: ON or else wont work)")
Rune.MyOptions = Menu.AddOption({ "Utility", "Bounty Rune Notification" }, "2. Mode", "Set the notification Mode  (RECOMMENDED: CHATWHEEL + ALERT)", 1, #Rune.Options, 1)
Rune.Time = Menu.AddOption({"Utility", "Bounty Rune Notification"}, "3. Notification at (time in seconds)", "The time tick in seconds in which the Notification wil be sent  (RECOMMENDED: 50)", 30, 58, 2)
Rune.DisableTime = Menu.AddOption({"Utility", "Bounty Rune Notification"}, "4. Time in minutes to stop script", "The minute mark at which the script auto disables  (RECOMMENDED: 35)", 25, 60, 5)

for i, v in ipairs(Rune.Options) do
    Menu.SetValueName(Rune.MyOptions, i, v.name)
end

function Rune.OnUpdate()
	if not Menu.IsEnabled(Rune.OverAll) then
		return
	end

	local gametime = (GameRules.GetGameTime() - GameRules.GetGameStartTime())
	local time = gametime % 300

	if gametime > Rune.DisableTime * 60 then
		return;
	end
	
	if time > 240 + Menu.GetValue(Rune.Time) and time < 240 + Menu.GetValue(Rune.Time) + 1 then
		-- Act notifiations Accordingly
		local value = Menu.GetValue(Rune.MyOptions)
		if value == 1 then
			Engine.ExecuteCommand("chatwheel_say 58")
		elseif value == 2 then
			Alerts.Add("Check Bounty Runes", 4 , true)
		else
			Engine.ExecuteCommand("chatwheel_say 58")
			Alerts.Add("Check Bounty Runes", 4 , true)
		end
	end
end

return Rune