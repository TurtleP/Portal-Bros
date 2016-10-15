goomba = class("goomba")

function goomba:init(x, y, properties, screen)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    self.mask =
    {
        "portal",
        "tile"
    }

    self.portalable = true

    self.speedx = -48
    self.speedy = 0

    self.active = true
    self.gravity = 8

    self.dead = false
    
    self.quadi = 1
    self.timer = 0

    self.screen = screen or "top"
end

function goomba:update(dt)
    if self.dead then
        self.quadi = 3
        self.active = false
        self.remove = true
        return
    end

    self.timer = self.timer + 3.5 * dt
    self.quadi = math.floor(self.timer % 2) + 1
end

function goomba:draw()
    pushPop(self, true)

    love.graphics.setScreen(self.screen)

    if self.scissor then
        love.graphics.setScissor(unpack(self.scissor))
    end

    love.graphics.draw(goombaImage, goombaQuads[1][self.quadi], self.x, self.y)

    if self.scissor then
        love.graphics.setScissor()
    end

    pushPop(self)
end

function goomba:stomp()
    self.dead = true
    playSound(stompSound)
    table.insert(scoreTexts, scoretext:new("100", self.x, self.y - 4, self.screen))
end

function goomba:upCollide(name, data)
    if name == "portal" then
        return enterPortal(self, "up", data)
    end
end

function goomba:downCollide(name, data)
    if name == "portal" then
        return enterPortal(self, "down", data)
    end
end

function goomba:leftCollide(name, data)
    if name == "tile" then
        self.speedx = -self.speedx
        return true
    end

    if name == "portal" then
        return enterPortal(self, "left", data)
    end
end

function goomba:rightCollide(name, data)
    if name == "tile" then
        self.speedx = -self.speedx
        return true
    end

    if name == "portal" then
        return enterPortal(self, "right", data)
    end
end