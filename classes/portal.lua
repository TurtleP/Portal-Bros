portal = class("portal")

function portal:init(x, y, rotation, i, screen)
    self.x = x
    self.y = y

    self.width = 32
    self.height = 16

    self.rotation = rotation or 0
    local glowOffsetY = -self.height

    self.facing = "ver"
    local dir, offset = 1, -3

    self.diri = 1
    local glowOffsetX = 0
    if rotation == math.pi then
        dir, offset, glowOffsetY, self.diri = 2, self.height, self.height, 2
    elseif rotation == -math.pi / 2 then
        dir, offset, glowOffsetY = 4, -3, 8 
        self.facing = "hor" 
        glowOffsetX = -24
    elseif rotation == math.pi / 2 then
        self.facing = "hor"
        dir, offset, glowOffsetX, glowOffsetY, self.diri = 3, 14 , 8, 8, 2 
    end

    if self.facing == "hor" then
        self.width = 16
        self.height = 32
    end

    self.dir = dir
    self.offset = offset
    self.glowOffsetY = glowOffsetY
    self.glowOffsetX = glowOffsetX

    self.timer = 0
    self.quadi = 1

    self.i = i

    self.active = true

    self.static = true

    self.speedx = 0
    self.speedy = 0
    
    self.object = nil
    
    self.colors =
    {
        {0, 120, 248},
        {252, 160, 68}
    }

    self.portalObjects =
    {
        "mario",
        "goomba",
        "koopagreen",
        "powerup"
    }

    self.open = true

    self.screen = screen or "top"
    self.particletimer = 0
    self.color = self.colors[self.i]

    if #objects["portal"] < 1 then
        self.open = false
    else
        for k, v in ipairs(objects["portal"]) do
            v.open = true
        end
    end

    self.tiles = checkrectangle(self.x, self.y, self.width, self.height, {"tile", "coinblock", "pipe"})

    for k = 1, #self.tiles do
        if self.tiles[k][2].screen == self.screen then
            if not self.tiles[k][2].passive then
                self.tiles[k][2].passive = true
            end
        end
    end
end

function portal:destroy()
    if self.tiles then
        for k = 1, #self.tiles do
            self.tiles[k][2].passive = false
        end
    end

    for k, v in pairs(objects) do
        for j, w in pairs(v) do
            if w.portalable then
                w.scissor = {}
            end
        end
    end
end

function portal:update(dt)
    if self.open then
        self.timer = self.timer + 10 * dt
        self.quadi = 1 + math.floor(self.timer % 6) + 1

        local check = checkrectangle(self.x, self.y, self.width, self.height + self.offset, self.portalObjects)
        if self.facing == "hor" then
            check = checkrectangle(self.x + self.glowOffsetX + 2, self.y, self.width, self.height, self.portalObjects)
        end

        for i = 1, #check do
            if check[i][2].portaled then
                check[i][2].speedy = math.min(check[i][2].speedy, 12) --check speed
                if self.dir == 1 then --exit upward
                    if check[i][2].y + check[i][2].height / 2 < self.y then
                        check[i][2].scissor = {}
                        --check[i][2].speedy = math.max(check[i][2].speedy, -12) --check speed
                        check[i][2].portaled = false
                    end
                elseif self.dir == 2 then --exit downward
                    if check[i][2].y > self.y + self.height then
                        check[i][2].scissor = {}
                        check[i][2].portaled = false
                    end
                elseif self.dir == 3 then
                    if check[i][2].x > self.x + self.glowOffsetX then
                        check[i][2].scissor = {}
                        check[i][2].portaled = false
                    end
                elseif self.dir == 4 then --exit left
                    if check[i][2].x < self.x then
                        check[i][2].scissor = {}
                        check[i][2].portaled = false
                    end
                end
            end
        end
    end
end

function portal:draw()
    pushPop(self, true)

    love.graphics.setScreen(self.screen)

    local offX, offY = 0, 0
    if self.rotation > 0 then
        offX, offY = self.width, self.height
    end

    if self.open then
        love.graphics.draw(portalGlowImage, self.x + self.glowOffsetX, self.y + self.glowOffsetY, self.rotation)
    end
    
    love.graphics.setColor(unpack(self.color))

    if self.facing == "ver" then
        love.graphics.draw(portalImageVer, portalVerQuads[self.diri][self.quadi], self.x, self.y + self.offset)
    else
        love.graphics.draw(portalImageHor, portalHorQuads[self.diri][self.quadi], self.x + self.offset, self.y)
    end

    love.graphics.setColor(255, 255, 255)

    pushPop(self)
end

function portal:fizzle()
    playSound(portalFizzleSound)
    
    self:destroy()

    self.remove = true
end

function portal:transfer(t, dir)
    if not self.open then
        return
    end

    local other = self:getOther(t)
    if other[3] == 4 then
        other = self:getOtherHor(t)
    end

    if other then
        t.scissor = {(t.x + self.glowOffsetX) - getScrollValue(), self.y + self.glowOffsetY, t.width, t.height}

        self:moveObject(t, other)
    end
end

function portal:moveObject(t, other)
    t.x, t.y = unpack(other)

    if other[3] == 4 then
        t.speedx = -120
        t.speedy = 0
    elseif other[3] == 3 then
        t.speedx = 120
        t.speedy = 0
    end

    playSound(portalEnterSound)
end

function portal:getOther(t)
    for k, v in ipairs(objects["portal"]) do
        if v.i ~= self.i then
            if t then
                local off = (t.x - self.x)
                off = util.clamp(0, off, self.width)

                local add = v.offset
                if self.dir == 2 then
                    add = v.offset - t.height / 2
                end
                return {v.x + off, v.y + add, v.dir}
            else
                print(self.i, v.i)
                return true
            end
        end
    end
end

function portal:getOtherHor(t)
    for k, v in ipairs(objects["portal"]) do
        if v.i ~= self.i then
            if t then
                return {v.x, v.y + v.height / 2 - t.height / 2, v.dir}
            end
        end
    end
end

function portal:getOtherCoords()
    for k, v in ipairs(objects["portal"]) do
        if v.i ~= self.i then
            return {v.x, v.y + v.glowOffsetY, v.dir}
        end
    end
end