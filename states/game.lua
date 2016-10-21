function gameInit(menu)
    --GAME STUFF BELOW--

    tiled:loadMap("maps/smb/" .. marioWorld .. "-" .. marioLevel)

    objects = {}
    objects["tile"] = tiled:getTiles()
    objects["mario"] = tiled:getObjects("mario")

    objects["barrier"] =
    {
        barrier:new(0, 0, 1, 240, "top"),
        barrier:new(tiled:getWidth("top") * 16, 0, 1, 240, "top")
    }
    
    objects["coin"] = tiled:getObjects("coin")
    objects["goomba"] = tiled:getObjects("goomba")
    objects["koopagreen"] = tiled:getObjects("koopagreen") or {}
    objects["coinblock"] = tiled:getObjects("coinblock")
    objects["pipe"] = tiled:getObjects("pipe")
    objects["powerup"] = {}
    objects["portal"] = {}
    objects["portalshot"] = {}

    player = objects["mario"][1]
    
    if not menu then
        tiled:changeSong(player.screen)
    end

    scoreTexts = {}

    marioScore = 0
    coinCount = 0
    coinCounterTimer = 0
    coinCounterQuadi = 1

    leveltime = 400

    gamepad = joystick:new()

    if not love.math then
        love.math = {random = math.random}
    end
end

function fontPrint(text, x, y, color)
    local startx = x
    local color = color or {255, 255, 255}
    for i = 1, #text do
        if text:sub(i, i) == "|"then
            startx = x - i * 9
            y = y + 8
        else
            love.graphics.setColor(0, 0, 0)
            love.graphics.draw(fontImage, fontQuads[text:sub(i, i)], (startx - 1) + (i - 1) * 9, y - 1)
            
            love.graphics.setColor(unpack(color))
            love.graphics.draw(fontImage, fontQuads[text:sub(i, i)], startx + (i - 1) * 9, y)
        end
    end
end

function smallPrint(text, x, y)
    local x = math.floor(x)
    for i = 1, #text do
        love.graphics.setColor(0, 0, 0)
        love.graphics.draw(smallFontImage, smallFontQuads[text:sub(i, i)], (x - 1) + (i - 1) * 5, y - 1)
        
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(smallFontImage, smallFontQuads[text:sub(i, i)], x + (i - 1) * 5, y)
    end
end

function playSound(sound)
    sound:stop()
    sound:play()
end

function addZeros(value, i)
    for j = string.len(value) + 1, i do
        value = "0" .. value
    end 

    return value
end

function addScore(add)
    marioScore = marioScore + add
end

function cameraScroll()
    local MAX_X = 25
    if love.graphics.getScreen() == "bottom" then
        MAX_X = 20
    end

    local currentScreen = player.screen
    local MAP_WIDTH = tiled:getWidth(currentScreen)
    local self = player

    if MAP_WIDTH > MAX_X then
		if scrollValues[currentScreen][1] >= 0 and scrollValues[currentScreen][1] + love.graphics.getWidth() <= MAP_WIDTH * 16 then
			if self.x > scrollValues[currentScreen][1] + love.graphics.getWidth() * 1 / 2 then
				scrollValues[currentScreen][1] = self.x - love.graphics.getWidth() * 1 / 2
			elseif self.x < scrollValues[currentScreen][1] + love.graphics.getWidth() * 1 / 2 then
				scrollValues[currentScreen][1] = self.x - love.graphics.getWidth() * 1 / 2
			end
		end

		if scrollValues[currentScreen][1] < 0 then
			scrollValues[currentScreen][1] = 0
		elseif scrollValues[currentScreen][1] + love.graphics.getWidth() >= MAP_WIDTH * 16 then
			scrollValues[currentScreen][1] = MAP_WIDTH * 16 - love.graphics.getWidth()
		end
	end
end

function getScrollValue()
    return math.floor(scrollValues[player.screen][1])
end

function gameUpdate(dt)
    dt = math.min(0.1666667, dt)

    cameraObjects = checkCamera(getScrollValue(), 0, 400, 248)
    cameraOtherObjects = checkCamera(getScrollValue(), 0, 432, 248)

    for k, v in ipairs(scoreTexts) do
        if v.remove then
            table.remove(scoreTexts, k)
        end

        v:update(dt)
    end

    coinCounterTimer = coinCounterTimer + 3.5 * dt
    coinCounterQuadi = math.floor(coinCounterTimer % 4) + 1

    cameraScroll()

    gamepad:update(dt)

    physicsupdate(dt)

    if player.y > util.getHeight() then
        if not deathSound:isPlaying() then
            util.changeState("levelscreen")
        end
    end
end

function gameDrawHUD()
    fontPrint("mario|" .. addZeros(marioScore, 6), love.graphics.getWidth() * 0.08, 16)

    love.graphics.draw(coinAnimationImage, coinAnimationQuads[coinCounterQuadi], love.graphics.getWidth() * 0.34, 24)
    fontPrint("*" .. addZeros(coinCount, 2), love.graphics.getWidth() * 0.36, 24)

    fontPrint("world| " .. marioWorld .. "-" .. marioLevel, love.graphics.getWidth() * 0.57, 16)

    fontPrint("time|" .. leveltime, love.graphics.getWidth() * 0.8, 16)
end

function gameDraw()
    love.graphics.setScreen(player.screen)
    love.graphics.setColor(unpack(backgroundColors[backgroundColori[player.screen]]))
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    fontPrint(tostring(love.timer.getFPS()), 1, 2)

    love.graphics.push()
            
    love.graphics.translate(-getScrollValue(), 0)

    tiled:renderBackground()
    
    love.graphics.setColor(255, 255, 255)

    for i = 1, #cameraObjects do
        if cameraObjects[i][2].screen == player.screen then
            if cameraObjects[i][2].draw then
                if cameraObjects[i][2].zOrder == 1 then
                    cameraObjects[i][2]:draw()
                else
                    cameraObjects[i][2]:draw()
                end
            end
        end
    end

    for k, v in ipairs(scoreTexts) do
        v:draw()
    end

    love.graphics.pop()

    love.graphics.setScreen(objects["mario"][1].screen)

    gameDrawHUD()

    gamepad:draw()
end

function gameKeyPressed(key)
    if key == "right" then
        objects["mario"][1]:moveRight(true)
    elseif key == "left" then
        objects["mario"][1]:moveLeft(true)
    elseif key == "down" then
        objects["mario"][1]:moveDown(true)
    elseif key == "a" then
        objects["mario"][1]:jump()
    elseif key == "b" then
        objects["mario"][1]:run(true)
    elseif key == "lbutton" then
        objects["mario"][1]:shootPortal(1)
    elseif key == "rbutton" then
        objects["mario"][1]:shootPortal(2)
    end

    if key == "select" then
        for k, v in ipairs(objects["portal"]) do
            v:fizzle()
        end     
    end
end

function gameKeyReleased(key)
    if key == "right" then
        objects["mario"][1]:moveRight(false)
    elseif key == "left" then
        objects["mario"][1]:moveLeft(false)
    elseif key == "down" then
        objects["mario"][1]:moveDown(false)
    elseif key == "a" then
        objects["mario"][1]:stopJump()
    elseif key == "b" then
        objects["mario"][1]:run(false)
    end
end