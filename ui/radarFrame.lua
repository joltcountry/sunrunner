require ("ui.CRTFrame")

RadarFrame = CRTFrame:new(71, 74, 25 * 9/16, 25)

RadarFrame.on = true

local radarZoom = 8
local t = 0
local blink = true
function RadarFrame:update(dt, scene)
    t = t + dt
    if (t > .2) then
        blink = not blink
        t = 0
    end
end

function RadarFrame:render(scene)

    love.graphics.setColor(.8,.6,0)
    local stars = galaxy:starsInRange(game.myship.scanningRange, galaxy:xy(game.myship.loc))
    local startX, startY = galaxy:xy(game.myship.loc)
    love.graphics.setFont(smallfont)
    for i,v in pairs(stars) do
        local dist = galaxy:getDistance(game.myship.loc, i)
        local endX, endY = galaxy:xy(i)
        local dir = getDir(startX, startY, endX, endY)
        local x = self.width / 2 + math.sin(math.rad(dir)) * dist * radarZoom
        local y = self.height / 2 - math.cos(math.rad(dir)) * dist * radarZoom
        if game.myship.route and #game.myship.route > 1 and i == game.myship.route[2] and blink then
            love.graphics.setColor(1,.8,0)
        else
            love.graphics.setColor(.7,.5,0)
        end
        self:circle("fill", x, y, 6)
        love.graphics.setColor(.8,.6,0)
        self:print(galaxy.stars[i].name, x - smallfont:getWidth(galaxy.stars[i].name) / 2, y + 5)

    end
end
