require "scenes.galaxy"
require "scenes.solar"
require "scenes.warp"
require "obj.ship"
require "ui.autopilotButton"

local scenes = {
    galaxy = GalaxyScene,
    solar = SolarScene,
    warp = WarpScene
}

function setResolution(w, h)
    width = w
    height = h
    for _,v in pairs(scenes) do
        if v.ui then
            for _,uiComponent in pairs(v.ui) do
                uiComponent:setDimensions(w, h)
            end
        end
    end
    love.window.setMode(w, h)
end

function setMode(mode)
    for _,v in pairs(scenes) do
        if v.ui then
            for _,uiComponent in pairs(v.ui) do
                uiComponent:setMode(mode)
            end
        end
    end
end

function love.load()

    game = { credits = 1000 }
    planetImages = {}
    for i = 1,10 do
        planetImages[i] = love.graphics.newImage("assets/images/planets/planet" .. i .. ".png")
    end
    logo = love.graphics.newImage("assets/images/logo.png")

    local seedTime = os.time()
    print("seed: " .. seedTime)
    math.randomseed(seedTime)
    setResolution(1600, 900)
    setMode("amber")
    bigfont = love.graphics.newFont(36)
    smallfont = love.graphics.newFont(12)
    mediumfont = love.graphics.newFont(24)
    zoom = 10
    lastClick = 0
    clickInterval = .2

    GalaxyScene:init(10000)
    local _, inRangeStars = galaxy:starsInRange(100, 0, 0)
    game.myship = Ship:new(inRangeStars[math.random(1, #inRangeStars)].id)
    game.plottedRoutes = {}
    GalaxyScene:centerOn(game.myship.loc)

    GalaxyScene:load()

end

function love.update(dt)
    local uiHasMouse = false
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            v:update(dt, scenes[game.scene])
            if v:hasMouse() then
                uiHasMouse = true
            end
        end
    end
    scenes[game.scene]:update(dt, not uiHasMouse)
end

function love.draw()
    scenes[game.scene]:draw()
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            v:draw(scenes[game.scene])
        end
    end

    love.graphics.setColor(1,1,1)
    love.graphics.draw(logo, 1, 1, 0, .4)
end

function love.wheelmoved(x, y)
    local uiHasMouse = false
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            if v:hasMouse() then
                uiHasMouse = true
                v:wheelmoved(x, y, scenes[game.scene])
            end
        end
    end
    if not uiHasMouse then
        scenes[game.scene]:wheelmoved(x,y, scenes[game.scene])
    end
end

function love.mousepressed(x, y, button)
    local uiHasMouse = false
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            if v:hasMouse() then
                uiHasMouse = true
                v:mousepressed(x, y, button, scenes[game.scene])
            end
        end
    end
    if not uiHasMouse then
        scenes[game.scene]:mousepressed(x,y,button)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            v:keypressed(key, scancode, isrepeat, scenes[game.scene])
        end
    end
    scenes[game.scene]:keypressed(key, scancode, isrepeat)
end
