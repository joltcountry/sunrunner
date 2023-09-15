UIElement = {}

function UIElement:new(xpct, ypct, widthpct, heightpct)
    local o = {}
    o.xpct = xpct
    o.ypct = ypct
    o.widthpct = widthpct
    o.heightpct = heightpct
    o.active = true
    setmetatable(o, self)
    self.__index = self
    return o
end

function UIElement:update()
end

function UIElement:draw(dt)
end

function UIElement:keypressed(key, scancode, isrepeat)
end

function UIElement:mousepressed(x,y,button)
    if self.active then
        local startX = self.xpct / 100 * width
        local startY = self.ypct / 100 * height
        local buttonWidth = self.widthpct / 100 * width
        local buttonHeight = self.heightpct / 100 * height
        local endX = startX + buttonWidth
        local endY = startY + buttonHeight
        if x > startX and x < endX and y > startY and y < endY then
            self:clicked(x - startX, y - startY, button)
            return true
        end
    end
end