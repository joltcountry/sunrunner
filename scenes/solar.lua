require "obj.sceneryStar"
require "obj.scene"
require "ui.autopilotButton"

SolarScene = Scene:new({ AutopilotButton })

local star, planetDirs, hovered

function SolarScene:load(loc)

    hovered = nil
    star = galaxy.stars[loc]
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
    hovered = nil
    x,y = love.mouse.getPosition()
    for i,v in ipairs(sceneryStars) do
        v:move(-.05,0)
    end
    if star.built then
        for i = 1, #star.planets do
            local dist = getDistance(x, y, width/2, height/2)
            local ring = star.size + 40 * star.planets[i].orbit
            if dist > ring - 20 and dist < ring + 20 then
                hovered = i
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
            if (hovered == i) then
                love.graphics.setColor(.05, .1, .1)
                love.graphics.setLineWidth(40)
                love.graphics.circle('line', width/2, height/2, radius)
            else
                love.graphics.setColor(.1, .1, .1)
                love.graphics.circle('line', width/2, height/2, radius)
            end
            planetX = width/2 + math.sin(math.rad(planetDirs[i])) * radius
            planetY = height/2 - math.cos(math.rad(planetDirs[i])) * radius
            love.graphics.setLineWidth(1)
            love.graphics.setColor(1,1,1)
            planetSize = planetImages[star.planets[i].type]:getWidth() * star.planets[i].size / 40
            love.graphics.draw(planetImages[star.planets[i].type], planetX - planetSize / 2, planetY - planetSize / 2, 0, star.planets[i].size / 40)
    --        love.graphics.setColor(star.planets[i].color)
    --        love.graphics.circle('fill', planetX, planetY, star.planets[i].size)
            for j = 1, #star.planets[i].moons do
                moonDirs = star.planets[i].moonDirs
                local moonRadius = planetSize / 2 + star.planets[i].moons[j].orbit * 5
                love.graphics.setColor(.1, .1, .1)
                love.graphics.circle('line', planetX, planetY, moonRadius)
                love.graphics.setColor(.3, .3, .5)
                moonX = planetX + math.sin(math.rad(moonDirs[j])) * moonRadius
                moonY = planetY - math.cos(math.rad(moonDirs[j])) * moonRadius
                love.graphics.circle('fill', moonX, moonY, star.planets[i].moons[j].size)
            end
            
        end
    end
    -- Draw header
    love.graphics.setFont(bigfont)
    love.graphics.setColor(1, .5, 0)
    if star.built then
        message = "Star #" ..selected
    else
        message = "Unexplored"
    end
    love.graphics.print(message, width / 2 - (bigfont:getWidth(message)/2), 10)

    if star.built then
        -- Draw planet window thing
        love.graphics.setFont(smallfont)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", 1400, 200, 150, 200)
        love.graphics.setColor(.5, 1, .5)
        love.graphics.rectangle("line", 1400, 200, 150, 200)
        love.graphics.print("Planet", 1455, 210)
        if (hovered) then
            love.graphics.setColor(1,1,1)
            love.graphics.draw(planetImages[star.planets[hovered].type], 1420, 220, .2)
            love.graphics.print("Moons: " .. #star.planets[hovered].moons, 1450, 380)

            --love.graphics.circle('fill', 1475, 310, star.planets[hovered].size * 3)
            -- for j = 1, #star.planets[hovered].moons do
            --     moonDirs = star.planets[hovered].moonDirs
            --     local moonRadius = star.planets[hovered].size * 3 + 5 + star.planets[hovered].moons[j].orbit * 5
            --     love.graphics.setColor(.1, .1, .1)
            --     love.graphics.circle('line', 1475, 310, moonRadius)
            --     love.graphics.setColor(.3, .3, .5)
            --     moonX = 1475 + math.sin(math.rad(moonDirs[j])) * moonRadius
            --     moonY = 310 - math.cos(math.rad(moonDirs[j])) * moonRadius
            --     love.graphics.circle('fill', moonX, moonY, star.planets[hovered].moons[j].size)
            -- end

        end
    end

    if game.myship.loc == star.id then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(game.myship.image, 200, 700)
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

