require 'obj.planet'
require 'obj.solarSystem'
require 'utils'
require 'scenes'

function love.load()

	font48 = love.graphics.newFont(48)
	font32 = love.graphics.newFont(32)
	font18 = love.graphics.newFont(18)
	math.randomseed(os.time())
    love.window.setMode(1920,1080);
	love.graphics.setBackgroundColor(.05, .05, .05)
	love.window.setTitle('Sunrunner')
	gamestate = { scene = Scenes.mainMenu }
	objects = {}

    TITLE = 'Sunrunner'

    sol = SolarSystem:new('Lovetrade')

    for i=1, 8 do 
        newPlanet = Planet:new('Planet'..i)
        newPlanet.distanceFromSun = i+3
        sol:addPlanet(newPlanet)
    end

    Scenes.solarSystem.solarSystem = sol

end

function love.draw()

    gamestate.scene:draw();
    gamestate.scene:drawButtons();

end

function love.update( dt )
    for i,v in ipairs(sol.planets) do
        v.directionFromSun = v.directionFromSun + v.orbitSpeed * dt / 5
    end
end

function love.mousepressed(x, y, i)
    if (gamestate.scene.mousepressed) then
        gamestate.scene:mousepressed(x, y, i)
    end
    for i,v in ipairs(gamestate.scene.buttons) do
        v:mousepressed(x, y, i)
    end
end
