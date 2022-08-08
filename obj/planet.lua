Planet = {}
Planet.__index = Planet

function Planet:new(name)
    o = {}
    setmetatable(o, self)
    o.size = math.floor(math.random(8) + 5)
    o.orbitSpeed = math.random(15) + 5
    o.distanceFromSun = math.random(2,10)
    o.directionFromSun = math.random(0, 359)
    o.color = { math.random(), math.random(), math.random() }
    o.name = name
    return o
end

function Planet:draw()
    x = self:x()
    y = self:y()
    love.graphics.setColor(.1, .1, .2)
    d = getDistance(love.graphics.getWidth()/2, love.graphics.getHeight()/2, x, y);
    love.graphics.circle('line', love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, d);

    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.circle('fill', x, y, self.size * 2)

    mouseX, mouseY = love.mouse.getPosition()
    if mouseX > x - self.size * 3 and mouseX < x + self.size * 3 and mouseY > y - self.size * 2 and mouseY < y + self.size * 2 then
        love.graphics.setLineWidth(3);
        love.graphics.setColor(.7, .7, 1);
        love.graphics.circle('line', x, y, self.size * 2 + 5);
        love.graphics.setLineWidth(1);
        love.graphics.setFont(font18);
        love.graphics.setColor(.8, 1, 1);
        love.graphics.print(self.name, x-30, y+30)
    end

    if gamestate.shipLocation == self then
        love.graphics.setColor(1,1,1)
        local startX = x + self.size * 2 + 5
        local startY = y + self.size

        love.graphics.polygon('fill', startX, startY, startX + 10, startY + 5, startX, startY + 10)
    end
end

function Planet:x()
    return love.graphics.getWidth() / 2 + math.cos(math.rad(self.directionFromSun)) * self.distanceFromSun * 40
end

function Planet:y()
    return love.graphics.getHeight() / 2 + math.sin(math.rad(self.directionFromSun)) * self.distanceFromSun * 40
end    