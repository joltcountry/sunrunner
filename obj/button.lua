Button = {}
Button.__index = Button

function Button:new(text, x, y, func)
    o = {}
    setmetatable(o, self)
    o.text = text
    o.x = x
    o.y = y
    o.func = func
    return o
end

function Button:draw()
    love.graphics.setFont(font32);
    mouseX, mouseY = love.mouse.getPosition()
    if mouseX > self.x and mouseX < self.x + 250 and mouseY > self.y and mouseY < self.y + 40 then
        love.graphics.setColor(.7,.7, .5)
        love.graphics.rectangle('fill', self.x-20, self.y-3, 250, 40)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(self.text, self.x, self.y)
    else
        love.graphics.setColor(.7,.7, .5)
        love.graphics.rectangle('line', self.x-20, self.y-3, 250, 40)
        love.graphics.print(self.text, self.x, self.y)
    end
end

function Button:mousepressed(x, y, i)
    if (x > self.x and x < self.x + 250 and y > self.y and y < self.y + 40) then
        self.func()
    end
end