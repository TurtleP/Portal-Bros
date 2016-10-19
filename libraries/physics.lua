--[[
	Turtle's Physics Library
	All code is mine.
	(c) 2015 Tiny Turtle Industries
	(Obviously same licensing as the game)
	v1.2
--]]

local floor = math.floor
local dist = util.dist
local abs = math.abs

--[[

	CATEGORIES:

	1. TILE
	2. PLAYER
	3. COINBLOCK
	4. ENEMY
	5. PORTAL
	6. ???

--]]

function physicsupdate(dt)
	for cameraIndex = 1, #cameraObjects do
		local objData = cameraObjects[cameraIndex][2]

		if cameraObjects[cameraIndex][1] ~= "tile" then
			if objData.active and not objData.static then
				local hor, ver = false, false

				objData.speedy = math.min(objData.speedy + objData.gravity * dt, 15 * 60) --add gravity to objects

				if objData.mask then
					for maskIndex, mask in ipairs(objData.mask) do

						for i = 1, #cameraOtherObjects do
							if cameraOtherObjects[i][1] == mask then
								local obj2Data = cameraOtherObjects[i][2]
								if aabb(objData.x + objData.speedx * dt, objData.y + objData.speedy * dt, objData.width, objData.height, obj2Data.x, obj2Data.y, obj2Data.width, obj2Data.height) then
									hor, ver = checkCollision(objData, cameraObjects[cameraIndex][1], cameraOtherObjects[i][2], mask, dt)
								end
							end
						end

					end
				end

				if hor == false then
					objData.x = objData.x + objData.speedx * dt
				end

				if ver == false then
					objData.y = objData.y + objData.speedy * dt
				end
			end
		end

		if objData.screen == player.screen then
			if objData.update then
				objData:update(dt)
			end
		end
	end
end

function checkPassive(objData, objName, obj2Data, obj2Name, dt)
	if aabb(objData.x + objData.speedx * dt, objData.y + objData.speedy * dt, objData.width, objData.height, obj2Data.x, obj2Data.y, obj2Data.width, obj2Data.height) then
		if objData.passiveCollide then
			objData:passiveCollide(obj2Name, obj2Data)
		end
	end
end

function checkCollision(objData, objName, obj2Data, obj2Name, dt)
	local hor, ver = false, false

	if not objData.passive then
		if not obj2Data.passive then
			if aabb(objData.x, objData.y + objData.speedy * dt, objData.width, objData.height, obj2Data.x, obj2Data.y, obj2Data.width, obj2Data.height) then --was vertical
				ver = verticalCollide(objName, objData, obj2Name, obj2Data)
			elseif aabb(objData.x + objData.speedx * dt, objData.y, objData.width, objData.height, obj2Data.x, obj2Data.y, obj2Data.width, obj2Data.height) then
				hor = horizontalCollide(objName, objData, obj2Name, obj2Data)
			end
		else
			checkPassive(objData, objName, obj2Data, obj2Name, dt)
		end
	end

	return hor, ver
end

function checkCamera(x, y, width, height)
	local ret = {}

	for k, v in pairs(objects) do
		for j, w in ipairs(v) do
			if w.active and w.screen == player.screen then
				if aabb(x, y, width, height, w.x, w.y, w.width, w.height) then
					table.insert(ret, {k, w})
				end
			end
		end
	end

	return ret
end

function checkrectangle(x, y, width, height, check, callback, allow)
	local ret = {}
	local checkObjects = "list"
	local exclude
	
	if type(check) == "table" and check[1] == "exclude" then
		checkObjects = "all"
		exclude = check[2]
	end

	for k, v in pairs(objects) do
		local hasObject = false
		if check and checkObjects ~= "all" then
			for j = 1, #check do
				if check[j] == k then
					hasObject = true
				end
			end
		end

		if checkObjects == "all" or hasObject then
			for s, t in pairs(v) do
				if allow or checkObjects ~= "all" then
					local skip = false
					if exclude then
						if t.x == exclude.x and t.y == exclude.y then
							skip = true
						end

						if t.screen ~= exclude.screen then
							skip = true
						end
					end

					if not skip then
						if t.active then
							if aabb(x, y, width, height, t.x, t.y, t.width, t.height) then
								table.insert(ret, {k, t})
							end
						end
					end
				end
			end
		end
	end

	return ret
end

function horizontalCollide(objName, objData, obj2Name, obj2Data)
	if objData.speedx > 0 then
		if objData.rightCollide then --first object collision
			if objData:rightCollide(obj2Name, obj2Data) ~= false then
				if objData.speedx > 0 then
					objData.speedx = 0
				end
				objData.x = obj2Data.x - objData.width
				return true
			end
		else 
			if objData.speedx < 0 then
				objData.speedx = 0
			end
			objData.x = obj2Data.x - objData.width
			return true
		end	

		if obj2Data.leftCollide then --opposing object collides
			if obj2Data:leftCollide(objName, objData) ~= false then
				if obj2Data.speedx < 0 then
					obj2Data.speedx = 0
				end
			end
		else
			if obj2Data.speedx < 0 then
				obj2Data.speedx = 0
			end
		end
	else
		if objData.leftCollide then
			if objData:leftCollide(obj2Name, obj2Data) ~= false then
				if objData.speedx < 0 then
					objData.speedx = 0
				end
				objData.x = obj2Data.x + obj2Data.width
				return true
			end
		else 
			if objData.speedx < 0 then
				objData.speedx = 0
			end
			objData.x = obj2Data.x + obj2Data.width
			return true
		end

		if obj2Data.rightCollide then
			--Item 2 collides..
			if obj2Data:rightCollide(objName, objData) ~= false then
				if obj2Data.speedx > 0 then
					obj2Data.speedx = 0
				end
			end
		else
			if obj2Data.speedx > 0 then
				obj2Data.speedx = 0
			end
		end
	end

	return false
end

function enterPortal(self, dir, portal)
	if not portal.open then
		return
	end
	
	if dir == "down" then
		if portal.dir == 1 then
			if not self.portaled then
				if self.y + self.height / 2 > portal.y then
					self.portaled = true
					portal:transfer(self, dir)
				end
				return false
			end
		else
			if aabb(self.x, self.y, self.width, self.height, portal.x, portal.y, portal.width, portal.height) then
				if portal.dir == 2 then
					if self.y > portal.y then
						return false
					end
				elseif portal.dir == 3 then
					if self.y > portal.y then
						return false
					end
				elseif portal.dir == 4 then
					if self.y > portal.y then
						return false
					end
				end
			end
		end
	elseif dir == "up" then
		if portal.dir == 2 then
			if not self.portaled then
				if self.y + self.height / 2 < portal.y + portal.offset then
					self.portaled = true
					portal:transfer(self, dir)
				end
				return false
			end
        else
			if aabb(self.x, self.y, self.width, self.height, portal.x, portal.y, portal.width, portal.height) then
				if portal.dir == 1 then
					if self.y < portal.y then
						return false
					end
				elseif portal.dir == 3 then
					if self.y > portal.y then
						return false
					end
				elseif portal.dir == 4 then
					if self.y > portal.y then
						return false
					end
				end
			end
		end
	elseif dir == "left" then
		if portal.dir == 3 then
			if not self.portaled then
				if self.x > portal.x + portal.glowOffsetX then
					self.portaled = true
					portal:transfer(self, dir)
				end
				return false
			end
		else
			if aabb(self.x, self.y, self.width, self.height, portal.x, portal.y, portal.width, portal.height) then
				if portal.dir == 1 then
					if self.y < portal.y then 
						return false
					end
				elseif portal.dir == 2 then
					if self.y > portal.y then
						return false
					end
				elseif portal.dir == 4 then
					if self.x < portal.x then
						return false
					end
				end
			end
		end
	elseif dir == "right" then
		if portal.dir == 4 then
			if not self.portaled then
				if self.x + self.width / 2 > portal.x + portal.glowOffsetX then
					self.portaled = true
					portal:transfer(self, dir)
				end
				return false
			end
		else
			if aabb(self.x, self.y, self.width, self.height, portal.x, portal.y, portal.width, portal.height) then
				if portal.dir == 1 then
					if self.y < portal.y then 
						return false
					end
				elseif portal.dir == 2 then
					if self.y > portal.y then
						return false
					end
				elseif portal.dir == 3 then
					if self.x > portal.x then
						return false
					end
				end
			end
		end
	end
end

function verticalCollide(objName, objData, obj2Name, obj2Data)
	if objData.speedy > 0 then
		if objData.downCollide then --first object collision
			if objData:downCollide(obj2Name, obj2Data) ~= false then
				if objData.speedy > 0 then
					objData.speedy = 0
				end
				objData.y = obj2Data.y - objData.height
				return true
			end
		else
			if objData.speedy > 0 then
				objData.speedy = 0
			end
			objData.y = obj2Data.y - objData.height
			return true
		end	

		if obj2Data.upCollide then --opposing object collides
			--Item 2 collides..
			if obj2Data:upCollide(objName, objData) ~= false then
				if obj2Data.speedy < 0 then
					obj2Data.speedy = 0
				end
			end
		else
			if obj2Data.speedy < 0 then
				obj2Data.speedy = 0
			end
		end
	else
		if objData.upCollide then
			if objData:upCollide(obj2Name, obj2Data) ~= false then
				if objData.speedy < 0 then
					objData.speedy = 0
				end
				objData.y = obj2Data.y + obj2Data.height
				return true
			end
		else 
			if objData.speedy < 0 then
				objData.speedy = 0
			end
			objData.y = obj2Data.y + obj2Data.height
			return true
		end

		if obj2Data.downCollide then
			--Item 2 collides..
			if obj2Data:downCollide(objName, objData) ~= false then
				if obj2Data.speedy > 0 then
					obj2Data.speedy = 0
				end
			end
		else
			if obj2Data.speedy > 0 then
				obj2Data.speedy = 0
			end
		end
	end

	return false
end

function aabb(v1x, v1y, v1width, v1height, v2x, v2y, v2width, v2height)
	local v1farx, v1fary, v2farx, v2fary = v1x + v1width, v1y + v1height, v2x + v2width, v2y + v2height
	return v1farx > v2x and v1x < v2farx and v1fary > v2y and v1y < v2fary
end