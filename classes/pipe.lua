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
    self.r = tonumber(self.properties.r)

    self.category = 5
    
    if self.isSpawn then
        self.passive = true
    else
        self.draw = function(self)
            love.graphics.setScreen(self.screen)
            love.graphics.draw(superMarioTiles, superMarioTileQuads[self.r], self.x, self.y)
        end
    end

    self.direction = properties.direction
    
    if self.properties.link then
        self.link = self.properties.link:split(";")
    end

    self.zOrder = 1
    self.screen = screen
end

function pipe:getLink()
    return {self.link[1], tonumber(self.link[2]), tonumber(self.link[3]), self.link[4]}
end