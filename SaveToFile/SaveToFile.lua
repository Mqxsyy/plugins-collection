--!strict
--!native
--!optimize 2

--[[

  Prompts to save the selected instance to a file and automatically sets it's filename.

]]

local Selection = game:GetService("Selection")

local Toolbar = plugin:CreateToolbar("Save To File")
local SaveButton = Toolbar:CreateButton(
	"SaveToFile", 
	"Save selected object to .rbxm", 
	"rbxassetid://18961222990"
)

SaveButton.Click:Connect(function()
	local selection = Selection:Get()
	
	if #selection < 1 then 
		warn("Select an object to export")
		return	
	end
	
	if #selection > 1 then
		warn("Selection includes multiple objects, please select only one")
		return
	end
	
	local selectedObject = selection[1]
	plugin:PromptSaveSelection(selectedObject.Name)
end)
