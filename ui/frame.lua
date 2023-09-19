require ("ui.uiElement")

Frame = UIElement:new()

function Frame:new(xpct, ypct, widthpct, heightpct, borderColor, backgroundColor)
    local o = UIElement:new(xpct, ypct, widthpct, heightpct)
    o.borderColor = borderColor or {.5, 1, .5}
    o.backgroundColor = backgroundColor or {0,0,0}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Frame:draw(scene)
    if self.active then
        pingraph.setColor(self.backgroundColor)
        pingraph.rectangle("fill", self.x, self.y, self.width, self.height)
        pingraph.setColor(self.borderColor)
        pingraph.setLineWidth(3)
        pingraph.rectangle("line", self.x, self.y, self.width, self.height)
        pingraph.setScissor(self.x, self.y, self.width, self.height)
        self:render(scene)
        pingraph.setScissor()
    end
end

function Frame:render(scene)
end

function Frame:clicked(x, y, button, scene)
end

