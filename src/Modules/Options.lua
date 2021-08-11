local module = {}

local seedsGroup = nil
local materialsGroup = nil
local seeds = {}
local materials = {}

CreateSeed = function(data)
	local seed = _G.classes["Seed"].New(data)
	table.insert(seeds, seed)
	table.insert(_G.modules["Terrain"].seeds, {data[1], data[2], data[3], data[4], data[5]})
	seed.gui.LayoutOrder = #seeds
	seedsGroup:AddChild(seed.gui)
	seed.event:Bind(function(event, data)
		local key = nil
		for i, object in ipairs(seeds) do if seed == object then key = i break end end
		if event == 1 then
			_G.modules["Terrain"].seeds[key] = {data[1], data[2], data[3], data[4], data[5]}
		elseif event == 2 then
			local key2 = key - 1
			if key2 < 1 then key2 = #seeds end
			seeds[key].gui.LayoutOrder, seeds[key2].gui.LayoutOrder = seeds[key2].gui.LayoutOrder, seeds[key].gui.LayoutOrder
			seeds[key], seeds[key2] = seeds[key2], seeds[key]
			_G.modules["Terrain"].seeds[key], _G.modules["Terrain"].seeds[key2] = _G.modules["Terrain"].seeds[key2], _G.modules["Terrain"].seeds[key]
		elseif event == 3 then
			local key2 = key + 1
			if key2 > #seeds then key2 = 1 end
			seeds[key].gui.LayoutOrder, seeds[key2].gui.LayoutOrder = seeds[key2].gui.LayoutOrder, seeds[key].gui.LayoutOrder
			seeds[key], seeds[key2] = seeds[key2], seeds[key]
			_G.modules["Terrain"].seeds[key], _G.modules["Terrain"].seeds[key2] = _G.modules["Terrain"].seeds[key2], _G.modules["Terrain"].seeds[key]
		elseif event == 4 then
			seed:Destroy()
			table.remove(seeds, key)
			table.remove(_G.modules["Terrain"].seeds, key)
		end
	end)
end

ClearSeeds = function()
	for i, object in ipairs(seeds) do
		object:Destroy()
	end
	seeds = {}
	_G.modules["Terrain"].seeds = {}
end

CreateMaterial = function(data)
	local material = _G.classes["Material"].New(data)
	table.insert(materials, material)
	table.insert(_G.modules["Terrain"].materials, {data[1], data[2], data[3], data[4], data[5]})
	material.gui.LayoutOrder = #materials
	materialsGroup:AddChild(material.gui)
	material.event:Bind(function(event, data)
		local key = nil
		for i, object in ipairs(materials) do if material == object then key = i break end end
		if event == 1 then
			if data[1] == nil then
				material:Destroy()
				table.remove(materials, key)
				table.remove(_G.modules["Terrain"].materials, key)
			else
				_G.modules["Terrain"].materials[key] = {data[1], data[2], data[3], data[4], data[5]}
			end
		elseif event == 2 then
			local key2 = key - 1
			if key2 < 1 then key2 = #materials end
			materials[key].gui.LayoutOrder, materials[key2].gui.LayoutOrder = materials[key2].gui.LayoutOrder, materials[key].gui.LayoutOrder
			materials[key], materials[key2] = materials[key2], materials[key]
			_G.modules["Terrain"].materials[key], _G.modules["Terrain"].materials[key2] = _G.modules["Terrain"].materials[key2], _G.modules["Terrain"].materials[key]
		elseif event == 3 then
			local key2 = key + 1
			if key2 > #materials then key2 = 1 end
			materials[key].gui.LayoutOrder, materials[key2].gui.LayoutOrder = materials[key2].gui.LayoutOrder, materials[key].gui.LayoutOrder
			materials[key], materials[key2] = materials[key2], materials[key]
			_G.modules["Terrain"].materials[key], _G.modules["Terrain"].materials[key2] = _G.modules["Terrain"].materials[key2], _G.modules["Terrain"].materials[key]
		end
	end)
end

ClearMaterials = function()
	for i, object in ipairs(materials) do
		object:Destroy()
	end
	materials = {}
	_G.modules["Terrain"].materials = {}
end

module.Initiate = function()
	local widgetButton = _G.classes["WidgetButton"].New("Terrain", "rbxassetid://3079007970", 1)
	local widgetPage = _G.classes["WidgetPage"].New()
	widgetButton:Select()
	widgetPage:Show()
	widgetButton:Activated(function()
		_G.plugin:Deactivate()
	end)
		
	_G.plugin.Deactivation:Connect(function()
		widgetButton:Select()
		widgetPage:Show()
	end)
	
	local dataGroup = _G.classes["Group"].New("Data")
	widgetPage:AddChild(dataGroup.gui)

	local generateOption = _G.classes["Toggle"].New("Generate Terrain", false)
	dataGroup:AddChild(generateOption.gui)
	generateOption.event:Bind(function(value)
		_G.modules["Terrain"].Enable(value)
	end)
	
	local distanceOption = _G.classes["Number"].New("Distance", _G.modules["Terrain"].distance, {["minimum"] = 1, ["round"] = 0})
	dataGroup:AddChild(distanceOption.gui)
	distanceOption.event:Bind(function(value)
		_G.modules["Terrain"].distance = value
	end)
	
	local shiftOption = _G.classes["Number"].New("Shift", _G.modules["Terrain"].shift)
	dataGroup:AddChild(shiftOption.gui)
	shiftOption.event:Bind(function(value)
		_G.modules["Terrain"].shift = value
	end)
	
	local waterHeightOption = _G.classes["Number"].New("Water Height", _G.modules["Terrain"].waterHeight)
	dataGroup:AddChild(waterHeightOption.gui)
	waterHeightOption.event:Bind(function(value)
		_G.modules["Terrain"].waterHeight = value
	end)
	
	local minimumHeightOption = _G.classes["Number"].New("Minimum Height", _G.modules["Terrain"].minimumHeight)
	dataGroup:AddChild(minimumHeightOption.gui)
	minimumHeightOption.event:Bind(function(value)
		_G.modules["Terrain"].minimumHeight = value
	end)
	
	local maximumHeightOption = _G.classes["Number"].New("Maximum Height", _G.modules["Terrain"].maximumHeight)
	dataGroup:AddChild(maximumHeightOption.gui)
	maximumHeightOption.event:Bind(function(value)
		_G.modules["Terrain"].maximumHeight = value
	end)
	
	seedsGroup = _G.classes["Group"].New("Seeds")
	widgetPage:AddChild(seedsGroup.gui)
	
	local seedOption = _G.classes["Button"].New("Add Seed")
	seedOption.gui.LayoutOrder = 2147483647
	seedsGroup:AddChild(seedOption.gui)
	seedOption.event:Bind(function()
		CreateSeed({_G.modules["Functions"].Round(math.random(10000, 99999) + math.random(), 3), 50, 0.04, -10, 10})
	end)
	
	materialsGroup = _G.classes["Group"].New("Materials")
	widgetPage:AddChild(materialsGroup.gui)
	
	local materialOption = _G.classes["Button"].New("Add Material")
	materialOption.gui.LayoutOrder = 2147483647
	materialsGroup:AddChild(materialOption.gui)
	materialOption.event:Bind(function()
		CreateMaterial({1376, -10000, 10000, 0, 10000})
	end)
	
	local functionsGroup = _G.classes["Group"].New("Functions")
	widgetPage:AddChild(functionsGroup.gui)
	
	local saveOption = _G.classes["Button"].New("Save")
	functionsGroup:AddChild(saveOption.gui)
	saveOption.event:Bind(function()
		local selection = game.Selection:Get()[1]
		if selection == nil then return end
		for i, child in ipairs(selection:GetChildren()) do
			if child.Name ~= "TerrainData" then continue end
			if child.ClassName ~= "ModuleScript" then continue end
			if child:GetAttribute("Data") ~= "Terrain" then continue end
			child:Destroy()
		end
		local buffer = {}
		local moduleScript = Instance.new("ModuleScript")
		moduleScript.Name = "TerrainData"
		moduleScript:SetAttribute("Data", "Terrain")
		
		table.insert(buffer, 'return {\n')
		
		table.insert(buffer, '	["shift"] = ')
		table.insert(buffer, _G.modules["Terrain"].shift)
		table.insert(buffer, ',\n')
		
		table.insert(buffer, '	["waterHeight"] = ')
		table.insert(buffer, _G.modules["Terrain"].waterHeight)
		table.insert(buffer, ',\n')
		
		table.insert(buffer, '	["minimumHeight"] = ')
		table.insert(buffer, _G.modules["Terrain"].minimumHeight)
		table.insert(buffer, ',\n')
		
		table.insert(buffer, '	["maximumHeight"] = ')
		table.insert(buffer, _G.modules["Terrain"].maximumHeight)
		table.insert(buffer, ',\n')
		
		table.insert(buffer, '	["seeds"] = {\n')
		for i, data in ipairs(_G.modules["Terrain"].seeds) do
			table.insert(buffer, '		{')
			table.insert(buffer, data[1])
			table.insert(buffer, ', ')
			table.insert(buffer, data[2])
			table.insert(buffer, ', ')
			table.insert(buffer, data[3])
			table.insert(buffer, ', ')
			table.insert(buffer, data[4])
			table.insert(buffer, ', ')
			table.insert(buffer, data[5])
			table.insert(buffer, '},\n')
		end
		table.insert(buffer, '	},\n')
		
		table.insert(buffer, '	["materials"] = {\n')
		for i, data in ipairs(_G.modules["Terrain"].materials) do
			table.insert(buffer, '		{')
			table.insert(buffer, data[1])
			table.insert(buffer, ', ')
			table.insert(buffer, data[2])
			table.insert(buffer, ', ')
			table.insert(buffer, data[3])
			table.insert(buffer, ', ')
			table.insert(buffer, data[4])
			table.insert(buffer, ', ')
			table.insert(buffer, data[5])
			table.insert(buffer, '},\n')
		end
		table.insert(buffer, '	},\n')
		
		table.insert(buffer, '}')
		
		moduleScript.Source = table.concat(buffer)		
		moduleScript.Parent = selection
	end)
		
	local loadOption = _G.classes["Button"].New("Load")
	functionsGroup:AddChild(loadOption.gui)
	loadOption.event:Bind(function()
		local selection = game.Selection:Get()[1]
		if selection == nil then return end
		if selection.ClassName ~= "ModuleScript" then return end
		if selection:GetAttribute("Data") ~= "Terrain" then return end
		
		local func = loadstring(selection.Source)
		if typeof(func) ~= "function" then return end
		local data = func()
		if typeof(data) ~= "table" then return end
		
		shiftOption:Set(data.shift)
		waterHeightOption:Set(data.waterHeight)
		minimumHeightOption:Set(data.minimumHeight)
		maximumHeightOption:Set(data.maximumHeight)
		
		ClearSeeds()
		for i, data in ipairs(data.seeds) do
			CreateSeed(data)
		end
		
		ClearMaterials()
		for i, data in ipairs(data.materials) do
			CreateMaterial(data)
		end
	end)
	
	local LocalOption = _G.classes["Button"].New("Create Local Script")
	functionsGroup:AddChild(LocalOption.gui)
	LocalOption.event:Bind(function()
		local clone = _G.root.LocalScript:Clone()
		clone.Name = "Terrain"
		clone.Disabled = false
		clone.Parent = game.ReplicatedFirst
		game.Selection:Set({clone})
	end)
	
	local clearTerrainOption = _G.classes["Button"].New("Clear Terrain")
	functionsGroup:AddChild(clearTerrainOption.gui)
	clearTerrainOption.event:Bind(function()
		_G.modules["Terrain"].Clear()
	end)

	local clearAllTerrainOption = _G.classes["Button"].New("Clear All Terrain")
	functionsGroup:AddChild(clearAllTerrainOption.gui)
	clearAllTerrainOption.event:Bind(function()
		_G.modules["Terrain"].ClearAll()
	end)
end

return module
