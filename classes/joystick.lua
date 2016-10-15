joystick = class("joystick")

function joystick:init()
    self.dx = 0
    self.dy = 0

    self.r = 16 --deazone?

    self.rightStick = false
    self.leftStick = false
    self.upStick = false
    self.downStick = false
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

    --[[if not self.rightStick and not self.leftStick then
        if self.dx > 0 then
            self.dx = self.dx - 48 * dt
        elseif self.dx < 0 then
            self.dx = self.dx + 48 * dt
        end
    end
    
    if not self.upStick and not self.downStick then
        if self.dy > 0 then
            self.dy = self.dy - 48 * dt
        elseif self.dy < 0 then
            self.dy = self.dy + 48 * dt
        end
    end]]
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
    love.graphics.setColor(200, 200, 200)

    love.graphics.circle("fill", 60 + (self.dx / self.r) * self.r, 60 + (self.dy / self.r) * self.r, self.r / 2, self.r)
    love.graphics.circle("line", 60 + (self.dx / self.r) * self.r, 60 + (self.dy / self.r) * self.r, self.r / 2, self.r)
    
    love.graphics.circle("line", 60, 60, self.r, self.r)

    love.graphics.line(60, 60, 60 + self.r * self:getX(), 60 + self.r * self:getY())
    
    love.graphics.setColor(255, 255, 255)
end

function joystick:getX()
    return (self.dx / self.r)
end

function joystick:getY()
    return (self.dy / self.r)
end