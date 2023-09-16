UIElement = {}

function UIElement:new(xpct, ypct, widthpct, heightpct)
    local o = {}
    o.xpct = xpct or 0
    o.ypct = ypct or 0
    o.widthpct = widthpct or 0
    o.heightpct = heightpct or 0
    o.x = o.xpct / 100 * (width or 0)
    o.y = o.ypct / 100 * (height or 0)
    o.width = o.widthpct / 100 * (width or 0)
    o.height = o.heightpct / 100 * (height or 0)

    o.active = true
    setmetatable(o, self)
    self.__index = self
    return o
end

function UIElement:update(dt)
end

function UIElement:draw()
end

function UIElement:keypressed(key, scancode, isrepeat)
end

function UIElement:mousepressed(x,y,button)
end

function UIElement:print(text, x, y)
    local realX = self.x + x
    local realY = self.y + y
    love.graphics.print(text, realX, realY)
end

function UIElement:printCentered(text, y)
    local currentFont = love.graphics.getFont()
    self:print(text, self.width / 2 - currentFont:getWidth(text) / 2, y)
end

function UIElement:circle(mode, x, y, radius)
    local realX = self.x + x
    local realY = self.y + y
    love.graphics.circle(mode, realX, realY, radius)
end

function UIElement:line(startX, startY, endX, endY)
    local realStartX = self.x + startX
    local realStartY = self.y + startY
    local realEndX = self.x + endX
    local realEndY = self.y + endY
    love.graphics.line(realStartX, realStartY, realEndX, realEndY)
end

function UIElement:drawImage(image, x, y, rot, scale)
    local realX = self.x + x
    local realY = self.y + y
    love.graphics.draw(image, realX, realY, rot, scale)
end