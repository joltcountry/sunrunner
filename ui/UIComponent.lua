UIComponent = {}

function UIComponent:new(uiElements)
    local o = {}
    o.uiElements = uiElements
    setmetatable(o, self)
    self.__index = self
    return o
end

function UIComponent:setDimensions(w, h)
    for _, el in pairs(self.uiElements) do
        el:setDimensions(w, h)
    end
end

function UIComponent:update(dt, scene)
    for _, el in pairs(self.uiElements) do
        el:update(dt, scene)
    end
end

function UIComponent:draw(scene)
    for _, el in pairs(self.uiElements) do
        el:draw(dt, scene)
    end
end

function UIComponent:keypressed(key, scancode, isrepeat, scene)
    for _, el in pairs(self.uiElements) do
        el:keypressed(key, scancode, isrepeat, scene)
    end
end

function UIComponent:mousepressed(x,y,button, scene)
    for _, el in pairs(self.uiElements) do
        el:mousepressed(x, y, button, scene)
    end
end

function UIComponent:setMode(mode)
    for _, el in pairs(self.uiElements) do
        el:setMode(mode)
    end
end
