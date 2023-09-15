Ship = {}

function Ship:new(loc)
    local o = {}
    o.loc = loc
    o.image = love.graphics.newImage("assets/images/ship.png")
    o.travelRange = 20
    o.scanningRange = 30
    o.plottingRange = 200
    setmetatable(o, self)
    self.__index = self
    return o
end

function Ship:moveTo(loc)
    self.loc = loc
    galaxy.stars[loc]:build()
    game.plottedRoutes = {}
end
