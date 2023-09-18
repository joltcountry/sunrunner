require ("ui.frame")

CRTFrame = Frame:new()

function CRTFrame:new(xpct, ypct, widthpct, heightpct, mode)
    local o = Frame:new(xpct, ypct, widthpct, heightpct)
    o:setMode(mode)
    setmetatable(o, self)
    self.__index = self
    return o
end

function CRTFrame:setMode(mode) 
    self.mode = mode
    if mode == "heliotrope" then
        self.borderColor = {1, 0, 1}
        self.backgroundColor = function(g) return {g*2, 0, g*2} end
    elseif mode == "amber" then
        self.borderColor = {1, .7, 0}
        self.backgroundColor = function(g) return {g, g, 0} end
    else
        self.borderColor = {0, .7, 0}
        self.backgroundColor = function(g) return {0, g, 0} end
    end
end

function CRTFrame:draw(scene)
    if self.active then
        love.graphics.setColor(self.borderColor)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.setScissor(self.x, self.y, self.width, self.height)
        local pixelSize = 5
        for j = 1, self.height, pixelSize do
            for i = 1, self.width, pixelSize do
                local g = math.random() * (self.on and .1 or .5)
                if (self.on) then
                    love.graphics.setColor(self.backgroundColor(g))
                else
                    love.graphics.setColor(g,g,g)
                end
                self:rectangle("fill", i, j, pixelSize, pixelSize)
            end
        end
        if self.on then
            self:render(scene)
        end
        love.graphics.setScissor()
    end
end

function CRTFrame:setBrightness(x) 
    if self.mode == "heliotrope" then
        love.graphics.setColor(x, 0, x)
    elseif self.mode == "amber" then
        love.graphics.setColor(x, x * .75, 0)
    else
        love.graphics.setColor(0, x, 0)
    end
end

function CRTFrame:render(scene)
end

function CRTFrame:clicked(x, y, button, scene)
    self.on = not self.on
end

