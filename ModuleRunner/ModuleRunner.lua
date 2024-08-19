--native
--optimize 2

--[[

	Requires ModuleScripts in studio.
	
]]

local Selection = game:GetService("Selection")

local toolbar = plugin:CreateToolbar("ScriptRunner")
local button = toolbar:CreateButton("Run", "", "rbxassetid://18214486449")
button.ClickableWhenViewportHidden = true

local function RunModule()
	local selectedObjects = Selection:Get()

	for _, selectedObject in selectedObjects do
		if not selectedObject:IsA("ModuleScript") then continue end
		local module = selectedObject:Clone()
		module.Parent = selectedObject.Parent
		
		pcall(function()
			require(module)
		end)
		
		module:Destroy()
	end
end

button.Click:Connect(RunModule)
