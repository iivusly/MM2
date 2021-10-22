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
local UIS = game:GetService('UserInputService')
local LocalPlayer = Players.LocalPlayer
local LocalPlayerRole = 'Innocent'

local PlayerData

local UI = Util.QuickBuild('ScreenGui', gethui(), {
	Name = game:GetService('HttpService'):GenerateGUID()
})

local Loading = UILib.Loader.new(UI, '正在加载...', 5, true, true)

local ESP = ESPLib.new(UI)

function Build(Target)
	if (Target ~= LocalPlayer) then
		ESP:Build(Target, BrickColor.new('Light green (Mint)').Color)
	end
end

for _,v in next, Players:GetPlayers() do
	Build(v)
end

Players.PlayerAdded:Connect(function(Player)
	Build(Player)
end)

UIS.InputBegan:Connect(function(Input)
	if (Input.KeyCode == Enum.KeyCode.E and LocalPlayerRole == 'Sheriff') then
		for i,v in next, PlayerData do
			if (v.Role == 'Murderer') then
				CallLib.Shoot(Players[i].Character.PrimaryPart.Position)
			end
		end
	end
end)

game:GetService('RunService').Heartbeat:Connect(function()
	PlayerData = CallLib.GetPlayerData()
	for i,v in next, Players:GetPlayers() do
		local success, Data = pcall(function()
			return PlayerData[v.Name]
		end)
		if (success and Data) then
			if (Data.Dead == false) then
					for k,c in next, RoleColors do
					if (Data.Role == k) then
						ESP:Color(v, c)
					end
				end
			else
				ESP:Color(Players[v.Name], RoleColors.Innocent)
			end
			if (v == LocalPlayer) then
				LocalPlayerRole = Data.Role
			end
		end
	end
end)

Loading.Spinner:Destroy()
Loading.TextLabel.Text = '你好～'
print('好的')
delay(2, function()
	Loading.CloseEvent:Fire()
end)