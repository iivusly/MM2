local ESP = {}
ESP.__index = ESP

local Util = require('Util')

local RequiredBodyParts = {
	'Head',
	'UpperTorso',
	'LowerTorso',
	'HumanoidRootPart',
	'LeftFoot',
	'LeftHand',
	'LeftLowerArm',
	'LeftLowerLeg',
	'LeftUpperArm',
	'LeftUpperLeg',
	'RightFoot',
	'RightHand',
	'RightLowerArm',
	'RightLowerLeg',
	'RightUpperArm',
	'RightUpperLeg',
}

function ESP.new(Parent)
	local self = setmetatable({
		Holder = Util.QuickBuild('Folder', Parent, {
			Name = 'ESPHolder'
		}),
		Items = {}
	}, ESP)
	return self
end

function ESP:Color(Player, Color)
	local success, Items = pcall(function()
		return self.Items[Player]
	end)

	if (success and Items) then
		for _,v in next, Items do
			if (v:IsA('TextLabel')) then
				v.TextColor3 = Color
			else
				v.FillColor = Color
				v.OutlineColor = Color
			end
		end
	end
end

function ESP:Build(Player, Color)
	local ESPHolder = Util.QuickBuild('Folder', self.Holder, {
		Name = Player.Name
	})
	
	self.Items[Player] = {}
	
	local function Build(Character)
		for _,v in next, RequiredBodyParts do
			local Found = Character:WaitForChild(v)
		end
		local BGui = Util.QuickBuild('BillboardGui', ESPHolder, {
			AlwaysOnTop = true,
			Size = UDim2.new(10, 0, 1, 0),
			StudsOffset = Vector3.new(0, 2, 0),
			Adornee = Character:WaitForChild('Head'),
		})

		table.insert(
			self.Items[Player], 
			Util.QuickBuild('TextLabel', BGui, {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Font = Enum.Font.Code,
				TextColor3 = Color,
				Text = string.format('%s (@%s)', Player.DisplayName, Player.Name),
				--TextScaled = true,
				TextStrokeTransparency = 0,
			})
		)
		
		local Highlight = Util.QuickBuild('Highlight', Character, {
			FillColor = Color,
			FillTransparency = 0.25,
			OutlineColor = Color3.fromRGB(0, 209, 255)
		})
		
		table.insert(
			self.Items[Player],
			Highlight
		)

		local function Died()
			for _,v in next, self.Items[Player] do
				v:Destroy()
			end

			self.Items[Player] = {}
		end
		
		Character:WaitForChild("Head"):GetPropertyChangedSignal("Transparency"):Connect(function()
			Highlight.FillTransparency = Character["Head"].Transparency
		end)

		Character.Parent.DescendantRemoving:Connect(function(Decsendant)
			if (Decsendant == Character) then
				Died()
			end
		end)

		Character:WaitForChild('Humanoid').Died:Connect(Died)
	end

	Player.CharacterAdded:Connect(Build)
	
	if (Player.Character) then
		Build(Player.Character)
	end
end

return ESP
