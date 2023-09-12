Ship = {}

function Ship:new(loc)
    local o = {}
    o.loc = loc
    setmetatable(o, self)
    self.__index = self
    return o
end
