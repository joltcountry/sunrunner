require "scenes.galaxy"
require "scenes.solar"
require "obj.ship"

local scenes = {
    galaxy = GalaxyScene,
    solar = SolarScene
}

function love.load()

    game = {}
    planetImages = {}
    for i = 1,10 do
        planetImages[i] = love.graphics.newImage("assets/images/planets/planet" .. i .. ".png")
    end

    math.randomseed(os.time())
    love.window.setMode(1600, 900)
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
    bigfont = love.graphics.newFont(36)
    smallfont = love.graphics.newFont(12)
    zoom = 1
    lastClick = 0
    clickInterval = .2

    GalaxyScene:init(10000)
    GalaxyScene:load()

    _, inRangeStars = galaxy:starsInRange(0, 0, 200)

    game.myship = Ship:new(inRangeStars[math.random(1, #inRangeStars)].id)
    print("Ship is at " .. game.myship.loc)

end

function love.update(dt)
    scenes[scene]:update(dt)
end

function love.draw()
    scenes[scene]:draw()
end

function love.wheelmoved(x, y)
    scenes[scene]:wheelmoved(x,y)
end

function love.mousepressed(x, y, button)
    scenes[scene]:mousepressed(x,y,button)
end

function love.keypressed(key, scancode, isrepeat)
    scenes[scene]:keypressed(key, scancode, isrepeat)
end
