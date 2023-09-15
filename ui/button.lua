require ("ui.UIElement")

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
        local x = self.xpct / 100 * width
        local y = self.ypct / 100 * height
        local buttonWidth = self.widthpct / 100 * width
        local buttonHeight = self.heightpct / 100 * height

        love.graphics.setColor(self.backgroundColor)
        love.graphics.rectangle("fill", x, y, buttonWidth, buttonHeight)
        love.graphics.setColor(self.borderColor)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", x, y, buttonWidth, buttonHeight)
        love.graphics.setFont(smallfont)
        love.graphics.setColor(self.textColor)
        love.graphics.print(self.text, x + buttonWidth / 2 - (smallfont:getWidth(self.text) / 2), y + buttonHeight / 2 - (smallfont:getHeight(self.text) / 2))
    end
end

function Button:clicked(x, y, button)
end