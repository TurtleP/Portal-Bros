goomba = class("goomba")

function goomba:init(x, y, properties, screen)

    local add = tonumber(properties.offset)
    if not add then
        add = 0
    end

    self.x = x + add
    self.y = y

    self.width = 16
    self.height = 16

    self.category = 6
    self.mask =
    {
        true, true, true, true, true, true,
        true
    }

    self.portalable = true

    self.speedx = -48
    self.speedy = 0

    self.active = true
    self.gravity = 840

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
    love.graphics.setScreen(self.screen)

    if self.scissor then
        love.graphics.setScissor(unpack(self.scissor))
    end

    love.graphics.draw(goombaImage, goombaQuads[1][self.quadi], self.x, self.y)

    if self.scissor then
        love.graphics.setScissor()
    end
end

function goomba:shotted(dir)
    if dir == "right" then
        self.speedx = 80
    else
        self.speedx = -80
    end
    self.speedy = -150
    self.passive = true

    playSound(enemyShotSound)
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

    if name == "koopagreen" then
        return false
    end

    if name == "goomba" then
        return false
    end

    if name == "mario" then
        return false
    end
end

function goomba:downCollide(name, data)
    if name == "portal" then
        return enterPortal(self, "down", data)
    end

    if name == "koopagreen" then
        return false
    end

    if name == "goomba" then
        return false
    end
    
    if name == "mario" then
        data:shrink()
        return false
    end

    if name == "tile" then
        if data.hit then
            self:shotted("right")
            return false
        end
    end
end

function goomba:leftCollide(name, data)
    if name == "tile" or name == "goomba" then
        self.speedx = -self.speedx
        return false
    end

    if name == "mario" then
        data:shrink()
        return false
    end

    if name == "portal" then
        return enterPortal(self, "left", data)
    end

    if name == "koopagreen" then
        if data.slide then
            self:shotted("right")
            return false
        end
    end
end

function goomba:rightCollide(name, data)
    if name == "tile" or name == "goomba" then
        self.speedx = -self.speedx
        return false
    end

    if name == "mario" then
        data:shrink()
        return false
    end

    if name == "portal" then
        return enterPortal(self, "right", data)
    end

    if name == "koopagreen" then
        if data.slide then
            self:shotted("left")
            return false
        end
    end
end