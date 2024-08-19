--native
--optimize 2

--[[

	Requires ModuleScripts in studio.
	Does not automatically destroy scripts, allowing the use of connections.
	
	WARNING: DOES NOT AUTOMATICALLY CLEAN CONNECTIONS!
	
]]

local Selection = game:GetService("Selection")

local toolbar = plugin:CreateToolbar("ModuleRunner")
local button = toolbar:CreateButton(
	"Run", 
	"Requires selected ModuleScripts", 
	"rbxassetid://18214486449"
)

button.ClickableWhenViewportHidden = true

local function RunModule()
	local selectedObjects = Selection:Get()

	for _, selectedObject in selectedObjects do
		if not selectedObject:IsA("ModuleScript") then continue end

		local activeModule = selectedObject.Parent:FindFirstChild(selectedObject.Name .." - ACTIVE")
		if activeModule then
			activeModule:Destroy()
		end

		local module = selectedObject:Clone()
		module.Parent = selectedObject.Parent
		module.Name = module.Name .." - ACTIVE"

		require(module)
	end
end

button.Click:Connect(RunModule)
