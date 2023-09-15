UI = {}

function UI:new(xpct, ypct, widthpct, heightpct)
    local o = {}
    o.xpct = xpct
    o.ypct = ypct
    o.widthpct = widthpct
    o.heightpct = heightpct
    setmetatable(o, self)
    self.__index = self
    return o
end

function UI:update()
end

function UI:draw(dt)
end

function UI:mousepressed(x, y, button)
end