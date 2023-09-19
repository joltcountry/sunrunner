require ("ui.uiElement")

Button = UIElement:new()

function Button:new(xpct, ypct, widthpct, heightpct, text, borderColor, backgroundColor, textColor)
    local o = UIElement:new(xpct, ypct, widthpct, heightpct)
    o.text = text
    o.borderColor = borderColor or {.5, 1, .5}
    o.backgroundColor = backgroundColor or {0,0,0}
    o.textColor = textColor or {.5, 1, .5}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Button:update(dt)
end

function Button:draw()
    if self.active then
        pingraph.setColor(self.backgroundColor)
        pingraph.rectangle("fill", self.x, self.y, self.width, self.height)
        pingraph.setColor(self.borderColor)
        pingraph.setLineWidth(3)
        pingraph.rectangle("line", self.x, self.y, self.width, self.height)
        pingraph.setFont(smallfont)
        pingraph.setColor(self.textColor)
        self:printCentered(self.text, self.height / 2 - (smallfont:getHeight(self.text) / 2))
    end
end

function Button:clicked(x, y, button)
end