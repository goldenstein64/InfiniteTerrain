local module = {}
module.__index = module

module.New = function(value)
	local object = setmetatable({}, module)
	
	object.event = _G.classes["Event"].New()
	object.value = value
	object.selected = value or ""
	
	object.gui = Instance.new("Frame")
	object.gui.Size = UDim2.new(1, 0, 0, 184)
	object.gui.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Item)
	object.gui.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	
	local padding = Instance.new("UIPadding")
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 0)
	padding.PaddingTop = UDim.new(0, 8)
	padding.Parent = object.gui
	
	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0.125, -8, 0, 50)
	gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
	gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	gridLayout.Parent = object.gui
	
	
	object.imageButtons = {}
	for i, data in ipairs(_G.modules["Data"].materials) do
		local imageButton = Instance.new("ImageButton")
		imageButton.Image = data[2]
		imageButton.ScaleType = Enum.ScaleType.Crop
		imageButton.BorderSizePixel = 2
		imageButton.AutoButtonColor = false
		imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
		if object.selected == (data[1] or "") then
			imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Selected)
		else
			imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)
		end
		
		imageButton.Parent = object.gui
				
		imageButton.MouseEnter:Connect(function()
			if object.selected == (data[1] or "") then return end
			imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
			imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
			imageButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
		end)
		imageButton.MouseLeave:Connect(function()
			if object.selected == (data[1] or "") then return end
			imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
			imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Default)
			imageButton.ImageColor3 = Color3.new(1, 1, 1)
		end)
		imageButton.MouseButton1Down:Connect(function()
			if object.selected == (data[1] or "") then return end
			imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Pressed)
			imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Pressed)
			imageButton.ImageColor3 = Color3.new(0.5, 0.5, 0.5)
		end)
		imageButton.MouseButton1Up:Connect(function()
			if object.selected == (data[1] or "") then return end
			imageButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Hover)
			imageButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Hover)
			imageButton.ImageColor3 = Color3.new(0.75, 0.75, 0.75)
		end)
		imageButton.Activated:Connect(function()
			if object.value == data[1] then return end
			object.value = data[1]
			object.event:Call(object.value)
		end)
		object.imageButtons[data[1] or ""] = imageButton
	end
	
	return object
end

module.Select = function(self, value)
	self.imageButtons[self.selected].BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
	self.imageButtons[self.selected].BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder, Enum.StudioStyleGuideModifier.Default)
	self.imageButtons[self.selected].ImageColor3 = Color3.new(1, 1, 1)
	self.selected = value or ""
	self.imageButtons[self.selected].BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Default)
	self.imageButtons[self.selected].BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button, Enum.StudioStyleGuideModifier.Selected)
	self.imageButtons[self.selected].ImageColor3 = Color3.new(1, 1, 1)
end

module.Destroy = function(self)
	self.event:UnBindAll()
	self.gui:Destroy()
end

return module
