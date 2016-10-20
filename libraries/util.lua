local util = {}

--[[
	util.lua

	Useful Tool in Love

	TurtleP

	v2.0
--]]

local scale = {1, 1}

function util.changeScale(scalar)
	scale = scalar

	love.window.setMode(love.graphics.getWidth() * scalar, love.graphics.getHeight() * scalar)
end

function string:split(delimiter) --Not by me
	local result = {}
	local from   = 1
	local delim_from, delim_to = string.find( self, delimiter, from   )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from   )
	end
	table.insert( result, string.sub( self, from   ) )
	return result
end

function util.round(num, idp) --Not by me
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function util.toBoolean(stringCompare)
	return tostring(stringCompare) == "true"
end

function util.setScalar(xScale, yScale)
	scale = {xScale, yScale}
end

function util.changeState(toState, ...)
	local arg = {...} or {}

	if _G[toState .. "Init"] then
		state = toState
		
		_G[toState .. "Init"](unpack(arg))
	end

end

function util.lerp(a, b, t) 
	return (1 - t) * a + t * b 
end

function util.updateState(dt)
	if _G[state .. "Update"] then
		_G[state .. "Update"](dt)
	end
end

function util.renderState()
	if _G[state .. "Draw"] then
		_G[state .. "Draw"]()
	end
end

function util.keyPressedState(key)
	if _G[state .. "KeyPressed"] then
		_G[state .. "KeyPressed"](key)
	end
end

function util.keyReleasedState(key)
	if _G[state .. "KeyReleased"] then
		_G[state .. "KeyReleased"](key)
	end
end

function util.mousePressedState(x, y, button)
	if _G[state .. "MousePressed"] then
		_G[state .. "MousePressed"](x, y, button)
	end
end

function util.mouseReleasedState(x, y, button)
	if _G[state .. "MouseReleased"] then
		_G[state .. "MouseReleased"](x, y, button)
	end
end

function util.textInput(text)
	if _G[state .. "TextInput"] then
		_G[state .. "TextInput"](text)
	end
end

function util.mouseMovedState(x, y, dx, dy)
	if _G[state .. "MouseMoved"] then
		_G[state .. "MouseMoved"](x, y, dx, dy)
	end
end

function util.dist(x1,y1, x2,y2) 
	return ((x2-x1)^2+(y2-y1)^2)^0.5 
end

function util.clamp(val, min, max)
	return math.max(min, math.min(val, max))
end

function util.getWidth()
	return love.graphics.getWidth()
end

function util.getHeight()
	return love.graphics.getHeight()
end

return util
