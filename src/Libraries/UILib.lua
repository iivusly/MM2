local UILib = {
	Loader = {}
}

local Util = require('Util')

function UILib.Loader.new(Target, Text, Time, ShowSpinner, CloseEvent)
	local Time = Time or 5
	local ShowSpinner = ShowSpinner or false
	local CloseEvent = CloseEvent or false
	
	local Frame = Util.QuickBuild('Frame', nil, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0, 100, 0, 100),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(27, 42, 53),
		BackgroundTransparency = 0.25,
	})
	
	local RoundedCorner = Util.QuickBuild('UICorner', Frame, {
		CornerRadius = UDim.new(0, 8),
	})
	
	local TextLabel = Util.QuickBuild('TextLabel', Frame, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.9, 0, 0.5, 0),
		TextWrapped = true,
		Position = UDim2.new(0.5, 0, ShowSpinner and 0.75 or 0.5, 0),
		TextColor3 = Color3.fromRGB(252, 255, 255),
		TextSize = 16,
		Text = Text,
	})
	
	local Spinner
	if (ShowSpinner) then
		Spinner = Util.QuickBuild('ImageLabel', Frame, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.25, 0, 0.25, 0),
			Position = UDim2.new(0.5, 0, 0.25, 0),
			Image = 'rbxassetid://1961764186',
		})
		
		spawn(function() 
			local HB
			HB = game:GetService('RunService').Heartbeat:Connect(function() 
				if (Spinner and Spinner.Parent) then
					Spinner.Rotation = Spinner.Rotation + 5
				else
					if (TextLabel) then
						TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
					end
					HB:Disconnect()
				end
			end)
		end)
	end
	
	Frame.Parent = Target
	
	local function Close()
		for i,v in next, Frame:GetChildren() do
			if (v:IsA('GuiBase')) then
				v:Destroy()
			end
		end
		local Tween = game:GetService('TweenService'):Create(Frame, TweenInfo.new(0.5), {
			BackgroundTransparency = 1
		})
		Tween.Completed:Connect(function()
			Frame:Destroy()
		end)
		Tween:Play()
	end
	
	if (CloseEvent) then
		local Event = Instance.new('BindableEvent')
		Event.Event:Connect(Close)
		return {
			CloseEvent = Event,
			TextLabel = TextLabel,
			Spinner = Spinner,
		}
	else
		return delay(Time, Close)
	end
end

return UILib