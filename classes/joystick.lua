joystick = class("joystick")

function joystick:init()
    self.dx = 0
    self.dy = 0

    self.x = 0
    self.y = 0

    self.r = 16 --deazone?

    self.rightStick = false
    self.leftStick = false
    self.upStick = false
    self.downStick = false

    self.isDown = love.keyboard.isDown
end

function joystick:update(dt)
    if self.rightStick then
        self.dx = math.min(self.dx + 48 * dt, self.r)
    end
    
    if self.leftStick then
        self.dx = math.max(self.dx - 48 * dt, -self.r)
    end
    
    if self.upStick then
        self.dy = math.max(self.dy - 48 * dt, -self.r)
    end
    
    if self.downStick then
        self.dy = math.min(self.dy + 48 * dt, self.r)
    end

    if love.system.getModel():find("n3ds") then
        self:stickUp(self.isDown("cstickup"))
        self:stickRight(self.isDown("cstickright"))
        self:stickDown(self.isDown("cstickdown"))
        self:stickLeft(self.isDown("cstickleft"))
    else
        self.held = love.mouse.isDown(1)
        if self.held then
            self.dx = util.clamp(love.mouse.getX() - self.x, -self.r, self.r)
            self.dy = util.clamp(love.mouse.getY() - self.y, -self.r, self.r)
        end
    end
end

function joystick:setPosition(x, y)
    self.x = x
    self.y = y
end

function joystick:isMoved()
    return self.dx == 0 and self.dy == 0
end

function joystick:stickRight(move)
    self.rightStick = move
end

function joystick:stickLeft(move)
    self.leftStick = move
end

function joystick:stickUp(move)
    self.upStick = move
end

function joystick:stickDown(move)
    self.downStick = move
end

function joystick:draw() --for debug
    if self.held then
        love.graphics.setScreen("bottom")

        love.graphics.setColor(200, 200, 200)

        love.graphics.circle("fill", self.x + (self.dx / self.r) * self.r, self.y + (self.dy / self.r) * self.r, self.r / 2, self.r)
        love.graphics.circle("line", self.x + (self.dx / self.r) * self.r, self.y + (self.dy / self.r) * self.r, self.r / 2, self.r)
        
        love.graphics.circle("line", self.x, self.y, self.r, self.r)

        love.graphics.line(self.x, self.y, self.x + self.r * self:getX(), self.y + self.r * self:getY())
        
        love.graphics.setColor(255, 255, 255)
    end
end

function joystick:getX()
    return (self.dx / self.r)
end

function joystick:getY()
    return (self.dy / self.r)
end