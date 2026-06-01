--!strict
--!native
--!optimize 2

--[[

    Prompts to save the selected instance to a file and automatically sets it's filename.

    Additionally deletes original selected object, waits for a replacement by rojo, which it
    deletes and adds back the original.

    This prevents rojo from corrupting the object.

]]

local Selection = game:GetService("Selection")

local Toolbar = plugin:CreateToolbar("Save To File")
local SaveButton = Toolbar:CreateButton(
    "SaveToFile", 
    "Save selected object to .rbxm", 
    "rbxassetid://99870550578082"
)

SaveButton.ClickableWhenViewportHidden = true

SaveButton.Click:Connect(function()
    local selection = Selection:Get()

    if #selection < 1 then 
        warn("Select an object to export")
        return    
    end

    for _, selectedObject in selection do
        local copy = selectedObject:Clone()
        local parent = selectedObject.Parent

        Selection:Set({ selectedObject })
        local success = plugin:PromptSaveSelection(selectedObject.Name)
        if success then
            task.wait()
            selectedObject:Destroy()

            local ghostInstance = parent:WaitForChild(copy.Name, 1) 
            if ghostInstance then
                ghostInstance:Destroy()
            end

            task.wait()
            copy.Parent = parent
        end
        
        task.wait()
    end    
    
    Selection:Set({})
end)
