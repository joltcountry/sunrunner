Ship = {}

function Ship:new(loc)
    local o = {}
    o.loc = loc
    o.image = pingraph.newImage("assets/images/ship.png")
    o.travelRange = 16
    o.scanningRange = 32
    o.plottingRange = 100
    setmetatable(o, self)
    self.__index = self
    return o
end

function Ship:moveTo(loc)
    self.loc = loc
    inScanningRange = galaxy:starsInRange(game.myship.scanningRange, galaxy:xy(game.myship.loc))
    for k,v in pairs(inScanningRange) do
        galaxy.stars[k]:build()
    end
    game.plottedRoutes = {}
end
