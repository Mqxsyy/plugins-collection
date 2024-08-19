--[[

	Anchors/Unanchors all descendants of selected object

]]

local Selection = game:GetService("Selection")

local toolbar = plugin:CreateToolbar("Descendants Anchorer")
local anchorButton = toolbar:CreateButton("Anchor", "", "rbxassetid://18215389607")
local unanchorButton = toolbar:CreateButton("Unanchor", "", "rbxassetid://18215390596")

local function AnchorDescendants()
	local selectedObjects = Selection:Get()

	for _, selectedObject in selectedObjects do		
		local descendants = selectedObject:GetDescendants()
		table.insert(descendants, selectedObject)
		
		for _, descendant in descendants do
			if not descendant:IsA("BasePart") then continue end
			descendant.Anchored = true
		end 
	end
end

local function UnanchorDescendants()
	local selectedObjects = Selection:Get()

	for _, selectedObject in selectedObjects do
		local descendants = selectedObject:GetDescendants()
		table.insert(descendants, selectedObject)
		
		for _, descendant in descendants do
			if not descendant:IsA("BasePart") then continue end
			descendant.Anchored = false
		end 
	end
end

anchorButton.Click:Connect(AnchorDescendants)
unanchorButton.Click:Connect(UnanchorDescendants)
