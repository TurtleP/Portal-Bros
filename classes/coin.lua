coin = class("coin")

function coin:init(x, y, properties, screen)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    self.timer = 0
    self.quadi = 1

    self.active = true
    self.static = true

    self.passive = true

    self.screen = screen
end

function coin:update(dt)
    self.timer = self.timer + 4 * dt
    self.quadi = math.floor(self.timer % 4) + 1
end

function coin:draw()
    pushPop(self, true)

    love.graphics.setScreen(self.screen)

    love.graphics.draw(coinImage, coinQuads[1][self.quadi], self.x, self.y)

    pushPop(self)
end

function coin:collect()
    playSound(coinSound)
    self.remove = true
    addScore(100)
end