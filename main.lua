util = require 'libraries.util'
tiled = require 'libraries.tiled'
class = require 'libraries.middleclass'
require 'libraries.physics'
require 'classes.joystick'

require 'libraries.spritebatch'

require 'classes.tile'
require 'classes.mario'
require 'classes.coinblock'
require 'classes.coinanimation'
require 'classes.pipe'
require 'classes.coin'
require 'classes.mushroom'
require 'classes.oneup'
require 'classes.goomba'
require 'classes.koopagreen'


require 'classes.portal'
require 'classes.portalshot'

require 'classes.scoretext'
require 'classes.barrier'

io.stdout:setvbuf("no")
function love.load()
    backgroundColors =
    {
        {92, 148, 252}, --sky
        {0, 0, 0}, --underground/night
        {32, 56, 236} --ocean
    }
    backgroundColori = {["top"] = 1, ["bottom"] = 1}

    superMarioTiles = love.graphics.newImage("graphics/game/smbtiles.png")
    superMarioTileQuads = {}
    for y = 1, superMarioTiles:getHeight() / 17 do
        for x = 1, superMarioTiles:getWidth() / 17 do
            table.insert(superMarioTileQuads, love.graphics.newQuad((x - 1) * 17, (y - 1) * 17, 16, 16, superMarioTiles:getWidth(), superMarioTiles:getHeight()))
        end
    end

    marioImage = love.graphics.newImage("graphics/player/nogunanimationsNEW.png")
    marioQuads = {}
    for y = 1, 2 do
        marioQuads[y] = {}
        for x = 1, 11 do
            marioQuads[y][x] = love.graphics.newQuad((x - 1) * 16, (y - 1) * 16, 16, 16, marioImage:getWidth(), marioImage:getHeight())
        end
    end

    marioGunImage = love.graphics.newImage("graphics/player/animations.png")
    marioGunQuads = {}
    for y = 1, 8 do
        marioGunQuads[y] = {}
        for x = 1, 11 do
            marioGunQuads[y][x] = love.graphics.newQuad((x - 1) * 17, (y - 1) * 17, 17, 17, marioGunImage:getWidth(), marioGunImage:getHeight())
        end
    end

    marioBigImage = love.graphics.newImage("graphics/player/nogunbiganimations.png")
    marioBigQuads = {}
    for y = 1, 4 do
        marioBigQuads[y] = {}
        for x = 1, 12 do
            marioBigQuads[y][x] = love.graphics.newQuad((x - 1) * 20, (y - 1) * 32, 20, 32, marioBigImage:getWidth(), marioBigImage:getHeight())
        end
    end

    coinAnimationImage = love.graphics.newImage("graphics/game/coinanimation.png")
    coinAnimationQuads = {}
    for x = 1, 4 do
        coinAnimationQuads[x] = love.graphics.newQuad((x - 1) * 5, 0, 5, 8, coinAnimationImage:getWidth(), coinAnimationImage:getHeight())
    end

    fontImage = love.graphics.newImage("graphics/game/font.png")
    fontGlyphs = "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_>* !{}?"
    fontQuads = {}
    for i = 1, #fontGlyphs do
        fontQuads[fontGlyphs:sub(i, i)] = love.graphics.newQuad((i - 1) * 8, 0, 8, 8, fontImage:getWidth(), fontImage:getHeight())
    end

    smallFontImage = love.graphics.newImage("graphics/game/smallfont.png")
    smallGlyphs = "012458up"
    smallFontQuads = {}
    for x = 1, #smallGlyphs do
        smallFontQuads[smallGlyphs:sub(x, x)] = love.graphics.newQuad((x - 1) * 4, 0, 4, 8, smallFontImage:getWidth(), smallFontImage:getHeight())
    end

    coinBlockImage = love.graphics.newImage("graphics/game/coinblock.png")
    coinBlockQuads = {}
    for y = 1, 4 do
        coinBlockQuads[y] = {}
        for x = 1, 5 do
            coinBlockQuads[y][x] = love.graphics.newQuad((x - 1) * 16, (y - 1) * 16, 16, 16, coinBlockImage:getWidth(), coinBlockImage:getHeight())
        end
    end

    coinBlockCoinAnimationImage = love.graphics.newImage("graphics/game/coinblockanimation.png")
    coinBlockCoinAnimationQuads = {}
    for x = 1, coinBlockCoinAnimationImage:getWidth() / 8 do
        coinBlockCoinAnimationQuads[x] = love.graphics.newQuad((x - 1) * 8, 0, 8, 64, coinBlockCoinAnimationImage:getWidth(), coinBlockCoinAnimationImage:getHeight())
    end

    goombaImage = love.graphics.newImage("graphics/objects/goomba.png")
    goombaQuads = {}
    for y = 1, 4 do
        goombaQuads[y] = {}
        for x = 1, 3 do
            goombaQuads[y][x] = love.graphics.newQuad((x - 1) * 16, (y - 1) * 16, 16, 16, goombaImage:getWidth(), goombaImage:getHeight())
        end
    end

    koopagreenImage = love.graphics.newImage("graphics/objects/koopagreen.png")
    koopagreenQuads = {}
    for y = 1, 4 do
        koopagreenQuads[y] = {}
        for x = 1, 3 do
            koopagreenQuads[y][x] = love.graphics.newQuad((x - 1) * 16, (y - 1) * 24, 16, 24, koopagreenImage:getWidth(), koopagreenImage:getHeight())
        end
    end

    coinImage = love.graphics.newImage("graphics/objects/coin.png")
    coinQuads = {}
    for y = 1, 4 do
        coinQuads[y] = {}
        for x = 1, 4 do
            coinQuads[y][x] = love.graphics.newQuad((x - 1) * 16, (y - 1) * 16, 18, 18, coinImage:getWidth(), coinImage:getHeight())
        end
    end

    powerupImage = love.graphics.newImage("graphics/objects/powerups.png")
    powerupQuads = {}
    for x = 1, 3 do
        powerupQuads[x] = love.graphics.newQuad((x - 1) * 16, 0, 16, 16, powerupImage:getWidth(), powerupImage:getHeight())
    end

    portalImageVer = love.graphics.newImage("graphics/objects/portalver.png")
    portalVerQuads = {}
    for x = 1, 2 do
        portalVerQuads[x] = {}
        for y = 1, 7 do
            portalVerQuads[x][y] = love.graphics.newQuad((x - 1) * 34, (y - 1) * 4, 32, 4, portalImageVer:getWidth(), portalImageVer:getHeight())
        end
    end

    portalImageHor = love.graphics.newImage("graphics/objects/portalhor.png")
    portalHorQuads = {}
    for y = 1, 2 do
        portalHorQuads[y] = {}
        for x = 1, 7 do
            portalHorQuads[y][x] = love.graphics.newQuad((x - 1) * 4, (y - 1) * 34, 4, 32, portalImageHor:getWidth(), portalImageHor:getHeight())
        end
    end

    portalGlowImage = love.graphics.newImage("graphics/objects/portalglow.png")

    overworldSong = love.audio.newSource("audio/overworld.ogg", "stream")
    overworldSong:setLooping(true)

    undergroundSong = love.audio.newSource("audio/underground.ogg", "stream")
    undergroundSong:setLooping(true)

    overworldSong:play()

    blockSound = love.audio.newSource("audio/blockhit.ogg")
    jumpSound = love.audio.newSource("audio/jump.ogg")
    jumpBigSound = love.audio.newSource("audio/jumpbig.ogg")
    coinSound = love.audio.newSource("audio/coin.ogg")
    stompSound = love.audio.newSource("audio/stomp.ogg")
    deathSound = love.audio.newSource("audio/death.ogg")
    shrinkSound = love.audio.newSource("audio/shrink.ogg")
    growSound = love.audio.newSource("audio/mushroomeat.ogg")
    powerupSound = love.audio.newSource("audio/mushroomappear.ogg")
    oneupSound = love.audio.newSource("audio/oneup.ogg")

    portalShotSound = {love.audio.newSource("audio/portal1open.ogg"), love.audio.newSource("audio/portal2open.ogg")}
    portalEnterSound = love.audio.newSource("audio/portalenter.ogg")
    portalFizzleSound = love.audio.newSource("audio/portalfizzle.ogg")

    scrollValues =
    {
        ["top"] = {0, 0},
        ["bottom"] = {0, 0}
    }
	scale = 1

    --GAME STUFF BELOW--
    myBatch = {["top"] = newSpriteBatch(superMarioTiles, superMarioTileQuads, "top"), ["bottom"] = newSpriteBatch(superMarioTiles, superMarioTileQuads, "bottom")}

    tiled:loadMap("maps/smb/1-1_fix")

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
    objects["koopagreen"] = tiled:getObjects("koopagreen")
    objects["coinblock"] = tiled:getObjects("coinblock")
    objects["pipe"] = tiled:getObjects("pipe")
    objects["powerup"] = {}
    objects["portal"] = {}
    objects["portalshot"] = {}

    player = objects["mario"][1]

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

    --love.audio.setVolume(0)
end

function fontPrint(text, x, y)
    local startx = x
    for i = 1, #text do
        if text:sub(i, i) == "|"then
            startx = x - i * 9
            y = y + 8
        else
            love.graphics.setColor(0, 0, 0)
            love.graphics.draw(fontImage, fontQuads[text:sub(i, i)], (startx - 1) + (i - 1) * 9, y - 1)
            
            love.graphics.setColor(255, 255, 255)
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

function pushPop(self, start)
    local crurentScreen, otherScreen = "top", "top"
    if player then
        if player.screen == "top" then
            otherScreen = "bottom"
        end
    end

    if start then
        if self.screen == player.screen then
            love.graphics.push()

            love.graphics.translate(-getScrollValue(), 0)
        else
            love.graphics.push()

            love.graphics.translate(-math.floor(scrollValues[otherScreen][1]), 0)
        end
    else
        love.graphics.pop()
    end
end

function getScrollValue()
    return math.floor(scrollValues[player.screen][1])
end

function inCamera(self)
    return (self.screen == player.screen) and ( (self.x + self.width) - getScrollValue() > 0 and self.x - getScrollValue() < 400)
end

function checkForRemovals()
    for x = #objects["goomba"], 1, -1 do
        if objects["goomba"][x].remove then
            table.remove(objects["goomba"], x)
        end
    end

    for x = #objects["koopagreen"], 1, -1 do
        if objects["koopagreen"][x].remove then
            table.remove(objects["koopagreen"], x)
        end
    end

    for x = #objects["coin"], 1, -1 do
        if objects["coin"][x].remove then
            table.remove(objects["coin"], x)
        end
    end

    for x = #objects["portalshot"], 1, -1 do
        if objects["portalshot"][x].remove then
            table.remove(objects["portalshot"], x)
        end
    end

    for x = #objects["portal"], 1, -1 do
        if objects["portal"][x].remove then
            table.remove(objects["portal"], x)
        end
    end

    for x = #objects["tile"], 1, -1 do
        if objects["tile"][x].remove then
            table.remove(objects["tile"], x)
        end
    end
end

function love.update(dt)
    dt = math.min(1/60, dt)

    cameraObjects = checkrectangle(getScrollValue(), 0, 400, 240, {"exclude", player}, nil, true)

    checkForRemovals()

    for i = 1, #cameraObjects do
        if cameraObjects[i][2].screen == player.screen then
            if cameraObjects[i][2].update then
                cameraObjects[i][2]:update(dt)
            end
        end
    end

    player:update(dt)

    for k, v in ipairs(scoreTexts) do
        if v.remove then
            table.remove(scoreTexts, k)
        end

        v:update(dt)
    end

    coinCounterTimer = coinCounterTimer + 2.5 * dt
    coinCounterQuadi = math.floor(coinCounterTimer % 4) + 1

    cameraScroll()

    gamepad:update(dt)

    physicsupdate(dt)
end

function love.draw()
    tiled:render()
    
    love.graphics.setColor(255, 255, 255)
    
    love.graphics.setScreen("top")
    fontPrint(tostring(love.timer.getFPS()), 1, 2)

    local player
    if objects["mario"][1] then
        player = objects["mario"][1]
    end
    
    player:draw()

    for i = 1, #cameraObjects do
        if cameraObjects[i][2].screen == player.screen then
            if cameraObjects[i][2].draw then
                cameraObjects[i][2]:draw()
            end
        end
    end

    for k, v in ipairs(scoreTexts) do
        v:draw()
    end

    love.graphics.setScreen(objects["mario"][1].screen)
    love.graphics.setColor(255, 255, 255)
    fontPrint("mario|" .. addZeros(marioScore, 6), love.graphics.getWidth() * 0.08, 16)

    love.graphics.draw(coinAnimationImage, coinAnimationQuads[coinCounterQuadi], love.graphics.getWidth() * 0.34, 24)
    fontPrint("*" .. addZeros(coinCount, 2), love.graphics.getWidth() * 0.36, 24)

    fontPrint("world| 1-1", love.graphics.getWidth() * 0.57, 16)

    fontPrint("time|inf", love.graphics.getWidth() * 0.8, 16)

    if printKey then
        fontPrint("pressed: " .. printKey, 0, 48)
    end
end

function love.keypressed(key)
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

function love.keyreleased(key)
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

if love.system.getOS() ~= "3ds" then
	require 'libraries.3ds'
end
