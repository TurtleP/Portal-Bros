coinanimation = class("coinanimation")

function coinanimation:init(x, y, screen)
    self.x = x
    self.y = y

    self.active = true
    self.static = true

    self.timer = 0
    self.quadi = 1

    self.width = 8
    self.height = 8

    self.speedx = 0
    self.speedy = 0
    
    self.endAnimation = false
    self.lifeTime = 0

    playSound(coinSound)

    self.screen = screen
end

function coinanimation:update(dt)
    if self.endAnimation then
        self.lifeTime = self.lifeTime + dt
        if self.lifeTime > 0.5 then
            self.remove = true
        end
        return
    end

    self.timer = self.timer + 42 * dt
    self.quadi = math.floor(self.timer % #coinBlockCoinAnimationQuads) + 1
    if self.quadi == #coinBlockCoinAnimationQuads then
        coinCount = coinCount + 1
        self.endAnimation = true
        table.insert(scoreTexts, scoretext:new("100", self.x - 4, self.y + 36, self.screen))
    end
end

function coinanimation:draw()
    pushPop(self, true)

    love.graphics.setScreen(self.screen)

    if self.endAnimation then
        pushPop(self)
        return
    end

    love.graphics.draw(coinBlockCoinAnimationImage, coinBlockCoinAnimationQuads[self.quadi], self.x, self.y)

    pushPop(self)
end