Planet = {}

function Planet:new(type, size, orbit, moons)
    local o = {}
    o.type = type
    o.size = size
    o.orbit = orbit
    o.color = { math.random(), math.random(), math.random() }
    o.speed = math.random() * .8 + .2
    o.moons = moons
    setmetatable(o, self)
    self.__index = self
    return o
end