portalshot = class("portalshot")

function portalshot:init(x, y, i, angle, screen)
    self.x = x
    self.y = y

    self.width = 2
    self.height = 2

    self.i = i

    self.angle = angle

    self.speedx = math.cos(angle) * 240
    self.speedy = math.sin(angle) * 360

    playSound(portalShotSound[i])

    self.active = true
    self.passive = false

    self.mask =
    {
        true, false, true, 
        true, true
    }

    self.gravity = 0
    self.screen = screen

    self.colors =
    {
        {0, 120, 248},
        {252, 160, 68}
    }

    self.color = self.colors[self.i]
end

function portalshot:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.circle("fill", self.x, self.y, self.width)
    love.graphics.setColor(255, 255, 255)
end

function portalshot:downCollide(name, data)
    if name == "portal" then
        self.remove = true
        return
    end

    if name == "tile" or name == "coinblock" or name == "pipe" then
        self:createPortal(data.x, data.y, 32, 16, 0)
    end
end

function portalshot:upCollide(name, data)
    if name == "portal" then
        self.remove = true
        return
    end

    if name == "tile" or name == "coinblock" or name == "pipe" then
        self:createPortal(data.x, data.y, 32, 16, math.pi)
    end
end

function portalshot:rightCollide(name, data)
    if name == "portal" then
        self.remove = true
        return
    end

    if name == "tile" or name == "coinblock" or name == "pipe" then
        self:createPortal(data.x, data.y, 16, 32, -math.pi / 2)
    end
end

function portalshot:leftCollide(name, data)
    if name == "portal" then
        self.remove = true
        return
    end
    
    if name == "tile" or name == "coinblock" or name == "pipe" then
        self:createPortal(data.x, data.y, 16, 32, math.pi / 2)
    end
end

function portalshot:createPortal(x, y, width, height, rotation)
    local tiles = checkrectangle(x, y, width, height, {"tile", "coinblock", "pipe"})

    

    print(x, y, width, height, rotation, #tiles)

    if #tiles < 2 then
        self.remove = true
        return
    end

    if #objects["portal"] < 2 then
        --if lastPortali ~= self.i then
            table.insert(objects["portal"], portal:new(x, y, rotation, self.i, self.screen))

            for x = 1, #tiles do
                if tiles[x][2].screen == self.screen then
                    tiles[x][2].passive = true
                end
            end
        --end
        self.remove = true
        return
    end

    objects["portal"][self.i]:destroy()

    objects["portal"][self.i] = portal:new(x, y, rotation, self.i, self.screen)
    
    self.remove = true
end