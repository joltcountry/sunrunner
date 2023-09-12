SceneryStar = {}

function SceneryStar:new(x, y, z, color, luminosity)
    o = {}
    o.x = x or 0
    o.y = y or 0
    o.z = z or 5
    o.color = color or {0,0,1}
    o.luminosity = luminosity or 1
    setmetatable(o, self)
    self.__index = self
    return o
end

function SceneryStar:move(xspeed, yspeed, dt) 
    newx = self.x + xspeed * self.z
    newy = self.y + yspeed * self.z
    if newx > width + 50 then
        self.y = math.random(1, height)
        newx = -50
    elseif newx < -50 then
        self.y = math.random(1, height)
        newx = width + 50
    end
    if newy > height + 50 then
        self.x = math.random(1, width)
        newy = -50
    elseif newy < -50 then
        self.x = math.random(1, width)
        newy = height + 50
    end
    self.x = newx
    self.y = newy
end

function SceneryStar:update()
end
