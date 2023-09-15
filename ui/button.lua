require ("ui.ui")

Button = UI:new()

function Button:new(xpct, ypct, widthpct, heightpct, text)
    local o = UI:new(xpct, ypct, widthpct, heightpct)
    o.text = text
    setmetatable(o, self)
    self.__index = self
    return o
end

function Button:draw()
    if game.myship.route then
        local x = self.xpct / 100 * width
        local y = self.ypct / 100 * height
        local buttonWidth = self.widthpct / 100 * width
        local buttonHeight = self.heightpct / 100 * height

        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", x, y, buttonWidth, buttonHeight)
        love.graphics.setColor(.5, 1, .5)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", x, y, buttonWidth, buttonHeight)
        love.graphics.setFont(smallfont)
        love.graphics.print(self.text, x + buttonWidth / 2 - (smallfont:getWidth(self.text) / 2), y + buttonHeight / 2 - (smallfont:getHeight(self.text) / 2))
    end
end

function Button:mousepressed(x,y,button)
    local startX = self.xpct / 100 * width
    local startY = self.ypct / 100 * height
    local buttonWidth = self.widthpct / 100 * width
    local buttonHeight = self.heightpct / 100 * height
    local endX = startX + buttonWidth
    local endY = startY + buttonHeight
    if x > startX and x < endX and y > startY and y < endY then
        self:clicked(button)
    end
end

function Button:clicked(button)
end