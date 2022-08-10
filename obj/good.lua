Good = {}
Good.__index = Good

function Good:new(name, minPrice, maxPrice, isContraband)
    local o = {}
    setmetatable(o, self)
    o.name = name
    o.minPrice = minPrice
    o.maxPrice = maxPrice
    o.isContraband = isContraband
    return o
end

function Good:getRandomPrice()
    return math.random(self.minPrice, self.maxPrice)
end
