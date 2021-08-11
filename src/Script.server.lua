_G.plugin = plugin
_G.root = script.Parent
_G.modules = {}
_G.classes = {}
for i, descendant in ipairs(script.Parent:GetDescendants()) do
	if descendant.ClassName ~= 'ModuleScript' then continue end
	local module = require(descendant)
	if module.__index == nil then
		_G.modules[descendant.Name] = module
	else
		_G.classes[descendant.Name] = module
	end
end
for i, module in pairs(_G.modules) do
	if module.Initialise then module.Initialise() end
end
for i, module in pairs(_G.modules) do
	if module.Initiate then module.Initiate() end
end