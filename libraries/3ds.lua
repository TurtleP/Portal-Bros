local _KEYNAMES =
{
	"a", "b", "select", "start",
	"right", "left", "up", "down",
	"rbutton", "lbutton", "x", "y",
	"lzbutton", "rzbutton", "cstickright", 
	"cstickleft", "cstickup", "cstickdown",
	"cpadright", "cpadleft", "cpadup", "cpaddown"
}

_EMULATEHOMEBREW = (love.system.getOS() == "3ds")

BUTTONCONFIG =
{
	["a"] = "space",
	["b"] = "lshift",
	["y"] = "",
	["x"] = "",
	["start"] = "return",
	["select"] = "r",
	["up"] = "w",
	["left"] = "a",
	["right"] = "d",
	["down"] = "s",
	["rbutton"] = "e",
	["lbutton"] = "q",
	["cpadright"] = "",
	["cpadleft"] = "",
	["cpadup"] = "",
	["cpaddown"] = "",
	["cstickleft"] = "left",
	["cstickright"] = "right",
	["cstickup"] = "up",
	["cstickdown"] = "down"
}

function love.graphics.setDepth(depthValue)
	assert(depthValue and type(depthValue) == "number", "Number expected: got " .. type(depthValue))
end

function love.graphics.set3D(enable3D)
	assert(enable3D and type(enable3D) == "boolean", "Boolean expected: got " .. type(depthValue))
end

function love.system.getWifiStrength()
	return 3
end

function love.filesystem.exists(path)
	print(love.filesystem.getWorkingDirectory() .. "/" .. path)
	return io.open(love.filesystem.getWorkingDirectory() .. "/" .. path) ~= nil
end

local olddraw = love.graphics.draw
function love.graphics.draw(...)
	local args = {...}
	
	if love.graphics.getScreen() == "bottom" then
		if type(args[2]) == "userdata" then
			args[3] = args[3] + 40
			args[4] = args[4] + 240
			if args[5] and args[5] > 0 then
				args[3] = args[3] + args[1]:getWidth() / 2
				args[4] = args[4] + args[1]:getHeight() / 2
			end
		else
			args[2] = args[2] + 40
			args[3] = args[3] + 240
		end
	end

	if type(args[2]) ~= "userdata" then
		olddraw(args[1], args[2] + args[1]:getWidth() / 2, args[3] + args[1]:getHeight() / 2, args[4], 1, 1, args[1]:getWidth() / 2, args[1]:getHeight() / 2)
	else
		olddraw(args[1], args[2], args[3], args[4], args[5], args[6], args[7])
	end
end

local olddofile = dofile
function dofile(...)
	return love.filesystem.load(...)()
end

local oldRectangle = love.graphics.rectangle
function love.graphics.rectangle(mode, x, y, width, height)
	local x = x or 0
	local y = y or 0
	if love.graphics.getScreen() == "bottom" then
		x = x + 40
		y = y + 240
	end
	oldRectangle(mode, x, y, width, height)
end

local oldCircle = love.graphics.circle
function love.graphics.circle(mode, x, y, r, segments)
	local x = x or 0
	local y = y or 0
	oldCircle(mode, x, y, r, segments)
end

local oldPrint = love.graphics.print
function love.graphics.print(text, x, y, r, scalex, scaley, sx, sy)
	local x = x or 0
	local y = y or 0
	if love.graphics.getScreen() == "bottom" then
		x = x + 40
		y = y + 240
	end
	oldPrint(text, x, y, r, scalex, scaley, sx, sy)
end
	
local oldKey = love.keypressed
function love.keypressed(key)
	for k, v in pairs(BUTTONCONFIG) do
		if key == v then
			oldKey(k)
			break
		end
	end
end

local oldKey = love.keyreleased
function love.keyreleased(key)
	for k, v in pairs(BUTTONCONFIG) do
		if key == v then
			oldKey(k)
			break
		end
	end
end

function math.clamp(low, n, high) 
	return math.min(math.max(low, n), high) 
end

local oldMousePressed = love.mousepressed	
function love.mousepressed(x, y, button)
	x, y = math.clamp(0, x - 40, 320)+40, math.clamp(0, y - 240, 240) + 240

	if oldMousePressed then
		oldMousePressed(x, y, 1)
	end
end

local oldMouseReleased = love.mousereleased
function love.mousereleased(x, y, button)
	x, y = math.clamp(0, x - 40, 320), math.clamp(0, y - 240, 240)

	if oldMouseReleased then
		oldMouseReleased(x, y, 1)
	end
end

_SCREEN = "top"

models = {"3DS", "3DSXL"}
function love.system.getModel()
	return models[scale]
end

function love.system.setModel(s)
	scale = s
		
	util.setScalar(s, s)

	if love.system.getModel() ~= "PC" then
		love.window.setMode(400 * scale, 480 * scale, {vsync = true})
	else
		love.window.setMode(400 * scale, 240 * scale, {vsync = true})
	end

	love.window.setTitle(love.filesystem.getIdentity() .. " :: " .. love.system.getModel())
end

love.system.setModel(1)

function love.graphics.setScreen(screen)
	assert(type(screen) == "string", "String expected, got " .. type(screen))
	_SCREEN = screen

	love.graphics.setColor(32, 32, 32)

	love.graphics.push()
	love.graphics.origin()
	love.graphics.rectangle("fill", 0, 240, 40, 240)
	love.graphics.rectangle("fill", 360, 240, 40, 240)
	
	love.graphics.pop()
	love.graphics.setColor(255, 255, 255)

	if screen == "top" then
		love.graphics.setScissor(0, 0, 400, 240)
	elseif screen == "bottom" then
		love.graphics.setScissor(0, 0, 320, 240)
	end
end

function love.graphics.getWidth()
	if love.graphics.getScreen() == "bottom" then
		return 320
	end
	return 400
end

function love.graphics.getHeight()
	return 240
end

function love.graphics.getScreen()
	return _SCREEN
end

local oldScissor = love.graphics.setScissor
function love.graphics.setScissor(...)
	local args = {...}

	if #args > 0 then
		if love.graphics.getScreen() == "bottom" then
			args[1] = args[1] + 40
			args[2] = args[2] + 240
		end
	end

	oldScissor(unpack(args))
end

local oldclear = love.graphics.clear
function love.graphics.clear(r, g, b, a)
	love.graphics.setScissor()

	oldclear(r, g, b, a)
end
