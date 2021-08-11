local module = {}

module.Initialise = function()
	local toolbar = _G.plugin:CreateToolbar("Terrain")
	local button = toolbar:CreateButton("Infinite Terrain", "Create and edit terrain", "rbxassetid://3079008425")
	local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 300, 150, 150)
	button.ClickableWhenViewportHidden = true
	button.Click:Connect(function() _G.modules["Widget"].window.Enabled = not _G.modules["Widget"].window.Enabled end)
	_G.modules["Widget"].window = _G.plugin:CreateDockWidgetPluginGui("InfiniteTerrain", widgetInfo)
	_G.modules["Widget"].window.Title = "Infinite Terrain"
	_G.modules["Widget"].window:GetPropertyChangedSignal("Enabled"):Connect(function() if _G.modules["Widget"].window.Enabled then button:SetActive(true) else button:SetActive(false) end end)
	
	_G.modules["Widget"].frame = Instance.new("Frame")
	_G.modules["Widget"].frame.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	_G.modules["Widget"].frame.BorderSizePixel = 0
	_G.modules["Widget"].frame.Size = UDim2.new(1, 0, 0, 60)
	_G.modules["Widget"].frame.Parent = _G.modules["Widget"].window

	local padding = Instance.new("UIPadding")
	padding.PaddingBottom = UDim.new(0, 4)
	padding.PaddingLeft = UDim.new(0, 4)
	padding.PaddingTop = UDim.new(0, 4)
	padding.Parent = _G.modules["Widget"].frame

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.Padding = UDim.new(0, 4)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = _G.modules["Widget"].frame
end

return module
