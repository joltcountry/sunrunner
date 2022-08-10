Inventory = {}
Inventory.__index = Inventory
Inventory.__tostring = function(self)
    if self.units > 1 then
        return self.units .. ' ' .. self.good.name .. 's ($'..self.price..')'
    else
        return self.units .. ' ' .. self.good.name .. ' ($'..self.price..')'
    end
end

function Inventory:new(good, units, price)
    o = {}
    setmetatable(o, self)
    o.good = good
    o.units = units
    o.price = price
    return o
end

function Inventory:generate(good)
    local units = math.random(1, 100)
    local price = good:getRandomPrice()
    local i = self:new(good, units, price)
    return i
end
