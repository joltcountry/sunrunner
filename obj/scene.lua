Scene = {}

function Scene:new(ui)
    local o = {}
    o.state = {}
    o.ui = ui
    setmetatable(o, self)
    self.__index = self
    return o
end

function Scene:init()
end

function Scene:load()
end

function Scene:update(dt)
end

function Scene:draw()
end

function Scene:mousepressed(x,y,button)
end

function Scene:wheelmoved(x,y)
end

function Scene:keypressed(key, scancode, isrepeat)
end