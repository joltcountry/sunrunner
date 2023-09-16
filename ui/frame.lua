require ("ui.UIElement")

Frame = UIElement:new()

function Frame:new(xpct, ypct, widthpct, heightpct, borderColor, backgroundColor)
    local o = UIElement:new(xpct, ypct, widthpct, heightpct)
    o.borderColor = borderColor or {.5, 1, .5}
    o.backgroundColor = backgroundColor or {0,0,0}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Frame:update(dt)
    if (game.hovered) then self.active = true else self.active = false end
end

function Frame:draw()
    if self.active then
        love.graphics.setColor(self.backgroundColor)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(self.borderColor)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.setScissor(self.x, self.y, self.width, self.height)
        self:render()
        love.graphics.setScissor()
    end
end

function Frame:render()
end

function Frame:clicked(x, y, button)
end

