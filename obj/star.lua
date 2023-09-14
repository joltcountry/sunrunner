require "obj.planet"
Star = {}

function Star:new(id, dir, dist, x, y, color1, color2, size)
    local o = {}
    o.id = id
    o.dir = dir
    o.dist = dist
    o.x = x
    o.y = y
    o.color1 = color1
    o.color2 = color2
    o.size = size

    setmetatable(o, self)
    self.__index = self
    return o
end

function Star:build()
    if self.built == true then return end

    self.planets = {}
    local numOfPlanets = math.random(1,9)
    local dice = math.random(1,9)
    if dice >= numOfPlanets then
        local orbits = {1,2,3,4,5,6,7,8,9}
        for i = 1, numOfPlanets do
            local moons = {}
            if math.random() > .5 then 
                local numOfMoons = math.random(1,5)
                local dice = math.random(1,5);
                if dice >= numOfMoons then
                    for j = 1, numOfMoons do
                        local moon = Planet:new(j, 3, j)
                        moons[j] = moon
                    end
                end
            end
            local orbitLoc = math.random(1,#orbits)
            local nextOrbit = orbits[orbitLoc]
            table.remove(orbits, orbitLoc)
            local planet = Planet:new(math.random(1,10), math.random(5,15), nextOrbit, moons)
            self.planets[i] = planet
        end
    end
    self.built = true
end

function Star:draw(scale, rings)
    scale = scale or 1
    rings = rings or 10 + self.size / 3
    enhancer = 0.01 + (math.random() * 0.04 / (self.size * scale / 5))
    for i = rings, 1, -1 do
        love.graphics.setColor(self.color1[1]/i + enhancer * (rings-i), self.color1[2]/i + enhancer * (rings-i), self.color1[3]/i + enhancer * (rings-i))
        love.graphics.circle('fill', width / 2, height / 2, self.size * scale + i)
        love.graphics.setColor(self.color2[1],self.color2[2],self.color2[3])
        love.graphics.circle('fill', width / 2, height / 2, self.size * scale - 1)
    end
end

function Star:moonCount()
    local moonCount = 0
    for _, v in ipairs(self.planets) do
        moonCount = moonCount + #v.moons
    end
    return moonCount
end
