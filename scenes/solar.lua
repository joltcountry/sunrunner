require "obj.sceneryStar"
require "obj.scene"
require "ui.autopilotButton"
require "ui.planetFrame"
require "ui.cancelRouteButton"

SolarScene = Scene:new({ AutopilotButton, PlanetFrame, ShipConsole, CancelRouteButton })

local star, planetDirs

function SolarScene:load(loc)

    self.state.hovered = nil
    star = galaxy.stars[loc]
    self.state.star = star
    game.scene = "solar"
    sceneryStars = {}
    for i=1,200 do
        primary = math.random(1,3)
        if primary == 1 then
            starColor = { 1, math.random() - .5, math.random() + .3}
        elseif primary == 2 then
            starColor = { math.random() - .5, 1, math.random() + .3}
        elseif primary == 3 then
            starColor = { math.random() - .5, math.random() - .5, 1 }
        end
        sceneryStars[i] = SceneryStar:new(math.random() * width, math.random() * height, math.random() * 5 + 1, starColor, math.random() / 2 + .75)
    end

    if star.built then
        planetDirs = {}
        for i = 1, #star.planets do
            planetDirs[i] = math.random(0,359)
            star.planets[i].moonDirs = {}
            for j = 1, #star.planets[i].moons do
                star.planets[i].moonDirs[j] = math.random(0,359)
            end
        end
    end
end

function SolarScene:update(dt)
    self.state.hovered = nil
    x,y = love.mouse.getPosition()
    for i,v in ipairs(sceneryStars) do
        v:move(-.05,0)
    end
    if star.built then
        for i = 1, #star.planets do
            local dist = getDistance(x, y, width/2, height/2)
            local ring = star.size + 40 * star.planets[i].orbit
            if dist > ring - 20 and dist < ring + 20 then
                self.state.hovered = i
            end
        
            planetDirs[i] = (planetDirs[i] + star.planets[i].speed * 5 * dt) % 360
            for j = 1, #star.planets[i].moons do
                star.planets[i].moonDirs[j] = (star.planets[i].moonDirs[j] + star.planets[i].moons[j].speed * 100 * dt) % 360
            end
        end
    end
end

function SolarScene:draw()

    -- Draw scenery stars
    for x = 20,1,-1 do
        for i,v in ipairs(sceneryStars) do
            love.graphics.setColor(0, 0, 1/x)
            love.graphics.circle("fill", v.x, v.y, x * v.z/2)
        end
    end
    for i,v in ipairs(sceneryStars) do
        love.graphics.setColor(v.color[1] * v.luminosity, v.color[2] * v.luminosity, v.color[3] * v.luminosity);
        love.graphics.circle("fill", v.x, v.y, v.z/2)
        love.graphics.setColor(1, 1, 1);
        love.graphics.circle("fill", v.x, v.y, v.z/2.5)
    end

    -- Draw star
    star:draw()
    
    if star.built then
        -- Draw planets
        for i = 1, #star.planets do
            local radius = star.size + star.planets[i].orbit * 40
            -- draw planet selector ring
            if (self.state.hovered == i) then
                pingraph.setColor(.05, .1, .1)
                pingraph.setLineWidth(40)
                pingraph.circle('line', width/2, height/2, radius)
            else
                pingraph.setLineWidth(1)
                pingraph.setColor(.1, .1, .1)
                pingraph.circle('line', width/2, height/2, radius)
            end
            planetX = width/2 + math.sin(math.rad(planetDirs[i])) * radius
            planetY = height/2 - math.cos(math.rad(planetDirs[i])) * radius
            pingraph.setLineWidth(1)
            pingraph.setColor(1,1,1)
            planetSize = planetImages[star.planets[i].type]:getWidth() * star.planets[i].size / 40
            love.graphics.draw(planetImages[star.planets[i].type], planetX - planetSize / 2, planetY - planetSize / 2, 0, star.planets[i].size / 40)
    --        pingraph.setColor(star.planets[i].color)
    --        pingraph.circle('fill', planetX, planetY, star.planets[i].size)
            for j = 1, #star.planets[i].moons do
                moonDirs = star.planets[i].moonDirs
                local moonRadius = planetSize / 2 + star.planets[i].moons[j].orbit * 5
                pingraph.setColor(.1, .1, .1)
                pingraph.circle('line', planetX, planetY, moonRadius)
                pingraph.setColor(.3, .3, .5)
                moonX = planetX + math.sin(math.rad(moonDirs[j])) * moonRadius
                moonY = planetY - math.cos(math.rad(moonDirs[j])) * moonRadius
                pingraph.circle('fill', moonX, moonY, star.planets[i].moons[j].size)
            end
            
        end
    end

    -- Draw header
    pingraph.setFont(bigfont)
    pingraph.setColor(1, .5, 0)
    if star.built then
        message = star.name
    else
        message = "Unexplored"
    end
    pingraph.print(message, width / 2 - (bigfont:getWidth(message)/2), 10)

    if game.myship.loc == star.id then
        pingraph.setColor(1,1,1)
        pingraph.draw(game.myship.image, 200, 700)
    end
    
end

function SolarScene:mousepressed(x,y,button)
    if button == 2 then
        GalaxyScene:load()
    end
end

function SolarScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        GalaxyScene:load()
    end
end

