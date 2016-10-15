function newSpriteBatch(image, quad, screen)
    local batch = {}

    batch.image = image
    batch.quads = quad
    batch.info = {}
    batch.screen = screen

    function batch:add(r, x, y)
        table.insert(self.info, {r, x, y})
    end

    function batch:draw()
        love.graphics.push()

        love.graphics.translate(-scrollValues[self.screen][1], 0)

        love.graphics.setScreen(self.screen)

        for k, v in ipairs(self.info) do
            love.graphics.draw(self.image, self.quads[v[1]], v[2], v[3])
        end
    
        love.graphics.pop()
    end

    return batch
end