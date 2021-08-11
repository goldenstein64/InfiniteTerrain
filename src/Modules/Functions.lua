local module = {}

module.Round = function(value, decimals)
	local mult = 10 ^ (decimals or 0)
	return math.round(value * mult) / mult
end

return module
