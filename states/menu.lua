function menuInit()
    gameInit()
end

function menuUpdate(dt)
    cameraObjects = checkrectangle(0, 0, 400, 240, {"mario", "tile", "pipe", "coinblock"})

    coinCounterTimer = coinCounterTimer + 3.5 * dt
    coinCounterQuadi = math.floor(coinCounterTimer % 4) + 1
end

function menuDraw()
    gameDraw()
end
