require "obj.star"
require "utils"

Galaxy = {}

function Galaxy:new(numOfStars, spacing)
    local o = {}
    o.spacing = spacing or 4
    o.stars = {}

    local distance, dice, loc, dir, dist, x, y, tooClose, attempts, primaryColor
    for n = 1, numOfStars do
        ::tryAgain::
        repeat 
            distance = math.random();
            dice = math.random()
        until dice < distance
        local attempts = 1
        repeat
            loc = math.random() * distance
            dir = math.random() * 360
            dist = 50 + loc * numOfStars / 3.14
            x = math.sin(math.rad(dir)) * dist
            y = -math.cos(math.rad(dir)) * dist
            tooClose = false
            for d = 1,#o.stars do
                if math.abs(x-o.stars[d].x) < o.spacing and math.abs(y-o.stars[d].y) < o.spacing then
                    tooClose = true
                    goto giveUp
                end
            end
            ::giveUp::
--            if (tooClose) then print("Ya too close, mon! "..n) end
            attempts = attempts + 1
            if attempts > 500 then 
  --              print("Giving up. :(")
                goto tryAgain
            end
        until not tooClose
        primaryColor = math.random(1,3)
        if primaryColor == 1 then
            color1 = { math.random() * .3 + .7, math.random(), math.random() }
            color2 = { 1, .9, .9 }
        elseif primaryColor == 2 then
            color1 = { math.random(), math.random() * .3 + .7, math.random() }
            color2 = { .9, 1, .9 }
        else
            color1 = { math.random(), math.random(), math.random() * .3 + .7 }
            color2 = { .9, .9, 1 }
        end
        o.stars[n] = Star:new(n, dir, dist, x, y, color1, color2, math.random(10,75)) 

    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function Galaxy:getLocation(i) 
    return self.stars[i].x, self.stars[i].y
end

function Galaxy:starsInRange(x, y, range)
    local inRange = {}
    local stars = {}
    for i, v in ipairs(self.stars) do
        local dist = getDistance(x, y, v.x, v.y)
        if dist <= range then
            inRange[i] = true
            stars[#stars + 1] = v
        end
    end
    return inRange, stars
end