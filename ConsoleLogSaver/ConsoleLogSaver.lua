--!strict
--!native
--!optimize 2

--[[

	Limitations: 
	- Doesn't differentiate between client and server logs
	- Takes a tiny bit of time to initialize, some initial logs are lost

]]

local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local LogService = game:GetService("LogService")

local maxArchiveSize = 5

local messageTypeNames = {
	[0] = "OUTPUT",
	[1] = "INFO",
	[2] = "WARNING",
	[3] = "ERROR",
}

local function GetFolder() 
	local folder = ServerStorage:FindFirstChild("Output Archive")
	
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Output Archive"
		folder.Parent = ServerStorage
	end
	
	return folder
end

if RunService:IsServer() then
	local newLogs = {}
	
	LogService.MessageOut:Connect(function(message, messageType)		
		local time = os.date("%H_%M_%S")
		local msgType = messageTypeNames[messageType.Value]

		local log = `[{time}] [{msgType}] {message}\n`

		newLogs[#newLogs + 1] = log
	end)
	
	plugin:SetSetting("Logs", nil)
	plugin:SetSetting("IsInPlayMode", true)
	
	game:BindToClose(function()
		plugin:SetSetting("IsInPlayMode", false)
		
		if #newLogs > 0 then
			local logs = ""
			
			for i = 1, #newLogs do
				logs ..= newLogs[i]
				plugin:SetSetting("Logs", logs)
			end
		end 
	end)
end

RunService.Heartbeat:Connect(function()
	if plugin:GetSetting("IsInPlayMode") then return end
	
	local logs = plugin:GetSetting("Logs")
	if not logs then return end
	
	plugin:SetSetting("Logs", nil)
	
	local folder = GetFolder()
	local files = folder:GetChildren()
	
	if #files >= maxArchiveSize then
		files[1]:Destroy()
	end
	
	local outputFile = Instance.new("ModuleScript")
	outputFile.Name = `{os.date("%Y_%m_%d_%H_%M_%S")}`
	outputFile.Parent = folder	
	outputFile.Source = `--[[\n\n{logs}\n]]\n\nreturn ""`
end)
