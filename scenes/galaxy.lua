require "obj.galaxy"
require "utils"
require "obj.scene"

GalaxyScene = Scene:new()

function GalaxyScene:init(numOfStars)
    galaxy = Galaxy:new(numOfStars)
    range = 20
    galaxyx = width/2
    galaxyy = height/2
    sunsize = 40
end

function GalaxyScene:load()
    scene = "galaxy"
    selected = nil
end

function GalaxyScene:update(dt)

    displayed = {}

    inRange = {}
    shipX, shipY = galaxy:getLocation(game.myship.loc)
    inRange = galaxy:starsInRange(shipX, shipY, range)

    -- Determine which ones are likely to displayed, dispense with the rest
    local selectedDisplayed = false
    for i,v in ipairs(galaxy.stars) do
        if zoom < 3 then
            v.dir = v.dir + .5 * dt
        end
        v.x = math.sin(math.rad(v.dir)) * v.dist
        v.y = -math.cos(math.rad(v.dir)) * v.dist
        local screenX = galaxyx + v.x * zoom
        local screenY = galaxyy + v.y * zoom
        if screenX > 0 - width / 2 and screenX < width + width/2 and screenY > 0 - height/2 and screenY < height + height/2 then
            displayed[i] = v
            if i == selected then
                selectedDisplayed = true
            end
        end

        -- auto explore
        if not v.built and inRange[i] then
            v:build()
        end

    end

    -- See if the mouse is hovering over a star
    x, y = love.mouse.getPosition()
    hovered = nil
    for i,v in pairs(displayed) do
        v.x = math.sin(math.rad(v.dir)) * v.dist
        v.y = -math.cos(math.rad(v.dir)) * v.dist
        local size = galaxy.spacing * zoom
        local screenX = galaxyx + v.x * zoom
        local screenY = galaxyy + v.y * zoom
        if x > screenX - size and x < screenX + size and y > screenY - size and y < screenY + size then
            hovered = i
        end
    end

    -- Handle mousedrag
    if love.mouse.isDown(1) then
        local x,y = love.mouse.getPosition()
        if oldx == nil then
            oldx = x
            oldy = y
        else
            if x ~= oldx or y ~= oldy then
                if (scene == "galaxy") then
                    galaxyx = galaxyx + x - oldx
                    galaxyy = galaxyy + y - oldy
                end
            end
            oldx = x
            oldy = y
        end
    else
        oldx = nil
        oldy = nil
    end

end

function GalaxyScene:draw()

    shipScreenX = galaxyx + galaxy.stars[game.myship.loc].x * zoom
    shipScreenY = galaxyy + galaxy.stars[game.myship.loc].y * zoom

    if selected ~= nil then
        selectedScreenX = galaxyx + galaxy.stars[selected].x * zoom
        selectedScreenY = galaxyy + galaxy.stars[selected].y * zoom
    end

    for i,v in pairs(displayed) do
        local size = 1 + zoom * .2
        local screenX = galaxyx + v.x * zoom
        local screenY = galaxyy + v.y * zoom
        love.graphics.setFont(smallfont)
        love.graphics.setColor(.8, .8, .8)
    
        -- Show selections or hover indications
        if selected == i then
            love.graphics.setFont(smallfont)
            love.graphics.setColor(1, 1, 0)
            if v.built then 
                love.graphics.print(i .. ":" .. #v.planets .. "/" .. v:moonCount(), screenX-25, screenY+9)
            end
            love.graphics.circle('line', screenX, screenY, galaxy.spacing * zoom)
        elseif hovered == i then
            love.graphics.setFont(smallfont)
            love.graphics.setColor(.5, 1, .5)
            if v.built then 
                love.graphics.print(i .. ":" .. #v.planets .. "/" .. v:moonCount(), screenX-25, screenY+9)
            end
            love.graphics.circle('line', screenX, screenY, galaxy.spacing * zoom)
        elseif v.built then 
            love.graphics.print(i .. ":" .. #v.planets .. "/" .. v:moonCount(), screenX-25, screenY+9)
        end
    
        -- Draw possible travel routes
        if inRange[i] then
            if hovered == i then
                love.graphics.setLineWidth(2);
                love.graphics.setColor(math.random(), math.random(), 1)
                love.graphics.line(screenX, screenY, shipScreenX, shipScreenY)
            else
                love.graphics.setLineWidth(1);
                love.graphics.setColor(.5, 1, .5)
                dashedLine(screenX, screenY, shipScreenX, shipScreenY)
            end
        end

        -- Draw ship
        if game.myship.loc == i then
            love.graphics.setColor(.5, .5, 1)
            love.graphics.setLineWidth(2)
            love.graphics.rectangle("fill", screenX + 3 * zoom / 2, screenY -3 * zoom / 2, 5 * zoom , 2 * zoom)
        end

        -- Render the actual star
        for rings = 0, 1, .1 do
            love.graphics.setColor(v.color1[1] + rings - math.random() * .7, v.color1[2] + rings - math.random() * .7, v.color1[3] + rings - math.random() * .7)
            love.graphics.circle('fill', screenX, screenY, math.max(1, 1 * zoom/(2 + rings)))
        end

    end

    -- draw the black hole in the middle
    rings = 10 + sunsize / 3
    enhancer = 0.01 + (math.random() * 0.04 / (sunsize / 5))
    for i = rings, 1, -1 do
        love.graphics.setColor(0/i + enhancer * (rings-i), 1/i + enhancer * (rings-i), 0/i + enhancer * (rings-i))
        love.graphics.circle('fill', galaxyx, galaxyy, sunsize + i)
        love.graphics.setColor(0,0,0)
        love.graphics.circle('fill', galaxyx, galaxyy, sunsize - 1)
    end

end

function GalaxyScene:mousepressed(x,y,button)
    
    -- Handle solar system selection
    for i,v in pairs(displayed) do
        local size = galaxy.spacing * zoom
        local screenX = galaxyx + v.x * zoom
        local screenY = galaxyy + v.y * zoom
        if x > screenX - size and x < screenX + size and y > screenY - size and y < screenY + size then
            if button == 1 then 
                selected = i
                local time = love.timer.getTime()
                if time < lastClick + clickInterval then
                    SolarScene:load()
                end
                lastClick = time
                goto continue
            elseif button == 2 then
                selected = i
                game.myship.loc = i 
                SolarScene:load()
                goto continue
            end
        end
    end
    if button == 2 then
        selected = nil
    end

    ::continue::
end

function GalaxyScene:wheelmoved(x,y)

    -- Update zoom level
    updateZoom = 1
    if (y > 0 and zoom < 20) then
        updateZoom = 1.20
        zoom = zoom * 1.2
        sunsize = sunsize * 1.2
    elseif (y < 0 and zoom > .5) then
        updateZoom = .8
        zoom = zoom * .8
        sunsize = sunsize * .8
    end
    
    -- Zoom to cursor
    x, y = love.mouse.getPosition()
    dirToGalaxy = getDir(x, y, galaxyx, galaxyy)
    distToGalaxy = getDistance(x, y, galaxyx, galaxyy)
    newDist = distToGalaxy * updateZoom
    galaxyx = x + math.sin(math.rad(dirToGalaxy)) * newDist
    galaxyy = y - math.cos(math.rad(dirToGalaxy)) * newDist

end

function GalaxyScene:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end
