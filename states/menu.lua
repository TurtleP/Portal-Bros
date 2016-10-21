function menuInit()
    gameInit(true)

    menuOptions = 
    {
        {"play game", function() util.changeState("levelscreen") end},
        {"options menu", function() --[[showOptions = true]] end},
        {"select mappack", function() end},
    }

    menuSelectioni = 1
end

function menuUpdate(dt)
    cameraObjects = checkrectangle(0, 0, 400, 240, {"mario", "tile", "pipe", "coinblock"})

    coinCounterTimer = coinCounterTimer + 3.5 * dt
    coinCounterQuadi = math.floor(coinCounterTimer % 4) + 1
end

function menuDraw()
    gameDraw()

    if not showOptions then
        love.graphics.draw(titleImage, util.getWidth() / 2 - titleImage:getWidth() / 2, util.getHeight() * 0.2)
        for y = 1, #menuOptions do
            fontPrint(menuOptions[y][1], util.getWidth() / 2 - #menuOptions[y][1] * 8  / 2 - 8, util.getHeight() * 0.65 + (y - 1) * 16)

            if menuSelectioni == y then
                love.graphics.draw(menuSelectImage, util.getWidth() / 2 - #menuOptions[y][1] * 8  / 2 - 24, util.getHeight() * 0.65 + (y - 1) * 16 - 1)
            end
        end
    else

    end
end

function menuKeyPressed(key)
    if not showOptions then
        if key == "down" or key == "cpaddown" then
            menuSelectioni = math.min(menuSelectioni + 1, #menuOptions)
        elseif key == "up" or key == "cpadup" then
            menuSelectioni = math.max(menuSelectioni - 1, 1)
        elseif key == "a" then
            menuOptions[menuSelectioni][2]()
        end
    else

    end
end
