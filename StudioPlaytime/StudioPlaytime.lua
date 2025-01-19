--!strict
--!native
--!optimize 2

--[[
	Track the time you spend inside studio.
]]

local RunService = game:GetService("RunService")

if RunService:IsRunning() then
	return
end

local PLAYTIME_KEY = "Playtime"
local LAST_CHECK_KEY = "LastCheck"

local toolbar = plugin:CreateToolbar("Playtime")
local button = toolbar:CreateButton(
	"CheckPlaytime", 
	"Check your studio playtime", 
	"rbxassetid://79824075738696"
)

button.ClickableWhenViewportHidden = true

plugin:SetSetting(LAST_CHECK_KEY, DateTime.now().UnixTimestampMillis)

local function updateTime(): number
	local lastCheck = plugin:GetSetting(LAST_CHECK_KEY)

	local oldPlaytime = plugin:GetSetting(PLAYTIME_KEY)
	if not oldPlaytime then
		oldPlaytime = 0
	end
	
	local now = DateTime.now().UnixTimestampMillis
	local diff = now - lastCheck
	
	local playtime = oldPlaytime + diff
	
	plugin:SetSetting(PLAYTIME_KEY, playtime)
	plugin:SetSetting(LAST_CHECK_KEY, now)
	
	return math.round(playtime * 0.001)
end

function convertSeconds(totalSeconds: number): string
	local hours = math.floor(totalSeconds / 3600)
	local minutes = math.floor((totalSeconds % 3600) / 60)
	local seconds = totalSeconds % 60
	return `{hours} Hours {minutes} Minutes {seconds} Seconds`
end

button.Click:Connect(function()
	button.Enabled = false -- hacky way to make it act as a button and not a toggle?
	
	local playtime = updateTime()
	print(`You have been using studio for {convertSeconds(playtime)}`)
	
	button.Enabled = true
end)

plugin.Unloading:Connect(function()
	updateTime()
end)
