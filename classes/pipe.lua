pipe = class("pipe")

function pipe:init(x, y, properties, screen)
    self.x = x
    self.y = y
    
    self.width = 16
    self.height = 16

    self.passive = false

    self.active = true

    self.speedx = 0
    self.speedy = 0

    self.static = true

    self.properties = properties or 16

    self.isSpawn = self.properties.spawn

    if self.isSpawn then
        self.draw = function() end
        self.passive = true
    end

    self.direction = properties.direction
    
    if self.properties.link then
        self.link = self.properties.link:split(";")
    end

    self.screen = screen
end

function pipe:draw()
    pushPop(self, true)

    love.graphics.setScreen(self.screen)
    love.graphics.draw(superMarioTiles, superMarioTileQuads[self.properties.r], self.x, self.y)

    pushPop(self)
end

function pipe:getLink()
    return {self.link[1], tonumber(self.link[2]), tonumber(self.link[3]), self.link[4]}
end