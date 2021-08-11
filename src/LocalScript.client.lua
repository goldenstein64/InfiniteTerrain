if game:IsLoaded() == false then game.Loaded:Wait() end
local dataChild = nil
local heightChild = nil
local materialChild = nil
for i, child in ipairs(script:GetChildren()) do
	if child.ClassName == "ModuleScript" then
		local data = child:GetAttribute("Data")
		if data == "Terrain" then
			dataChild = child
		end
	elseif child.ClassName == "Folder" then
		local data = child:GetAttribute("Data")
		if data == "Height" then
			heightChild = child
		elseif data == "Material" then
			materialChild = child
		end
	end
end
if dataChild == nil then return end

local distance = 16
local chunkSize = 16
local positionX = math.huge
local positionZ = math.huge
local heightData = {}
local materialData = {}
local loaded = {}

local data = require(dataChild)

if heightChild then
	for i, child in ipairs(heightChild:GetDescendants()) do
		if child.ClassName ~= "ModuleScript" then continue end
		local data = require(child)
		local position = child:GetAttribute("Position")
		for i = 1, #data, 2 do
			local x = position.X + data[i]
			local zData = data[i + 1]
			if heightData[x] == nil then heightData[x] = {} end
			for j = 1, #zData, 2 do
				local z = position.Y + zData[j]
				local height = zData[j + 1]
				heightData[x][z] = height
			end
		end
	end
end

if materialChild then
	for i, child in ipairs(materialChild:GetDescendants()) do
		if child.ClassName ~= "ModuleScript" then continue end
		local data = require(child)
		local position = child:GetAttribute("Position")
		for i = 1, #data, 2 do
			local x = position.X + data[i]
			local zData = data[i + 1]
			if materialData[x] == nil then materialData[x] = {} end
			for j = 1, #zData, 2 do
				local z = position.Y + zData[j]
				local material = zData[j + 1]
				materialData[x][z] = material
			end
		end
	end
end


GetHeight = function(x, z)
	if heightData[x] == nil then heightData[x] = {} end
	if heightData[x][z] ~= nil then return heightData[x][z] end	
	local height = 0
	for i, data in ipairs(data.seeds) do
		local noise = math.noise(x * data[3], data[1], z * data[3])
		height += math.clamp(noise, data[4], data[5]) * data[2]
	end
	height += data.shift
	height = math.clamp(height, data.minimumHeight, data.maximumHeight)
	heightData[x][z] = height
	return height
end

Load = function(x, z)
	local minimum = math.huge
	local maximum = -math.huge
	for xx = x-1, x+1 do
		for zz = z-1, z+1 do
			local height = GetHeight(xx, zz)
			minimum = math.min(minimum, height)
			maximum = math.max(maximum, height)
		end
	end
	local slope = maximum - minimum
	local height = heightData[x][z]
	local thickness = height - minimum + 4
	local cFrame = CFrame.new(x * 4 + 2, height - thickness / 2, z * 4 + 2)
	local size = Vector3.new(4, thickness, 4)
	if materialData[x] ~= nil and materialData[x][z] ~= nil then
		workspace.Terrain:FillBlock(cFrame, size, materialData[x][z])
	else
		for i, materialData in ipairs(data.materials) do
			if height >= materialData[2] and height < materialData[3] and slope >= materialData[4] and slope < materialData[5] then
				workspace.Terrain:FillBlock(cFrame, size, materialData[1])
				break
			end
		end
	end
	height = math.floor(height / 4) * 4
	if height >= data.waterHeight then return end
	thickness = data.waterHeight - height
	local cFrame = CFrame.new(x * 4 + 2, height + thickness / 2, z * 4 + 2)
	local size = Vector3.new(4, thickness, 4)
	workspace.Terrain:FillBlock(cFrame, size, Enum.Material.Water)
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
	local amount = (distance * 2 + 1) * (distance * 2 + 1) - hole * hole
	for i = 1, amount do
		x += dx z += dz
		if Vector2.new(chunkX - x, chunkZ - z).Magnitude < distance + 0.5 then LoadChunk(x, z) end
		passed += 1
		if passed == length then passed = 0 dx, dz = -dz, dx if dz == 0 then length += 1 end end
	end
end

workspace.CurrentCamera:GetPropertyChangedSignal("Focus"):Connect(function()
	local x = workspace.CurrentCamera.Focus.Position.X
	local z = workspace.CurrentCamera.Focus.Position.Z
	local magnitude = Vector2.new(positionX - x, positionZ - z).Magnitude
	if magnitude < chunkSize * 8 then return end
	positionX, positionZ = x, z
	x = math.floor(positionX / 4 / chunkSize)
	z = math.floor(positionZ / 4 / chunkSize)
	if magnitude < distance * chunkSize * 2 then
		LoadChunks(x, z, math.floor(distance / 2 - 0.5))
	else
		LoadChunks(x, z)
	end
end)