-- Requires: brew install blueutil

-- === Path to blueutil (adjust if needed) ===
local blueutil = "/opt/homebrew/bin/blueutil"

-- === Devices to watch ===
local devicesToWatch = {
	"Kinesis Keyboard Hub",
	"USB Billboard Device",
}

-- === Helpers ===
local function trim(s)
	return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local connectedDevices = {}
for _, name in ipairs(devicesToWatch) do
	connectedDevices[name] = false
end

local log = hs.logger.new("USB-BT", "debug") -- use "info" for less noise

local function anyConnected()
	for _, state in pairs(connectedDevices) do
		if state then
			return true
		end
	end
	return false
end

local function getBluetoothState()
	return trim(hs.execute(blueutil .. " --power"))
end

local function setBluetoothState(on)
	if on then
		hs.execute(blueutil .. " --power 1")
	else
		hs.execute(blueutil .. " --power 0")
	end
end

local function updateBluetooth()
	local wantOn = anyConnected()
	local current = getBluetoothState()
	log.d(
		"Devices="
			.. hs.inspect(connectedDevices)
			.. " | wantOn="
			.. tostring(wantOn)
			.. " | current="
			.. tostring(current)
	)

	if wantOn and current ~= "1" then
		setBluetoothState(true)
		log.i("Bluetooth -> ON")
		hs.notify.new({ title = "Bluetooth", informativeText = "Turned ON" }):send()
	elseif (not wantOn) and current ~= "0" then
		setBluetoothState(false)
		log.i("Bluetooth -> OFF")
		hs.notify.new({ title = "Bluetooth", informativeText = "Turned OFF" }):send()
	end
end

-- === Init devices at startup ===
local function initDevices()
	for _, d in ipairs(hs.usb.attachedDevices()) do
		local pn = trim(d.productName)
		for _, name in ipairs(devicesToWatch) do
			if pn == name then
				connectedDevices[name] = true
			end
		end
	end
	updateBluetooth()
end

-- === USB watcher ===
if usbWatcher then
	usbWatcher:stop()
end
usbWatcher = hs.usb.watcher.new(function(e)
	local pn = trim(e.productName)
	for _, name in ipairs(devicesToWatch) do
		if pn == name then
			if e.eventType == "added" then
				connectedDevices[name] = true
				log.d("Added: " .. name)
			elseif e.eventType == "removed" then
				connectedDevices[name] = false
				log.d("Removed: " .. name)
			end
			updateBluetooth()
		end
	end
end)
usbWatcher:start()

-- === Kick things off ===
initDevices()
