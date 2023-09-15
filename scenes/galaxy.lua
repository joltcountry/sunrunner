require "obj.galaxy"
require "utils"
require "obj.scene"
require "ui.autopilotButton"

GalaxyScene = Scene:new({ AutopilotButton })

function GalaxyScene:init(numOfStars, ui)
    galaxy = Galaxy:new(numOfStars)
    galaxyx = width/2
    galaxyy = height/2
    sunsize = 40
end

function GalaxyScene:centerOn(loc)
    local x, y = galaxy:xy(loc)
    galaxyx = -x * zoom + width/2
    galaxyy = -y * zoom + height/2
end

function GalaxyScene:load()
    scene = "galaxy"
    --self:centerOn(game.myship.loc)
end

function GalaxyScene:update(dt)

    displayed = {}

    inRange = {}
    inScanningRange = {}
    shipX, shipY = galaxy:getLocation(game.myship.loc)
    inRange = galaxy:starsInRange(game.myship.travelRange, galaxy:xy(game.myship.loc))
    inScanningRange = galaxy:starsInRange(game.myship.scanningRange, galaxy:xy(game.myship.loc))

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
        if inScanningRange[i] then
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

    if selected and selected ~= game.myship.loc and galaxy:getDistance(game.myship.loc, selected) <= game.myship.plottingRange then
        if not game.plottedRoutes[selected] then
            route = {}
            galaxy:plotRoute(game.myship.loc, selected, route)
            game.plottedRoutes[selected] = route
            game.myship.route = route
        end
    end

end

function GalaxyScene:draw()

    shipScreenX, shipScreenY = galaxy:screenPos(game.myship.loc)

    if selected ~= nil then
        selectedScreenX, selectedScreenY = galaxy:screenPos(selected)
    end

    local ranges = { 
        { dist = game.myship.plottingRange, fillColor = {.1,0,.1}, lineColor = {.2,0,.2} },
        { dist = game.myship.scanningRange, fillColor = {0,0,.1}, lineColor = {0,0,.4} },
        { dist = game.myship.travelRange, fillColor = {0,.1,0}, lineColor = {0,.4,0} }
    }
    table.sort(ranges, function (c1, c2) return c1.dist > c2.dist end )
    for _,v in pairs(ranges) do
        love.graphics.setColor(v.fillColor)
        love.graphics.circle("fill", shipScreenX, shipScreenY, v.dist * zoom);
        love.graphics.setColor(v.lineColor)
        love.graphics.circle("line", shipScreenX, shipScreenY, v.dist * zoom);
    end

    for i,v in pairs(displayed) do
        local size = 1 + zoom * .2
        local screenX = galaxyx + v.x * zoom
        local screenY = galaxyy + v.y * zoom
        love.graphics.setFont(smallfont)
        love.graphics.setColor(.8, .8, .8)
    
        -- Show selections or hover indications
        love.graphics.setLineWidth(1);
        if selected == i then
            love.graphics.setFont(smallfont)
            love.graphics.setColor(1, 1, 0)
            if v.built and zoom > 3 then 
                love.graphics.print(i .. ":" .. #v.planets .. "/" .. v:moonCount(), screenX-25, screenY+9)
            end
            love.graphics.circle('line', screenX, screenY, galaxy.spacing * zoom)
        elseif hovered == i then
            love.graphics.setFont(smallfont)
            love.graphics.setColor(.5, 1, .5)
            if v.built and zoom > 3 then 
                love.graphics.print(i .. ":" .. #v.planets .. "/" .. v:moonCount(), screenX-25, screenY+9)
            end
            love.graphics.circle('line', screenX, screenY, galaxy.spacing * zoom)                
        elseif v.built and zoom > 3 then 
 --       else
            love.graphics.print(i .. ":" .. #v.planets .. "/" .. v:moonCount(), screenX-25, screenY+9)
            --love.graphics.print(i, screenX, screenY+9)
        end
    
        -- Draw possible travel routes
        if inRange[i] then
            if hovered == i then
                love.graphics.setLineWidth(1);
                love.graphics.setColor(math.random(), math.random(), 1)
                love.graphics.line(screenX, screenY, shipScreenX, shipScreenY)
            end
        end

        -- Draw ship
        if game.myship.loc == i then
            love.graphics.setColor(1,1,1)
            love.graphics.draw(game.myship.image, screenX+2, screenY-2, 0, zoom / 50)
        end

        -- Render the actual star
        for rings = 0, 1, .1 do
            love.graphics.setColor(v.color1[1] + rings - math.random() * .7, v.color1[2] + rings - math.random() * .7, v.color1[3] + rings - math.random() * .7)
            love.graphics.circle('fill', screenX, screenY, math.max(1, 1 * zoom/(2 + rings)))
        end

    end

    if selected and selected ~= game.myship.loc then

        -- draw plotted route
        love.graphics.setLineWidth(1);
        love.graphics.setColor(math.random(), math.random(), 1)

        if game.plottedRoutes[selected] then
            if #game.plottedRoutes[selected] > 1 then
                for node = 1, #game.plottedRoutes[selected] - 1 do
                    fromX = galaxyx + galaxy.stars[game.plottedRoutes[selected][node]].x * zoom
                    fromY = galaxyy + galaxy.stars[game.plottedRoutes[selected][node]].y * zoom
                    toX = galaxyx + galaxy.stars[game.plottedRoutes[selected][node+1]].x * zoom
                    toY = galaxyy + galaxy.stars[game.plottedRoutes[selected][node+1]].y * zoom
                    love.graphics.line(fromX, fromY, toX, toY)
                end
            else
                love.graphics.setColor(.7, 0, 0)
                love.graphics.circle('line', selectedScreenX, selectedScreenY, galaxy.spacing * zoom)
            end
        end
    end
    
    -- draw the black hole in the middle
    rings = math.max(20 * zoom / 3, .1)
    enhancer = math.random()
    
    for i = rings, 1, -1 do
        love.graphics.setColor(enhancer * (1-i/rings), 1-i/rings,enhancer * (1-i/rings))
        love.graphics.circle('fill', galaxyx, galaxyy, sunsize * zoom + i)
    end
    love.graphics.setColor(0,0,0)
    love.graphics.circle('fill', galaxyx, galaxyy, sunsize * zoom)

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
            elseif button == 2 and inRange[i] then
                selected = i
                if i ~= game.myship.loc then
                    game.myship:moveTo(i)
                    WarpScene:load()
                else 
                    SolarScene.load()
                end
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
    if (y > 0 and zoom < 30) then
        updateZoom = 1.20
        zoom = zoom * 1.2
    elseif (y < 0 and zoom > .5) then
        updateZoom = .8
        zoom = zoom * .8
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
