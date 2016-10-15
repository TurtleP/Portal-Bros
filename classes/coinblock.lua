coinblock = class("coinblock")

function coinblock:init(x, y, properties, screen)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    self.timer = 0
    self.quadi = 1

    self.active = true
    self.static = true
    self.screen = screen
    
    local visible = true
    if properties.visible == false then
        visible = false
    end
    self.visible = visible

    local item = properties.item
    if not item then
        item = "coinanimation"
    end
    self.item = item
    
    self.speedx = 0
    self.speedy = 0

    self.hit = false
    self.hitTimer = 0

    self.coinTimeout = false
    self.coinTimer = 5
    self.coinsGiven = 0
end

function coinblock:update(dt)
    if self.item then
        self.timer = self.timer + 4 * dt
        self.quadi = math.floor(self.timer % 4) + 1
    end

    if self.coinTimeout then
        if self.coinTimer > 0 then
            self.coinTimer = self.coinTimer - dt
        else
            if self.coinsGiven ~= 1 then
                self.item = nil
                self.quadi = 5
                self.coinTimeout = false 
            end
        end
    end

    if self.hit then
        self.hitTimer = self.hitTimer + 32 * dt
        if self.hitTimer > 6 then
            self.hit = false
        end
    else
        self.hitTimer = math.max(self.hitTimer - 32 * dt, 0)
    end
end

function coinblock:draw()
    pushPop(self, true)

    if not self.visible then
        pushPop(self)
        return
    end
    love.graphics.setScreen(self.screen)    
    love.graphics.draw(coinBlockImage, coinBlockQuads[1][self.quadi], self.x, self.y - self.hitTimer)

    pushPop(self)
end

function coinblock:bounce()
    if self.item then
        if self.item == "coinanimation" then
            self.coinsGiven = self.coinsGiven + 1
            table.insert(objects["coin"], coinanimation:new(self.x + (self.width / 2) - 4, self.y - 48, self.screen))
        else
            table.insert(objects["powerup"], _G[self.item]:new(self.x, self.y, self.screen))
            playSound(powerupSound)
            self.item = nil
            self.quadi = 5
        end
    else
        return
    end

    if not self.coinTimeout then
        self.coinTimeout = true
    end

    if not self.visible then
        self.visible = true
        return
    end

    self.hit = true
end