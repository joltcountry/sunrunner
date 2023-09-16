width = 1600
height = 900

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

function love.load()

    game = {}
    planetImages = {}
    for i = 1,10 do
        planetImages[i] = love.graphics.newImage("assets/images/planets/planet" .. i .. ".png")
    end
    logo = love.graphics.newImage("assets/images/logo.png")

    local seedTime = os.time()
    print("seed: " .. seedTime)
    math.randomseed(seedTime)
    love.window.setMode(1600, 900)
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
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
    scenes[game.scene]:update(dt)
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            v:update(dt)
        end
    end
end

function love.draw()
    scenes[game.scene]:draw()
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            v:draw()
        end
    end

    love.graphics.setColor(1,1,1)
    love.graphics.draw(logo, 1, 1, 0, .4)
end

function love.wheelmoved(x, y)
    scenes[game.scene]:wheelmoved(x,y)
end

function love.mousepressed(x, y, button)
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            local interacted = v:mousepressed(x, y, button)
            if interacted then goto done end
        end
    end
    scenes[game.scene]:mousepressed(x,y,button)
    :: done ::
end

function love.keypressed(key, scancode, isrepeat)
    if scenes[game.scene].ui then
        for _,v in pairs(scenes[game.scene].ui) do
            local interacted = v:keypressed(key, scancode, isrepeat)
            if interacted then goto done end
        end
    end
    scenes[game.scene]:keypressed(key, scancode, isrepeat)
    :: done ::
end
