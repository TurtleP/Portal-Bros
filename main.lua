util = require 'libraries.util'
tiled = require 'libraries.tiled'
class = require 'libraries.middleclass'
require 'libraries.physics'
require 'classes.joystick'

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

require 'states.menu'
require 'states.game'
require 'states.levelscreen'

require 'variables'

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
    for y = 1, 4 do
        marioQuads[y] = {}
        for x = 1, 11 do
            marioQuads[y][x] = love.graphics.newQuad((x - 1) * 16, (y - 1) * 16, 16, 16, marioImage:getWidth(), marioImage:getHeight())
        end
    end

    marioGunImage = love.graphics.newImage("graphics/player/animations.png")
    marioGunQuads = {}
    for y = 1, 4 do
        marioGunQuads[y] = {}
        for x = 1, 11 do
            marioGunQuads[y][x] = love.graphics.newQuad((x - 1) * 17, (y - 1) * 17, 17, 17, marioGunImage:getWidth(), marioGunImage:getHeight())
        end
    end

    marioBigImage = love.graphics.newImage("graphics/player/nogunbiganimations.png")
    marioBigGunImage = love.graphics.newImage("graphics/player/biganimations.png")
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

    titleImage = love.graphics.newImage("graphics/menu/title.png")
    menuSelectImage = love.graphics.newImage("graphics/menu/menuselect.png")

    portalGlowImage = love.graphics.newImage("graphics/objects/portalglow.png")

    overworldSong = love.audio.newSource("audio/overworld.ogg", "stream")
    overworldSong:setLooping(true)

    undergroundSong = love.audio.newSource("audio/underground.ogg", "stream")
    undergroundSong:setLooping(true)

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
    enemyShotSound = love.audio.newSource("audio/shot.ogg")
    
    portalShotSound = {love.audio.newSource("audio/portal1open.ogg"), love.audio.newSource("audio/portal2open.ogg")}
    portalEnterSound = love.audio.newSource("audio/portalenter.ogg")
    portalFizzleSound = love.audio.newSource("audio/portalfizzle.ogg")

    scrollValues =
    {
        ["top"] = {0, 0},
        ["bottom"] = {0, 0}
    }

    controls =
    {
        ["run"] = "b",
        ["jump"] = "a",
        ["up"] = "up",
        ["down"] = "down",
        ["left"] = "left",
        ["right"] = "right",
        ["portal 1"] = "lbutton",
        ["portal 2"] = "rbutton"
    }
	scale = 1

    marioWorld = 1
    marioLevel = 1
    
    --GAME STUFF BELOW--
    gamepad = joystick:new()

    if not love.math then
        love.math = {random = math.random}
    end

    util.changeState("menu")
end

function love.update(dt)
    dt = math.min(0.1666667, dt)

    util.updateState(dt)
end

function love.draw()
    util.renderState()
end

function love.keypressed(key)
    util.keyPressedState(key)
end

function love.keyreleased(key)
    util.keyReleasedState(key)
end

function love.mousepressed(x, y, button)
    if button == "l" then
        gamepad:setPosition(x, y)
    end
end

function love.mousereleased(x, y, button)
    if button == "l" then
        gamepad:release()
    end
end

if love.system.getOS() ~= "3ds" then
	require 'libraries.3ds'
end
