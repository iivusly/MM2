local Call = {}

local Player = game:GetService('Players').LocalPlayer

local function FindTool(Name)
	local Tool = Player.Backpack:FindFirstChild(Name)
	local Find = Player.Character:FindFirstChild(Name)
	Tool = Find and Find or Tool
	return Tool
end

function Call.Shoot(TargetVector)
	return FindTool('Gun').KnifeServer.ShootGun:InvokeServer(1, TargetVector, 'AH')
end

function Call.Throw(FromVector, ToCFrame)
	return FindTool('Knife').Throw:FireServer(ToCFrame, FromVector)
end

function Call.GetPlayerData()
	return game:GetService("ReplicatedStorage"):WaitForChild('GetPlayerData'):InvokeServer()
end

return Call
