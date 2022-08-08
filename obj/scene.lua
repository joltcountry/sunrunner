Scene = {}
Scene.__index = Scene

function Scene:new(o)
    o = o or {}
    setmetatable(o, self)
    o.buttons = {}
    return o
end

function Scene:addButton(b)
    table.insert(self.buttons, b);
end

function Scene:drawButtons()
    for k,v in pairs(self.buttons) do
        v:draw()
    end
end