require ("ui.CRTFrame")
require ("ui.UIComponent")

-- Left frame
LeftFrame = CRTFrame:new(15, 74, 25 * 9/16, 25)

function LeftFrame:render(scene)
    self:setBrightness(.8)
    love.graphics.setFont(mediumfont)
    self:printCentered("TBD", self.height / 2)
end

-- Ship info frame
ShipFrame = CRTFrame:new(30, 90, 40, 9)
ShipFrame.on = true

function ShipFrame:render(scene)
    love.graphics.setFont(smallfont)
    self:setBrightness(1)
    self:print("Location:", 5, 2)
    self:print("Warp range:", 5, 22)
    self:print("Scan range:", 5, 42)
    self:print("Plotting range:", 5, 62)
    self:print("Credits:", 550, 2)
    if (game.myship.route and #game.myship.route > 1) then
        self:print("Route plotted:", 250, 2)
        self:print("Next waypoint:", 250, 22)
    end
    self:setBrightness(.7)
    self:print(galaxy.stars[game.myship.loc].name, 100, 2)
    self:print(game.myship.travelRange, 100, 22)
    self:print(game.myship.scanningRange, 100, 42)
    self:print(game.myship.plottingRange, 100, 62)
    self:print(game.credits, 600, 2)
    if (game.myship.route and #game.myship.route > 1) then
        local target = galaxy.stars[game.myship.route[#game.myship.route]]
        self:print(target.built and target.name or "Unexplored", 350, 2)
        self:print(galaxy.stars[game.myship.route[2]].name, 350, 22)
    end
end

-- Radar frame
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
    local stars = galaxy:starsInRange(game.myship.scanningRange, galaxy:xy(game.myship.loc))
    local startX, startY = galaxy:xy(game.myship.loc)
    love.graphics.setFont(smallfont)
    for i,v in pairs(stars) do
        local dist = galaxy:getDistance(game.myship.loc, i)
        local endX, endY = galaxy:xy(i)
        local dir = getDir(startX, startY, endX, endY)
        local x = self.width / 2 + math.sin(math.rad(dir)) * dist * radarZoom
        local y = self.height / 2 - math.cos(math.rad(dir)) * dist * radarZoom
        if game.myship.route and #game.myship.route > 1 and i == game.myship.route[2] then
            self:setBrightness(.3)
            love.graphics.setLineWidth(1)
            self:line(self.width / 2, self.height / 2, x, y)
            if blink then
                self:setBrightness(1)
            end
        else
            self:setBrightness(.8)
        end
        self:circle("fill", x, y, 6)
        self:setBrightness(.6)
        self:print(galaxy.stars[i].name, x - smallfont:getWidth(galaxy.stars[i].name) / 2, y + 5)
    end
end

ShipConsole = UIComponent:new({ LeftFrame, ShipFrame, RadarFrame })
