UIElement = {}

function UIElement:new(xpct, ypct, widthpct, heightpct)
    local o = {}
    o.xpct = xpct or 0
    o.ypct = ypct or 0
    o.widthpct = widthpct or 0
    o.heightpct = heightpct or 0
    o.active = true
    setmetatable(o, self)
    self.__index = self
    return o
end

function UIElement:hasMouse()
    local x, y = love.mouse.getPosition()
    return x >= self.x and x <= (self.x + self.width) and y >= self.y and y <= (self.y + self.width)
end

function UIElement:setDimensions(w, h)
    self.x = self.xpct / 100 * (width or 0)
    self.y = self.ypct / 100 * (height or 0)
    self.width = self.widthpct / 100 * (width or 0)
    self.height = self.heightpct / 100 * (height or 0)
end

function UIElement:update(dt, scene)
end

function UIElement:draw(scene)
end

function UIElement:keypressed(key, scancode, isrepeat, scene)
end

function UIElement:wheelmoved(x,y, scene)
end

function UIElement:mousepressed(x,y,button, scene)
    if self.active then
        local endX = self.x + self.width
        local endY = self.y + self.height
        if x > self.x and x < endX and y > self.y and y < endY then
            self:clicked(x - self.x, y - self.y, button)
            return true
        end
    end
end

function UIElement:print(text, x, y)
    local realX = self.x + x
    local realY = self.y + y
    love.graphics.print(text, realX, realY, scene)
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

function UIElement:rectangle(mode, x, y, w, h)
    local realX = self.x + x
    local realY = self.y + y
    love.graphics.rectangle(mode, realX, realY, w, h)
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

function UIElement:setMode(mode)
end
