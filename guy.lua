    
        --guydir = (guydir + 15 * dt) % 360

        -- draw guy
    -- x, y = love.mouse.getPosition()
    -- for startAngle = guydir, guydir + 359, 30 do
    --     love.graphics.setColor(.3, 1, .3)
    --     love.graphics.setLineWidth(1)
    --     angleToMouse = getDir(guyx, guyy, x, y)
    --     print(angleToMouse)
    --     endAngle = startAngle + 30
    --     if endAngle > 360 then
    --         startAngle = startAngle - 360
    --         endAngle = endAngle - 360
    --     end
    --     love.graphics.print(angleToMouse, 100, 100)
    --     love.graphics.print(startAngle, 100, 200 + startAngle / 2)
    --     love.graphics.print(endAngle, 100, 400 + startAngle / 2)

    --     if (getDistance(guyx, guyy, x, y) > 100 and getDistance(guyx, guyy, x, y) < 200) and angleToMouse > startAngle and angleToMouse < endAngle then
    --         love.graphics.setColor(.3, .3, 1)
    --         love.graphics.arc('fill',guyx,guyy, 200, math.rad(startAngle), math.rad(startAngle+30))
    --     end
    --     love.graphics.setColor(.3, 1, .3)
    --     love.graphics.arc('line',guyx,guyy, 200, math.rad(startAngle), math.rad(startAngle+30))
    --     love.graphics.setLineWidth(3)
    --     love.graphics.circle('line', guyx, guyy, 200)
    --     love.graphics.setColor(.1,.5,.1)
    --     love.graphics.circle('fill', guyx, guyy, 100)
    --     love.graphics.setColor(.3, 1, .3)
    --     love.graphics.circle('line', guyx, guyy, 100)
    -- end