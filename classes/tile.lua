tile = class("tile")

function tile:init(x, y, i, flags, screen)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    self.active = true
    self.static = true

    self.speedx = 0
    self.speedy  = 0

    self.category = 1
    
    self.i = i

    if flags then
        for k, v in pairs(flags) do
            self[k] = v
        end
    end
    
    self.zOrder = 1

    self.screen = screen

    self.hit = false
    self.hitTimer = 0

    if self.breakable then
        self.active = true

        self.update = function(self, dt)
            if self.hit then
                self.hitTimer = self.hitTimer + 32 * dt
                if self.hitTimer > 6 then
                    self.hit = false
                end
            else
                self.hitTimer = math.max(self.hitTimer - 32 * dt, 0)
            end
        end
    end

    self.draw = function(self)
        love.graphics.setScreen(self.screen)

        love.graphics.draw(superMarioTiles, superMarioTileQuads[self.i], self.x, self.y - self.hitTimer)
    end
end

function tile:bounce()
    if self.breakable then
        self.hit = true
    end
end