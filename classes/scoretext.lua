scoretext = class("scoretext")

function scoretext:init(score, x, y, screen)
    self.x = math.floor(x)
    self.y = math.floor(y)

    self.text = score

    self.lifeTime = 1

    if tonumber(score) then
        addScore(tonumber(score))
    end

    self.screen = screen
end

function scoretext:update(dt)
    if self.lifeTime > 0 then
        self.lifeTime = self.lifeTime - dt
    else
        self.remove = true
    end
end

function scoretext:draw()
    pushPop(self, true)

    smallPrint(self.text, self.x, self.y)

    pushPop(self)
end