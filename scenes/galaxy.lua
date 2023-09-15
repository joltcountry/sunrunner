require "obj.galaxy"
require "utils"
require "obj.scene"
require "ui.autopilotButton"
require "ui.cancelRouteButton"

GalaxyScene = Scene:new({ 
    AutopilotButton,
    CancelRouteButton
 })
local hovered

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
    game.scene = "galaxy"
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
    for i,v in ipairs(galaxy.stars) do
        if zoom < 5 then
            v.dir = v.dir + .5 * dt
        end
        v.x = math.sin(math.rad(v.dir)) * v.dist
        v.y = -math.cos(math.rad(v.dir)) * v.dist
        local screenX = galaxyx + v.x * zoom
        local screenY = galaxyy + v.y * zoom
        if screenX > 0 - width / 2 and screenX < width + width/2 and screenY > 0 - height/2 and screenY < height + height/2 then
            displayed[i] = v
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
                if (game.scene == "galaxy") then
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

    shipScreenX, shipScreenY = galaxy:screenPos(game.myship.loc)

    local ranges = { 
        { dist = game.myship.plottingRange, fillColor = {.1,0,.1}, lineColor = {.2,0,.2} },
        { dist = game.myship.scanningRange, fillColor = {0,0,.1}, lineColor = {0,0,.4} },
        { dist = game.myship.travelRange, fillColor = {0,.1,0}, lineColor = {0,.4,0} }
    }
    table.sort(ranges, function (c1, c2) return c1.dist > c2.dist end )
    love.graphics.setLineWidth(1)
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
        if hovered == i then
            love.graphics.setFont(smallfont)
            love.graphics.setColor(.5, 1, .5)
            if v.built and zoom > 5 then 
                love.graphics.print(galaxy.stars[i].name, screenX-smallfont:getWidth(galaxy.stars[i].name) / 2, screenY+.8*zoom)
            end
            love.graphics.circle('line', screenX, screenY, galaxy.spacing * zoom)                
        elseif v.built and zoom > 5 then 
 --       else
            love.graphics.print(galaxy.stars[i].name, screenX-smallfont:getWidth(galaxy.stars[i].name) / 2, screenY+.8*zoom)
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

    if game.myship.route then
        if #game.myship.route > 1 then
            -- draw plotted route
            love.graphics.setLineWidth(1);
            love.graphics.setColor(math.random(), math.random(), 1)

            for node = 1, #game.myship.route - 1 do
                fromX = galaxyx + galaxy.stars[game.myship.route[node]].x * zoom
                fromY = galaxyy + galaxy.stars[game.myship.route[node]].y * zoom
                toX = galaxyx + galaxy.stars[game.myship.route[node+1]].x * zoom
                toY = galaxyy + galaxy.stars[game.myship.route[node+1]].y * zoom
                love.graphics.line(fromX, fromY, toX, toY)
            end
        else
            failedX, failedY = galaxy:screenPos(game.myship.route[1])
            love.graphics.setColor(.7, 0, 0)
            love.graphics.circle('line', failedX, failedY, galaxy.spacing * zoom)
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
                local time = love.timer.getTime()
                if time < lastClick + clickInterval then
                    SolarScene:load(hovered)
                end
                lastClick = time
                goto continue
            elseif button == 2 then
                if inRange[i] then
                    if i ~= game.myship.loc then
                        WarpScene:load(game.myship.loc, i)
                        game.myship.route = nil
                        game.myship:moveTo(i)
                    else 
                        SolarScene:load(game.myship.loc)
                    end
                    goto continue
                else
                    if not game.plottedRoutes[i] then
                        local route = galaxy:plotRoute(game.myship.loc, i)
                        game.plottedRoutes[i] = route
                    end
                    game.myship.route = game.plottedRoutes[i]
                end
            end
        end
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
