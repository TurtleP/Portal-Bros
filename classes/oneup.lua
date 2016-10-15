oneup = class("oneup", mushroom)

function oneup:init(x, y, screen)
    mushroom.init(self, x, y, screen)

    self.quadi = 2
end

function oneup:collect(player)
    player:addLife(1)
    
    playSound(oneupSound)

    table.insert(scoreTexts, scoretext:new("1up", self.x - 4, self.y, self.screen))
    
    self.remove = true
end