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
        love.graphics.setColor(self.backgroundColor)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(self.borderColor)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.setFont(smallfont)
        love.graphics.setColor(self.textColor)
        self:printCentered(self.text, self.height / 2 - (smallfont:getHeight(self.text) / 2))
    end
end

function Button:clicked(x, y, button)
end