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
    zoom = 30
    lastClick = 0
    clickInterval = .2

    GalaxyScene:init(10000, { AutopilotButton })
    local _, inRangeStars = galaxy:starsInRange(200, 0, 0)
    game.myship = Ship:new(inRangeStars[math.random(1, #inRangeStars)].id)
    game.plottedRoutes = {}
    GalaxyScene:centerOn(game.myship.loc)

    GalaxyScene:load()

end

function love.update(dt)
    scenes[game.scene]:update(dt)
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
            v:mousepressed(x, y, button)
        end
    end
    scenes[game.scene]:mousepressed(x,y,button)
end

function love.keypressed(key, scancode, isrepeat)
    scenes[game.scene]:keypressed(key, scancode, isrepeat)
end
