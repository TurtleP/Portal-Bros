barrier = class("barrier")

function barrier:init(x, y, width, height, screen)
    self.x = x
    self.y = y
    
    self.width = width
    self.height = height

    self.category = 10

    self.active = true
    self.static = true

    self.speedx = 0
    self.speedy = 0

    self.screen = screen
end