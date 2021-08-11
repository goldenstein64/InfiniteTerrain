local module = {}

local chunkSize = 16
local waterHeight = 0
local positionX = math.huge
local positionZ = math.huge
local connection = nil
local heightData = {}
local loaded = {}

module.heightData = {}
module.materialData = {}
module.distance = 6
module.seeds = {}
module.materials = {}
module.shift = 0
module.waterHeight = waterHeight
module.minimumHeight = -10000
module.maximumHeight = 10000

LoadHeight = function(x, z)
	if heightData[x] == nil then heightData[x] = {} end
	if heightData[x][z] == nil then heightData[x][z] = {} end
	
	if heightData[x][z].height ~= nil then
		return heightData[x][z].height
	end
	
	if module.heightData[x] ~= nil and module.heightData[x][z] ~= nil then
		heightData[x][z].height = module.heightData[x][z]
		return module.heightData[x][z]
	end
	
	local height = 0
	for i, data in ipairs(module.seeds) do
		local noise = math.noise(x * data[3], data[1], z * data[3])
		height += math.clamp(noise, data[4], data[5]) * data[2]
	end
	height += module.shift
	height = math.clamp(height, module.minimumHeight, module.maximumHeight)
	heightData[x][z].height = height
	return height
end

Load = function(x, z)
	if heightData[x] == nil then heightData[x] = {} end
	if heightData[x][z] == nil then heightData[x][z] = {} end
	
	local data = heightData[x][z]
	
	if data.minimum ~= nil then return end
	data.minimum = math.huge
	local maximum = -math.huge
	for xx = x-1, x+1 do
		for zz = z-1, z+1 do
			local height = LoadHeight(xx, zz)
			data.minimum = math.min(data.minimum, height)
			maximum = math.max(maximum, height)
		end
	end
	
	local height = data.height
	local slope = maximum - data.minimum
	local thickness = height - data.minimum + 4
	local cFrame = CFrame.new(x * 4 + 2, height - thickness / 2, z * 4 + 2)
	local size = Vector3.new(4, thickness, 4)
	if module.materialData[x] ~= nil and module.materialData[x][z] ~= nil then
		workspace.Terrain:FillBlock(cFrame, size, module.materialData[x][z])
	else
		for i, materialData in ipairs(module.materials) do
			if height >= materialData[2] and height < materialData[3] and slope >= materialData[4] and slope < materialData[5] then
				workspace.Terrain:FillBlock(cFrame, size, materialData[1])
				break
			end
		end
	end
	
	height = math.floor(height / 4) * 4
	if height >= waterHeight then return end
	thickness = waterHeight - height
	local cFrame = CFrame.new(x * 4 + 2, height + thickness / 2, z * 4 + 2)
	local size = Vector3.new(4, thickness, 4)
	workspace.Terrain:FillBlock(cFrame, size, Enum.Material.Water)
end

Unload = function(x, z)
	if heightData[x] == nil or heightData[x][z] == nil or heightData[x][z].minimum == nil then return end
	
	local data = heightData[x][z]
	local minimum = data.minimum
	local maximum = math.max(data.height, waterHeight)

	minimum = math.floor(minimum / 4) * 4 - 4
	maximum = math.ceil(maximum / 4) * 4
	local thickness = maximum - minimum
	local cFrame = CFrame.new(x * 4 + 2, minimum + thickness / 2, z * 4 + 2)
	local size = Vector3.new(4, thickness, 4)
	workspace.Terrain:FillBlock(cFrame, size, Enum.Material.Air)
	heightData[x][z] = nil
end

LoadChunk = function(chunkX, chunkZ)
	if loaded[chunkX] == nil then loaded[chunkX] = {} end
	if loaded[chunkX][chunkZ] ~= nil then return end
	loaded[chunkX][chunkZ] = true
	local startX = chunkX * chunkSize
	local startZ = chunkZ * chunkSize
	local endX = startX + chunkSize - 1
	local endZ = startZ + chunkSize - 1
	for x = startX, endX do
		for z = startZ, endZ do
			Load(x, z)
		end
	end
	wait()
end

LoadChunks = function(chunkX, chunkZ, hole)
	if hole == nil then hole = 0 LoadChunk(chunkX, chunkZ) end
	hole = hole * 2 + 1
	local x = chunkX + math.floor(hole/2)
	local z = chunkZ - math.floor(hole/2)
	local dx, dz = 1, 0
	local passed = hole - 1
	local length = hole
	local amount = (module.distance * 2 + 1) * (module.distance * 2 + 1) - hole * hole
	for i = 1, amount do
		x += dx z += dz
		if Vector2.new(chunkX - x, chunkZ - z).Magnitude < module.distance + 0.5 then LoadChunk(x, z) end
		passed += 1
		if passed == length then passed = 0 dx, dz = -dz, dx if dz == 0 then length += 1 end end
		if connection == nil then return end
	end
end

module.Set = function(x, z, size, height)
	if height ~= nil then height = math.round(height * 10) / 10 end
	for xx = x - size, x + size do
		for zz = z - size, z + size do
			local magnitude = Vector2.new(xx - x , zz - z).Magnitude
			local strength = math.max(size + 0.5 - magnitude, 0) / (size + 0.5)
			if strength == 0 then continue end
			if module.heightData[xx] == nil then module.heightData[xx] = {} end
			module.heightData[xx][zz] = height
			if height == nil and next(module.heightData[xx]) == nil then
				module.heightData[xx] = nil
			end
		end
	end
	for xx = x - size - 1, x + size + 1 do
		for zz = z - size - 1, z + size + 1 do
			Unload(xx, zz)
		end
	end
	for xx = x - size - 1, x + size + 1 do
		for zz = z - size - 1, z + size + 1 do
			Load(xx, zz)
		end
	end
end

module.Increase = function(x, z, size, amount)
	for xx = x - size, x + size do
		for zz = z - size, z + size do
			local magnitude = Vector2.new(xx - x , zz - z).Magnitude
			local strength = math.max(size + 0.5 - magnitude, 0) / (size + 0.5)
			if strength == 0 then continue end
			local height = LoadHeight(xx, zz)
			height = math.round((height + amount * strength) * 10) / 10
			if module.heightData[xx] == nil then module.heightData[xx] = {} end
			module.heightData[xx][zz] = height
		end
	end
	for xx = x - size - 1, x + size + 1 do
		for zz = z - size - 1, z + size + 1 do
			Unload(xx, zz)
		end
	end
	for xx = x - size - 1, x + size + 1 do
		for zz = z - size - 1, z + size + 1 do
			Load(xx, zz)
		end
	end
end

module.Smooth = function(x, z, size)
	for xx = x - size, x + size do
		for zz = z - size, z + size do
			local magnitude = Vector2.new(xx - x , zz - z).Magnitude
			local strength = math.max(size + 0.5 - magnitude, 0) / (size + 0.5)
			if strength == 0 then continue end
			local height = 0
			local count = 0
			local minimum = math.huge
			local maximum = -math.huge
			for xxx = xx-1, xx+1 do
				for zzz = zz-1, zz+1 do
					height += LoadHeight(xxx, zzz)
					count += 1
				end
			end
			height = math.round((height / count) * 10) / 10
			if module.heightData[xx] == nil then module.heightData[xx] = {} end
			module.heightData[xx][zz] = height
		end
	end
	for xx = x - size - 1, x + size + 1 do
		for zz = z - size - 1, z + size + 1 do
			Unload(xx, zz)
		end
	end
	for xx = x - size - 1, x + size + 1 do
		for zz = z - size - 1, z + size + 1 do
			Load(xx, zz)
		end
	end
end

module.Paint = function(x, z, size, material)
	for xx = x - size, x + size do
		for zz = z - size, z + size do
			local magnitude = Vector2.new(xx - x , zz - z).Magnitude
			local strength = math.max(size + 0.5 - magnitude, 0) / (size + 0.5)
			if strength == 0 then continue end
			if module.materialData[xx] == nil then module.materialData[xx] = {} end
			module.materialData[xx][zz] = material
			if material == nil and next(module.materialData[xx]) == nil then
				module.materialData[xx] = nil
			end
			Unload(xx, zz)
			Load(xx, zz)
		end
	end
end

module.Clear = function()
	for x, object in pairs(heightData) do
		for z, v in pairs(object) do
			Unload(x, z)
		end
	end
	waterHeight = module.waterHeight
	loaded = {}
	heightData = {}
	if connection == nil then return end
	positionX, positionZ = workspace.CurrentCamera.Focus.Position.X, workspace.CurrentCamera.Focus.Position.Z
	local x = math.floor(positionX / 4 / chunkSize)
	local z = math.floor(positionZ / 4 / chunkSize)
	LoadChunks(x, z)
end

module.ClearAll = function()
	game.Workspace.Terrain:Clear()
	waterHeight = module.waterHeight
	loaded = {}
	heightData = {}
	if connection == nil then return end
	positionX, positionZ = workspace.CurrentCamera.Focus.Position.X, workspace.CurrentCamera.Focus.Position.Z
	local x = math.floor(positionX / 4 / chunkSize)
	local z = math.floor(positionZ / 4 / chunkSize)
	LoadChunks(x, z)
end

module.Enable = function(value)
	if value == false then
		if connection == nil then return end
		connection:Disconnect()
		connection = nil
	else
		if connection ~= nil then return end
		connection = workspace.CurrentCamera:GetPropertyChangedSignal("Focus"):Connect(function()
			local x = workspace.CurrentCamera.Focus.Position.X
			local z = workspace.CurrentCamera.Focus.Position.Z
			local magnitude = Vector2.new(positionX - x, positionZ - z).Magnitude
			if magnitude < chunkSize * 8 then return end
			positionX, positionZ = x, z
			x = math.floor(positionX / 4 / chunkSize)
			z = math.floor(positionZ / 4 / chunkSize)
			if magnitude < module.distance * chunkSize * 2 then
				LoadChunks(x, z, math.floor(module.distance / 2 - 0.5))
			else
				LoadChunks(x, z)
			end
		end)
		positionX, positionZ = workspace.CurrentCamera.Focus.Position.X, workspace.CurrentCamera.Focus.Position.Z
		local x = math.floor(positionX / 4 / chunkSize)
		local z = math.floor(positionZ / 4 / chunkSize)
		LoadChunks(x, z)
	end
end

return module
