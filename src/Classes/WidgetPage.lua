local module = {}
module.__index = module

local showing = nil

module.New = function()
	local object = setmetatable({}, module)
	
	object.scrollingFrame = Instance.new("ScrollingFrame")
	object.scrollingFrame.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
	object.scrollingFrame.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border)
	object.scrollingFrame.ScrollBarImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScrollBar)
	object.scrollingFrame.Position = UDim2.new(0, 0, 0, 60)
	object.scrollingFrame.Size = UDim2.new(1, 0, 1, -60)
	object.scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	object.scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 1)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = object.scrollingFrame
	
	return object
end

module.AddChild = function(self, child)
	child.Parent = self.scrollingFrame
end

module.Show = function(self)
	if showing ~= nil then
		showing.scrollingFrame.Parent = nil
	end
	showing = self
	showing.scrollingFrame.Parent = _G.modules["Widget"].window
end

return module
