local module = {}
module.__index = module

local selected = nil

module.New = function(label, image, order)
	local object = setmetatable({}, module)
	
	object.button = Instance.new("ImageButton")
	object.button.LayoutOrder = order
	object.button.AutoButtonColor = false
	object.button.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	object.button.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	object.button.Parent = _G.modules["Widget"].frame

	object.imageLabel = Instance.new("ImageLabel")
	object.imageLabel.Image = image
	object.imageLabel.BackgroundTransparency = 1
	object.imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	object.imageLabel.Position = UDim2.new(0.5, 0, 0.3, 0)
	object.imageLabel.Size = UDim2.new(0, 25, 0, 25)
	object.imageLabel.Parent = object.button

	object.textLabel = Instance.new("TextLabel")
	object.textLabel.Text = label
	object.textLabel.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	object.textLabel.BackgroundTransparency = 1
	object.textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	object.textLabel.Position = UDim2.new(0.5, 0, 0.8, 0)
	object.textLabel.Parent = object.button
	
	object.selected = _G.classes["Event"].New()
	object.deselected = _G.classes["Event"].New()

	local children = _G.modules["Widget"].frame:GetChildren()
	local width = 1 / (#children - 2)
	for i, child in ipairs(children) do
		if child.ClassName ~= "ImageButton" then continue end
		child.Size = UDim2.new(width, -4, 1, 0)
	end

	object.button.MouseEnter:Connect(function()
		if selected == object then return end
		object.button.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		object.button.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		object.textLabel.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	object.button.MouseLeave:Connect(function()
		if selected == object then return end
		object.button.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		object.button.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		object.textLabel.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end)
	object.button.MouseButton1Down:Connect(function()
		if selected == object then return end
		object.button.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Pressed)
		object.button.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Pressed)
		object.textLabel.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Pressed)
	end)
	object.button.MouseButton1Up:Connect(function()
		if selected == object then return end
		object.button.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Hover)
		object.button.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		object.textLabel.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	
	return object
end

module.Select = function(self)
	if selected == self then return end
	if selected ~= nil then
		selected.button.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Default)
		selected.button.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		selected.textLabel.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
		selected.deselected:Call()
	end
	selected = self
	selected.button.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item, Enum.StudioStyleGuideModifier.Selected)
	selected.button.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Selected)
	selected.textLabel.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Selected)
	selected.selected:Call()
end

module.Activated = function(self, callback)
	self.button.Activated:Connect(callback)
end

return module
