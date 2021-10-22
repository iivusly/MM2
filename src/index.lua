local RoleColors = {
	['Sheriff'] = BrickColor.new('Baby blue').Color,
	['Hero'] = BrickColor.new('Gold').Color,
	['Murderer'] = BrickColor.new('Really red').Color,
	['Innocent'] = BrickColor.new('Light green (Mint)').Color,
}

local Util = require('Util')
local ESPLib = require('Libraries/ESPLib')
local UILib = require('Libraries/UILib')
local CallLib = require('Libraries/CallLib')

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local LocalPlayerRole = 'Innocent'

local UI = script.Parent

local Loading = UILib.Loader.new(UI, '正在加载...', 5, true, true)

local ESP = ESPLib.new(UI)

for _,v in next, Players:GetPlayers() do
	ESP:Build(v, BrickColor.new('Light green (Mint)').Color)
end

Players.PlayerAdded:Connect(function(Player)
	ESP:Build(Player)
end)

game:GetService('RunService').Heartbeat:Connect(function()
	local PlayerData = CallLib.GetPlayerData()
	for i,v in next, Players:GetPlayers() do
		local Data = PlayerData[v.Name]
		if (Data and Data.Dead == false) then
			for k,c in next, RoleColors do
				if (Data.Role == k) then
					ESP:Color(Players[v.Name], c)
				end
			end
		else
			ESP:Color(Players[v.Name], RoleColors.Innocent)
		end
	end
	
	LocalPlayerRole = PlayerData[LocalPlayer.Name]
end)

Loading.Spinner:Destroy()
Loading.TextLabel.Text = '你好～'
delay(2, function()
	Loading.CloseEvent:Fire()
end)