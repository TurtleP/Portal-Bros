mario = class("mario")

function mario:init(x, y, properties, screen, size, lives)
    self.x = x
    self.y = y + 4

    self.width = 12

    self.active = true

    self.category = 2
    self.mask =
    {
        true, false, true, true,
        true, true, true, true,
        true, true
    }

    self.animations =
    {
        ["idle"] = 1,
        ["walk"] = {2, 3, 4, 3}
    }
    
    self.portalable = true

    self.speedx = 0
    self.speedy = 0

    self.gravity = 840

    self.rightKey = false
    self.leftKey = false
    self.downKey = false
    self.runKey = false
    self.jumping = false

    self.timer = 0
    self.state = "idle"
    self.quadi = 1

    self.screen = "top"

    self.scale = scale

    self.pipeTimer = 0
    self.scissor = {}

    self.walkSpeed = 3
    self.maxWalkSpeed = 120

    self.offsets =
    {
        {
            {-2, -2, 3},
            {-4, -4, 9},
            {-4, -4, 9},
        },
        {
            {-3, 14, 4},
            {-3, 14, 7},
            {-3, 14, 7}
        }
    }

    self.size = size or 1
    self.lives = lives or 3

    self.portalGun = true

    if self.size == 1 then
        self.height = 12
        if not self.portalGun then
            self.graphic = marioImage
            self.quads = marioQuads
        else
            self.graphic = marioGunImage
            self.quads = marioGunQuads
        end
    elseif self.size > 1 then
        if not self.portalGun then
            self.graphic = marioBigImage
        end
        self.quads = marioBigQuads
        self.height = 24
    end

    self.growthAnimation = 
    {
        ["false"] = {image = {marioImage, marioBigImage}, quad = {marioQuads, marioBigQuads}},
        ["true"] = {image = {marioGunImage, marioBigGunImage}, quad = {marioGunQuads, marioBigQuads}}
    }

    self.invincible = false
    self.drawable = true

    self.pointingAngle = 0

    self.shotTimer = 0

    self.growTimer = 0
end

function mario:update(dt)
    if self.dead or self.growing or self.invincible then
        if self.growing then
            if not self.invincible then
                self.growTimer = self.growTimer + 12 * dt

                self.graphic = self.growthAnimation[tostring(self.portalGun)].image[math.floor(self.growTimer % 2) + 1]
                self.quads = self.growthAnimation[tostring(self.portalGun)].quad[math.floor(self.growTimer % 2) + 1]

                if self.growTimer > 13 then
                    self.growing = false
                    self.static = false
                    self.growTimer = 0
                end

                self.height = 24
            else
                self.growTimer = self.growTimer - 12 * dt
                self.graphic = self.growthAnimation[tostring(self.portalGun)].image[math.floor(self.growTimer % 2) + 1]
                self.quads = self.growthAnimation[tostring(self.portalGun)].quad[math.floor(self.growTimer % 2) + 1]

                if self.growTimer < -13 then
                    self.growing = false
                    self.invincible = false
                    self.static = false
                    self.growTimer = 0
                    self.y = self.y + 12
                end

                self.height = 12
            end
        end
        return
    end

    if self.rightKey then
        self.speedx = math.min(self.speedx + self.walkSpeed, self.maxWalkSpeed)
    elseif self.leftKey then
        self.speedx = math.max(self.speedx - self.walkSpeed, -self.maxWalkSpeed)
    elseif not self.rightKey and not self.leftKey and not self.pipe then
        if self.speedx > 0 then
            self.speedx = math.max(self.speedx - 4, 0)
        elseif self.speedx < 0 then
            self.speedx = math.min(self.speedx + 4, 0)
        end
    end

    if self.speedx ~= 0 and not self.jumping then
        if self.leftKey then
            if self.speedx > 0 then
                self.quadi = 5
                self.skidding = true
                self.speedx = math.max(self.speedx - 3, 0)
                return
            else
                self.skidding = false
            end
        elseif self.rightKey then
            if self.speedx < 0 then
                self.quadi = 5
                self.skidding = true
                self.speedx = math.min(self.speedx + 3, 0)
                return
            else
                self.skidding = false
            end
        end

        if self.speedx > 0 then
            self.scale = scale
        elseif self.speedx < 0 then
            self.scale = -scale
        end

        self.timer = self.timer + math.abs(self.speedx) * 0.1 * dt 
        self.quadi = self.animations["walk"][math.floor(self.timer % #self.animations["walk"]) + 1]
    elseif self.speedx == 0 and not self.jumping then
        self.quadi = 1
        self.timer = 0
    elseif self.jumping then
        self.quadi = 6
    end

    if self.shotTimer > 0 then
        self.shotTimer = self.shotTimer - dt
    end

    if gamepad:getX() ~= 0 or gamepad:getY() ~= 0 then
        self:setPointingAngle()
    else
        self:setPointingAngle(0)
    end

    --[[if self.downKey then
        if self.size > 1 then
            self.timer = 0
            self.quadi = 12
        end
    end]]

    if self.pipe then
        self:doPipe(dt)

        if self.pipeDirection ~= "up" and self.pipe then
            if not shrinkSound:isPlaying() then
                self:transferPipe(unpack(self.pipe:getLink()))
            end
        end
    end

    if self.y > love.graphics.getHeight() then
        self:die(true)
    end
end

function mario:shootPortal(i)
    if self.shotTimer > 0 then
        return
    end

    local add = self.width
    if self.scale == -1 then
        add = 0
    end
    lastPortali = i
    table.insert(objects["portalshot"], portalshot:new(self.x + add, self.y + self.height / 2, i, self.pointingAngle, self.screen))

    self.shotTimer = 0.75
end

function mario:doPipe(dt)
    if self.active then
        if self.pipeDirection == "down" then
            self.speedx = 0
            if self.y < self.pipe.y + 3 then
                self.y = self.y + 32 * dt
            else
                self.scale = scale
            end
        elseif self.pipeDirection == "right" then
            if self.x < self.pipe.x then
                self.x = self.x + 32 * dt
            else
                self.scale = scale
            end
        elseif self.pipeDirection == "up" then
            self.speedx = 0
            if self.y > self.pipe:getLink()[3] - self.height then
                self.y = self.y - 32 * dt
            else
                self.static = false
                self.scissor = nil
                self.pipeDirection = ""
                self.pipe = nil
            end
        end
    end
end

function mario:transferPipe(screen, x, y, isSpawn)
    self.screen = screen

    tiled:changeSong(screen)

    self.x = x
    self.y = y

    if util.toBoolean(isSpawn) then
        self.scissor = nil
        self.pipe = nil
        self.passive = false
        self.static = false
    else
        self.pipeDirection = "up"
        self.scissor = {x - getScrollValue(), y - self.height, 20, 16}
    end
end

function mario:setPipe(pipe, direction)
    if not self.passive then
        self.pipe = pipe

        self.static = true
        
        self.scissor = {self.x - getScrollValue(), self.y, 20, self.height}

        self.pipeDirection = direction
        playSound(shrinkSound)
    end
end

function mario:moveRight(move)
    self.rightKey = move
end

function mario:moveLeft(move)
    self.leftKey = move
end

function mario:moveDown(move)
    self.downKey = move
end

function mario:angleUp(move)
    self.angleUpKey = move
end

function mario:angleDown(move)
    self.angleDownKey = move
end

function mario:run(move)
    self.runKey = move

    if move then
        self.walkSpeed = 3.5
        self.maxWalkSpeed = 160
    else
        self.walkSpeed = 3
        self.maxWalkSpeed = 120
    end
end

function mario:jump()
    if self.speedy == 0 then
        self.speedy = -jumpForce - (math.abs(self.speedx) / self.maxWalkSpeed) * jumpForceAdd

        if self.size == 1 then
            playSound(jumpSound)
        else
            playSound(jumpBigSound)
        end

        self.jumping = true
    end
end

function mario:stopJump()
    if self.speedy < 0 then
        self.speedy = self.speedy * 0.05
    end
end

function mario:draw()
    love.graphics.setScreen(self.screen)
    
    if not self.drawable then
        return
    end

    if self.scissor and #self.scissor > 0 then
        love.graphics.setScissor(self.scissor[1], self.scissor[2], self.scissor[3], self.scissor[4])
    end

    local size = math.max(1, math.min(self.size, 3))
    local scale = 1
    if self.scale == -1 then
        scale = 2
    end

    if not self.portalGun then
        love.graphics.draw(self.graphic, self.quads[scale][self.quadi], self.x + self.offsets[1][size][scale], self.y - self.offsets[1][size][3], 0)
    else
        love.graphics.draw(self.graphic, self.quads[self:getPointingQuad()][self.quadi], self.x + self.offsets[2][size][scale], self.y - self.offsets[2][size][3], 0, self.scale, 1)
    end
    
    if self.scissor then
        love.graphics.setScissor()
    end

    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", self.x + self.width / 2 + math.cos(self.pointingAngle) * 30, self.y + self.height / 2 + math.sin(self.pointingAngle) * 30, 2, 2)
    love.graphics.setColor(255, 255, 255)
end

function mario:getPointingQuad()
    local ret = 3 --aim middle

    local angle = self.pointingAngle
    
    if angle > -math.pi and angle < -math.pi / 13 then
        ret = 2
    elseif angle > 4.5 and angle < 4.7 then
        ret = 1
    elseif angle > math.pi / 13 and angle < 2.1 then
        ret = 4
    end

    return ret
end

function mario:setPointingAngle(setValue)
    local angle = math.atan2(gamepad:getX(), gamepad:getY()) - math.pi / 2
    if setValue then
        angle = setValue
    end
    --[[if angle < 0 then
        angle = 0
    end]]

    self.pointingAngle = -angle
end

function mario:upCollide(name, data)
    if name == "tile" then
        playSound(blockSound)
    end

    if name == "portal" then
        return enterPortal(self, "up", data)
    end

    if name == "tile" or name == "coinblock" then
        if name == "tile" then
            if self.size > 1 then
                return
            end
        end
        
        if data.bounce then
            data:bounce()
        end
    end

    if name == "powerup" then
        data:collect(self)
        return false
    end

    if name == "goomba" then
        self:shrink()
        return false
    end

    if name == "koopagreen" then
        self:shrink()
        return false
    end
end

function mario:downCollide(name, data)
    self.jumping = false

    if name == "pipe" then
        if self.downKey and data.direction == "down" then
            self:setPipe(data, "down")
        end
    end

    if name == "portal" then
        return enterPortal(self, "down", data)
    end

    if name == "powerup" then
        data:collect(self)
        return false
    end

    if name == "goomba" then
        if not self.jumping then
            self.speedy = -180
            data:stomp()
            self.jumping = true
            return false
        end
    end

    if name == "koopagreen" then
        if not self.jumping then
            if not data.stomped then
                data:stomp()
                self.speedy = -180
                self.jumping = true
            else
                if self.x + self.width / 2 < data.x + data.width / 2 then
                    data:kick("right")
                else
                    data:kick("left")
                end
                self.speedy = -180
                self.jumping = true
            end
            return false
        end
    end

    if name == "coinblock" then
        if data.visible == false then
            return false
        end
    end
end

function mario:passiveCollide(name, data)
    if name == "coin" then
        data:collect()
    end
end

function mario:leftCollide(name, data)
    if name == "portal" then
        return enterPortal(self, "left", data)
    end

    if name == "goomba" then
        self:shrink()
        return false
    end

    if name == "koopagreen" then
        if data.stomped then
            if data.slide then
                self:shrink()
            else
                data:kick("left")
            end
        else
            self:shrink()
        end
        return false
    end

    if name == "powerup" then
        data:collect(self)
        return false
    end

    if name == "coinblock" then
        if data.visible == false then
            return false
        end
    end
end

function mario:rightCollide(name, data)
    if name == "portal" then
        return enterPortal(self, "right", data)
    end
    
    if name == "goomba" then
        self:shrink()
        return false
    end

    if name == "koopagreen" then
        if data.stomped then
            if data.slide and data.speedx < 0 then
                self:shrink()
            else
                data:kick("right")
            end
        else
            self:shrink()
        end
        return false
    end

    if name == "powerup" then
        data:collect(self)
        return false
    end

    if name == "pipe" then
        if self.rightKey and data.direction == "right" then
            self:setPipe(data, "right")
        end
    end

    if name == "coinblock" then
        if data.visible == false then
            return false
        end
    end
end

function mario:shrink()
    if self.invincible then
        return
    else
        if self.size == 1 then
            self:die()
            return
        end
    end

    self.growing = true
    self.invincible = true
    self.static = true
    
    self.size = math.max(self.size - 1, 0)
end

function mario:grow()
    if self.growing then
        return
    end

    self.size = math.min(self.size + 1, 3)

    if self.size == 2 then
        return
    end

    self.growing = true
    self.static = true

    self.y = self.y - 12
end

function mario:die(isPit)
    self.quadi = 7

    if not isPit then
        self.speedy = -300
    end
    
    self.speedx = 0

    self.dead = true
    self.passive = true

    love.audio.stop()
    playSound(deathSound)
end

function mario:addLife(add)
    self.lives = math.max(0, self.lives + add)
end