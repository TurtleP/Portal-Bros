function levelscreenInit()
    levelTimer = 2
    helpText = "remember you can run with " .. controls["run"] .. "!"
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

    fontPrint("world 1-1", util.getWidth() / 2 - #"world 1-1" * 8 / 2 - 8, util.getHeight() * 0.35)

    fontPrint(helpText, util.getWidth() / 2 - #helpText * 8 / 2 - 8, util.getHeight() * 0.9)
end