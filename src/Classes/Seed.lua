local module = {}
module.__index = module

module.New = function(data)
	local object = setmetatable({}, module)
	
	object.event = _G.classes["Event"].New()
	object.data = data
	
	object.gui = Instance.new("Frame")
	object.gui.Size = UDim2.new(1, 0, 0, 24)
	object.gui.BackgroundTransparency = 1
	object.gui.BorderSizePixel = 0
	
	local imageButton = Instance.new("ImageButton")
	imageButton.Position = UDim2.new(0, 0, 0, 0)
	imageButton.Size = UDim2.new(0.1, -1, 1, 0)
	imageButton.ScaleType = Enum.ScaleType.Fit
	imageButton.Image = "rbxasset://textures/CollisionGroupsEditor/delete.png"
	imageButton.AutoButtonColor = false
	imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	imageButton.Parent = object.gui
	imageButton.MouseEnter:Connect(function()
		imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		imageButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
	end)
	imageButton.MouseLeave:Connect(function()
		imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		imageButton.ImageColor3 = Color3.new(1, 1, 1)
	end)
	imageButton.MouseButton1Down:Connect(function()
		imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Pressed)
		imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Pressed)
		imageButton.ImageColor3 = Color3.new(0.5, 0.5, 0.5)
	end)
	imageButton.MouseButton1Up:Connect(function()
		imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		imageButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
	end)
	imageButton.Activated:Connect(function()
		object.event:Call(4)
	end)
	
	local textBox = Instance.new("TextBox")
	textBox.Text = tonumber(object.data[1])
	textBox.Position = UDim2.new(0.1, 0, 0, 0)
	textBox.Size = UDim2.new(0.16, -1, 1, 0)
	textBox.ClearTextOnFocus = false
	textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	textBox.Parent = object.gui
	textBox.MouseEnter:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	textBox.MouseLeave:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end)
	textBox.FocusLost:Connect(function(enterPressed, inputThatCausedFocusLoss)
		local newValue = tonumber(textBox.Text) or object.data[1]
		textBox.Text = newValue
		if object.data[1] == newValue then return end
		object.data[1] = newValue
		object.event:Call(1, object.data)
	end)
	
	local textBox = Instance.new("TextBox")
	textBox.Text = tonumber(object.data[2])
	textBox.Position = UDim2.new(0.26, 0, 0, 0)
	textBox.Size = UDim2.new(0.16, -1, 1, 0)
	textBox.ClearTextOnFocus = false
	textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	textBox.Parent = object.gui
	textBox.MouseEnter:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	textBox.MouseLeave:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end)
	textBox.FocusLost:Connect(function(enterPressed, inputThatCausedFocusLoss)
		local newValue = tonumber(textBox.Text) or object.data[2]
		textBox.Text = newValue
		if object.data[2] == newValue then return end
		object.data[2] = newValue
		object.event:Call(1, object.data)
	end)
	
	local textBox = Instance.new("TextBox")
	textBox.Text = tonumber(object.data[3])
	textBox.Position = UDim2.new(0.42, 0, 0, 0)
	textBox.Size = UDim2.new(0.16, -1, 1, 0)
	textBox.ClearTextOnFocus = false
	textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	textBox.Parent = object.gui
	textBox.MouseEnter:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	textBox.MouseLeave:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end)
	textBox.FocusLost:Connect(function(enterPressed, inputThatCausedFocusLoss)
		local newValue = tonumber(textBox.Text) or object.data[3]
		textBox.Text = newValue
		if object.data[3] == newValue then return end
		object.data[3] = newValue
		object.event:Call(1, object.data)
	end)
	
	local textBox = Instance.new("TextBox")
	textBox.Text = tonumber(object.data[4])
	textBox.Position = UDim2.new(0.58, 0, 0, 0)
	textBox.Size = UDim2.new(0.16, -1, 1, 0)
	textBox.ClearTextOnFocus = false
	textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	textBox.Parent = object.gui
	textBox.MouseEnter:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	textBox.MouseLeave:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end)
	textBox.FocusLost:Connect(function(enterPressed, inputThatCausedFocusLoss)
		local newValue = tonumber(textBox.Text) or object.data[4]
		textBox.Text = newValue
		if object.data[4] == newValue then return end
		object.data[4] = newValue
		object.event:Call(1, object.data)
	end)
	
	local textBox = Instance.new("TextBox")
	textBox.Text = tonumber(object.data[5])
	textBox.Position = UDim2.new(0.74, 0, 0, 0)
	textBox.Size = UDim2.new(0.16, -1, 1, 0)
	textBox.ClearTextOnFocus = false
	textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	textBox.Parent = object.gui
	textBox.MouseEnter:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	textBox.MouseLeave:Connect(function()
		textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end)
	textBox.FocusLost:Connect(function(enterPressed, inputThatCausedFocusLoss)
		local newValue = tonumber(textBox.Text) or object.data[5]
		textBox.Text = newValue
		if object.data[5] == newValue then return end
		object.data[5] = newValue
		object.event:Call(1, object.data)
	end)
	
	local frame = Instance.new("Frame")
	frame.Position = UDim2.new(0.9, 0, 0, 0)
	frame.Size = UDim2.new(0.1, 0, 0, 24)
	frame.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	frame.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	frame.Parent = object.gui
	
	local imageButton = Instance.new("ImageButton")
	imageButton.Position = UDim2.new(0, 4, 0, 3)
	imageButton.Size = UDim2.new(1, -8, 0, 8)
	imageButton.ScaleType = Enum.ScaleType.Fit
	imageButton.Image = "rbxassetid://7228266793"
	imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
	imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)
	imageButton.Parent = frame
	imageButton.Activated:Connect(function()
		object.event:Call(2)
	end)

	local imageButton = Instance.new("ImageButton")
	imageButton.Position = UDim2.new(0, 4, 0, 13)
	imageButton.Size = UDim2.new(1, -8, 0, 8)
	imageButton.ScaleType = Enum.ScaleType.Fit
	imageButton.Image = "rbxassetid://7228267193"
	imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
	imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)
	imageButton.Parent = frame
	imageButton.Activated:Connect(function()
		object.event:Call(3)
	end)
	
	return object
end

module.Destroy = function(self)
	self.event:UnBindAll()
	self.gui:Destroy()
end

return module
