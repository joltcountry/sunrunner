require ("ui.frame")

SimpleFrame = Frame:new()

function SimpleFrame:new(xpct, ypct, widthpct, heightpct, borderColor, backgroundColor)
    local o = Frame:new(xpct, ypct, widthpct, heightpct)
    o.borderColor = borderColor or {.5, 1, .5}
    o.backgroundColor = backgroundColor or {0,0,0}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SimpleFrame:draw(scene)
    if self.active then
        love.graphics.setColor(self.backgroundColor)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(self.borderColor)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.setScissor(self.x, self.y, self.width, self.height)
        self:render(scene)
        love.graphics.setScissor()
    end
end

function SimpleFrame:render(scene)
end

function SimpleFrame:clicked(x, y, button, scene)
end

