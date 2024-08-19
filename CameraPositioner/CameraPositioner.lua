--!strict
--!native
--!optimize 2

--[[
	Easily move the camera to a part or a part to the camera.
]]

local Selection = game:GetService("Selection")

local Toolbar = plugin:CreateToolbar("CamPositioner")
local CamToPart = Toolbar:CreateButton(
	"CamToPart", 
	"Moves the camera to the selected part", 
	"rbxassetid://19004803672"
)

local PartToCam = Toolbar:CreateButton(
	"PartToCam", 
	"Moves the selected part to the camera", 
	"rbxassetid://19004804783"
)

local camera = workspace.Camera

CamToPart.Click:Connect(function()
	local selection = Selection:Get()

	if #selection < 1 then 
		warn("Select a part to move the camera to.")
		return	
	end

	if #selection > 1 then
		warn("Selection includes multiple objects, please select only one.")
		return
	end

	local selectedObject = selection[1]
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = selectedObject.CFrame
	camera.CameraType = Enum.CameraType.Custom
end)

PartToCam.Click:Connect(function()
	local selection = Selection:Get()

	if #selection < 1 then 
		warn("Select a part to move to the camera.")
		return	
	end

	if #selection > 1 then
		warn("Selection includes multiple objects, please select only one.")
		return
	end

	local selectedObject = selection[1]
	selectedObject.CFrame = camera.CFrame
end)
