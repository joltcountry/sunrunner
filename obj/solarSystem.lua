SolarSystem = {
    planets = {}
}
SolarSystem.__index = SolarSystem

function SolarSystem:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function SolarSystem:addPlanet(p)
    table.insert(self.planets, p);
end

function SolarSystem:draw()
    love.graphics.setColor(1,1,.5)
    love.graphics.circle('fill', love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 50)
    for i,v in ipairs(self.planets) do
        v:draw()
    end
end
