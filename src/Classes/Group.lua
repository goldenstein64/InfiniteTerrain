local module = {}
module.__index = module

local showing = nil

module.New = function(label)
	local object = setmetatable({}, module)
	
	object.gui = Instance.new("Frame")
	object.gui.Size = UDim2.new(1, 0, 0, 0)
	object.gui.AutomaticSize = Enum.AutomaticSize.Y
	object.gui.BackgroundTransparency = 1
	object.gui.BorderSizePixel = 0
	
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 1)
	padding.PaddingRight = UDim.new(0, 1)
	padding.Parent = object.gui
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 1)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = object.gui
		
	local textButton = Instance.new("TextButton")
	textButton.Text = label
	textButton.Font = Enum.Font.ArialBold
	textButton.TextSize = 12
	textButton.Size = UDim2.new(1, 0, 0, 24)
	textButton.AutoButtonColor = false
	textButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.CategoryItem)
	textButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	textButton.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	textButton.Parent = object.gui
	
	object.frame = Instance.new("Frame")
	object.frame.Size = UDim2.new(1, 0, 0, 0)
	object.frame.AutomaticSize = Enum.AutomaticSize.Y
	object.frame.BackgroundTransparency = 1
	object.frame.BorderSizePixel = 0
	object.frame.Parent = object.gui
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 1)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = object.frame
	
	textButton.MouseEnter:Connect(function()
		textButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.CategoryItem, Enum.StudioStyleGuideModifier.Hover)
		textButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		textButton.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	textButton.MouseLeave:Connect(function()
		textButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.CategoryItem, Enum.StudioStyleGuideModifier.Default)
		textButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Default)
		textButton.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Default)
	end)
	textButton.MouseButton1Down:Connect(function()
		textButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.CategoryItem, Enum.StudioStyleGuideModifier.Pressed)
		textButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Pressed)
		textButton.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Pressed)
	end)
	textButton.MouseButton1Up:Connect(function()
		textButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.CategoryItem, Enum.StudioStyleGuideModifier.Hover)
		textButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border, Enum.StudioStyleGuideModifier.Hover)
		textButton.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText, Enum.StudioStyleGuideModifier.Hover)
	end)
	
	textButton.Activated:Connect(function()
		object.frame.Visible = not object.frame.Visible
	end)
	
	return object
end

module.AddChild = function(self, child)
	child.Parent = self.frame
end

return module
