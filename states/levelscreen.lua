function levelscreenInit()
    levelTimer = 2.5
    helpText = "remember you can run with " .. controls["run"] .. "!"
    love.audio.stop()
end

function levelscreenUpdate(dt)
    if levelTimer > 0 then
        levelTimer = levelTimer - dt
    else
        util.changeState("game")
    end
end

function levelscreenDraw()
    gameDrawHUD()

    love.graphics.setScreen("top")
    
    fontPrint("world " .. marioWorld .. "-" .. marioLevel, util.getWidth() / 2 - #"world 1-1" * 8 / 2 - 8, util.getHeight() * 0.35)

    love.graphics.draw(marioImage, marioQuads[1][1], util.getWidth() / 2 - 32, util.getHeight() * 0.42)

    fontPrint("* 3", util.getWidth() / 2, util.getHeight() * 0.456)

    fontPrint(helpText, util.getWidth() / 2 - #helpText * 8 / 2 - 8, util.getHeight() * 0.9)
end