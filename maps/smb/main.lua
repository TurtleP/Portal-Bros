function love.load()
	local imgData = love.image.newImageData("1-1.png")

	local newImageData = {}
	for y = 1, math.ceil(imgData:getWidth() / 400) + 1 do
		newImageData[y] = love.image.newImageData(400, 240)
	end

	for x = 1, #newImageData do
		newImageData[x]:paste(imgData, 0, 0, (x - 1) * 400, 0, 400, 240)
	end

		
	for k, v in ipairs(newImageData) do
		newImageData[k]:encode("png", "1-1_" .. k .. ".png")
	end

	love.system.openURL(love.filesystem.getSaveDirectory())
end
