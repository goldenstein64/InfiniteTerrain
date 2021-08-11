local module = {}
module.__index = module

module.New = function(label, value, data)
	local object = setmetatable({}, module)
	
	object.event = _G.classes["Event"].New()
	object.value = value
	object.data = data or {}
	
	object.gui = Instance.new("Frame")
	object.gui.Size = UDim2.new(1, 0, 0, 24)
	object.gui.BackgroundTransparency = 1
	object.gui.BorderSizePixel = 0

	local textLabel = Instance.new("TextLabel")
	textLabel.Text = label or ""
	textLabel.Font = Enum.Font.Arial
	textLabel.TextSize = 12
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.Size = UDim2.new(0, 120, 1, 0)
	textLabel.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	textLabel.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	textLabel.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	textLabel.Parent = object.gui
	
	object.textBox = Instance.new("TextBox")
	object.textBox.Text = object.value
	object.textBox.Font = Enum.Font.Arial
	object.textBox.TextSize = 12
	object.textBox.Position = UDim2.new(0, 121, 0, 0)
	object.textBox.Size = UDim2.new(1, -121, 1, 0)
	object.textBox.ClearTextOnFocus = false
	object.textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	object.textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	object.textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	object.textBox.Parent = object.gui
	object.textBox.MouseEnter:Connect(function()
		object.textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		object.textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		object.textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	object.textBox.MouseLeave:Connect(function()
		object.textBox.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		object.textBox.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		object.textBox.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end)
	object.textBox.FocusLost:Connect(function(enterPressed, inputThatCausedFocusLoss)
		local newValue = tonumber(object.textBox.Text) or object.value
		if object.data.minimum then newValue = math.max(newValue, object.data.minimum) end
		if object.data.maximum then newValue = math.min(newValue, object.data.maximum) end
		if object.data.round then newValue = _G.modules["Functions"].Round(newValue, object.data.round) end
		object.textBox.Text = newValue
		if object.value == newValue then return end
		object.value = newValue
		object.event:Call(object.value)
	end)
	
	return object
end

module.Set = function(self, value)
	if self.value == value then return end
	if self.data.minimum then value = math.max(value, self.data.minimum) end
	if self.data.maximum then value = math.min(value, self.data.maximum) end
	if self.data.round then value = _G.modules["Functions"].Round(value, self.data.round) end
	self.value = value
	self.textBox.Text = tonumber(self.value)
	self.event:Call(self.value)
end

module.Destroy = function(self)
	self.event:UnBindAll()
	self.gui:Destroy()
end

return module
