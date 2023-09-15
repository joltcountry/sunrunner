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

function Galaxy:starsInRange(range, x, y)
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

-- TODO - snipping causes problems sometimes
-- seed 1694697884 issue
function Galaxy:plotRoute(start, target, route, failures)
    route = route or { start }
    failures = failures or {}
    previousCandidates = previousCandidates or {}
    local candidates = {}

    local inRange = self:starsInRange(game.myship.travelRange, self:xy(start))
    for i, v in pairs(inRange) do
        for j, w in pairs(route) do
            if (i == w) then goto skip end
        end
        for j, w in pairs(failures) do
            if (i == w) then goto skip end
        end
        local distFromShip = galaxy:getDistance(game.myship.loc, i)
        if distFromShip > game.myship.plottingRange then goto skip end
        candidates[#candidates+1] = {star = i, dist = galaxy:getDistance(i, target)}
        ::skip::
    end
    
    -- sort candidates by dist to target
    table.sort(candidates, function (c1, c2) return c1.dist < c2.dist end )

    for _,v in pairs(candidates) do
        route[#route+1] = v.star
        if v.star == target then

            -- snip scenic routes
            for i = 1, #route do
                for j = #route, i+2, -1 do
                    if getDistance(self.stars[route[i]].x, self.stars[route[i]].y, self.stars[route[j]].x, self.stars[route[j]].y) <= game.myship.travelRange then
                        print("snipping from " .. i .. " to " .. j)
                        for x = i+1, j-1 do
                            table.remove(route, i+1)
                        end
                        goto next
                    end
                end
                ::next::
            end

            return route
        else
            local route = self:plotRoute(v.star, target, route, failures)
            if #route > 1 then
                return route
            else
                route[#route] = nil
                failures[#failures + 1] = v.star
            end
        end
    end 
    route = { target }
    return route

end

function Galaxy:xy(loc)
    return self.stars[loc].x, self.stars[loc].y
end

function Galaxy:getDistance(start, target)
    local startX, startY = self:xy(start)
    local targetX, targetY = self:xy(target)
    return getDistance(startX, startY, targetX, targetY)
end

function Galaxy:screenPos(loc)
    return galaxyx + galaxy.stars[loc].x * zoom, galaxyy + galaxy.stars[loc].y * zoom
end