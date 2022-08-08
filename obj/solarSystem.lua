SolarSystem = {
    planets = {}
}
SolarSystem.__index = SolarSystem

function SolarSystem:new(name)
    o = {}
    o.name = name
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

function SolarSystem:mousepressed(x, y, i)
    for i,v in ipairs(self.planets) do
        if x > v:x() - v.size * 3 and x < v:x() + v.size * 3 and y > v:y() - v.size * 2 and y < v:y() + v.size * 2 then
            gamestate.scene = Scenes.docked
            gamestate.shipLocation = v
            Scenes.docked.planet = v
        end
    end
end