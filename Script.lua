--[[
%% properties
%% globals
%% killOtherInstances
--]]

local lights = {} 
local detectors = {} 
local globalVariableName = "" 

local startSource = fibaro:getSourceTrigger()
local triggeredBySpecifiedDevices = false
local shouldTurnLightsOn = false

if not globalVariableName or globalVariableName == ""  then
	print("vennligst velg et navn til variabelen.")
	do return end
end

if not fibaro:getGlobalValue(globalVariableName) then
	print(string.format("husk å opprette variabelen $s før du bruker denne koden.", globalVariableName))
	do return end
end

if startSource["type"] == "property" then
	local triggeringDeviceId = startSource["deviceID"]
	local triggeringDevicePropertyName = startSource["propertyName"]
	local triggeringDeviceValue = fibaro:getValue(triggeringDeviceId, "value")
	print(string.format("Scene trigget av %s %s som har verdien %s.", triggeringDeviceId, triggeringDevicePropertyName, triggeringDeviceValue))
	for i, v in ipairs(detectors) do
		if v == triggeringDeviceId and tonumber(triggeringDeviceValue) > 0 then 
			triggeredBySpecifiedDevices = true
			shouldTurnLightsOn = true
			break
		end
	end
elseif startSource["type"] == "other" then
	print("Scene ble trigget manuelt")
	shouldTurnLightsOn = true
end

if shouldTurnLightsOn then
	print("Lys på!.")
	for i, deviceId in ipairs(lights) do
		print(string.format("Turning on %s.", deviceId))
		fibaro:call(deviceId, "turnOn")
	end
	print("lys på!")
	local timestamp = os.time()
	print(string.format("setter tidspunkt: %s", os.date("%c",timestamp)))
	fibaro:setGlobal(globalVariableName, timestamp)
end
