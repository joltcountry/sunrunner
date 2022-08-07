Planet = {}
Planet.__index = Planet

function Planet:new(o)
    o = o or {}
    setmetatable(o, self)
    o.size = math.floor(math.random(8) + 2)
    o.orbitSpeed = math.random(15) + 5
    o.distanceFromSun = math.random(2,10)
    o.directionFromSun = math.random(0, 359)
    o.color = { math.random(), math.random(), math.random() }
    return o
end

function Planet:draw()
    x = love.graphics.getWidth() / 2 + math.cos(math.rad(self.directionFromSun)) * self.distanceFromSun * 40
    y = love.graphics.getHeight() / 2 + math.sin(math.rad(self.directionFromSun)) * self.distanceFromSun * 40
    love.graphics.setColor(.1, .1, .2)
    d = getDistance(love.graphics.getWidth()/2, love.graphics.getHeight()/2, x, y);
    love.graphics.circle('line', love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, d);

    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.circle('fill', x, y, self.size * 2)
end