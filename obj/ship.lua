Ship = {}

function Ship:new(loc)
    local o = {}
    o.loc = loc
    o.image = love.graphics.newImage("assets/images/ship.png")
    o.travelRange = 30
    o.scanningRange = 20
    setmetatable(o, self)
    self.__index = self
    return o
end

function Ship:moveTo(loc)
    self.loc = loc
    if not galaxy.stars[loc].built then
        galaxy.stars[loc]:build()
    end
    game.plottedRoutes = {}
end
