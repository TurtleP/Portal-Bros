barrier = class("barrier")

function barrier:init(x, y, width, height, screen)
    self.x = x
    self.y = y
    
    self.width = width
    self.height = height

    self.active = false
    self.static = true

    self.speedx = 0
    self.speedy = 0

    self.screen = screen
end