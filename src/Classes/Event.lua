local module = {}
module.__index = module

module.New = function()
	local object = setmetatable({}, module)
	object.callbacks = {}
	return object
end

module.Bind = function(self, callback)
	local callbacks = {}
	callbacks[callback] = true
	for c, v in pairs(self.callbacks) do
		callbacks[c] = true
	end
	self.callbacks = callbacks
end

module.UnBind = function(self, callback)
	local callbacks = {}
	for c, v in pairs(self.callbacks) do
		if c == callback then continue end
		callbacks[c] = true
	end
	self.callbacks = callbacks
end

module.UnBindAll = function(self)
	self.callbacks = {}
end

module.Call = function(self, ...)
	for c, v in pairs(self.callbacks) do
		c(...)
	end
end

return module