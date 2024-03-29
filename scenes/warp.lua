require "obj.scene"
require "utils"

WarpScene = Scene:new()

local timer
local stars
local length
local _from, _to

function WarpScene:load(from, to)
    game.scene = "warp"
    _from = from
    _to = to
    timer = 0
    stars = {}
    spinDir = math.random(-5, 5)
    local dist = galaxy:getDistance(_from, _to)
    length = math.max(1, math.min(3, dist / (game.myship.travelRange / 3)))
end

function WarpScene:update(dt)
    timer = timer + dt
    if timer < length then
        for i = 1, 10 do
            local dir = math.random(0, 359)
            local dist = galaxy.stars[_to].size + 30
            stars[#stars+1] = { dir = dir, x = x, y = y, dist = dist, speed = 1 }
        end
    end
    for i,v in ipairs(stars) do
        v.dist = v.dist + v.speed
        local x = width/2 + math.sin(math.rad(v.dir)) * v.dist
        local y = height/2 - math.cos(math.rad(v.dir)) * v.dist
        v.x = x
        v.y = y
        if v.x < 0 or v.x > width or v.y < 0 or v.y > height then
            table.remove(stars, i)
        end
        v.speed = v.speed * 1.1
        v.dir = v.dir + spinDir
    end

    if #stars == 0 then 
        SolarScene:load(game.myship.loc)
    end
end

function WarpScene:draw()

    -- Draw scenery stars
    for x = 20,1,-1 do
        for i,v in ipairs(stars) do
            pingraph.setColor(0, 0, 1/x)
            pingraph.circle("fill", v.x, v.y, x * 3)
        end
    end
    for i,v in ipairs(stars) do
        pingraph.setColor(0,0,1);
        pingraph.circle("fill", v.x, v.y, 3)
        pingraph.setColor(math.random(), math.random(), 1);
        pingraph.circle("fill", v.x, v.y, 2)
    end

    pingraph.setColor(math.random(), math.random(), 1)
    pingraph.setFont(bigfont);
    local message = "Warping to " .. galaxy.stars[_to].name
    pingraph.print(message, width / 2 - bigfont:getWidth(message) / 2, 10)

    galaxy.stars[_to]:draw(math.min(timer / length, 1))
end
