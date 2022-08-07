require 'utils'
require 'obj.planet'
require 'obj.solarSystem'

function love.load()

	font48 = love.graphics.newFont(48)
	font18 = love.graphics.newFont(18)
	math.randomseed(os.time())
    love.window.setMode(1920,1080);
	love.graphics.setBackgroundColor(.05, .05, .05)
	love.window.setTitle('Sunrunner')
	gamestate = { scene = 'solarmap' }
	objects = {}

    TITLE = 'Sunrunner'

    sol = SolarSystem:new()

    for i=1, 10 do 
        newPlanet = Planet:new()
        newPlanet.distanceFromSun = i+3
        sol:addPlanet(newPlanet)
    end

end

function love.draw()

	love.graphics.setFont(font48);
    love.graphics.setColor(.5,.9, .5)
    if (gamestate.scene == 'mainmenu') then
        love.graphics.printf(TITLE, 10, 10, love.graphics.getWidth(), 'center');
    elseif (gamestate.scene == 'solarmap') then
        sol:draw()
    end

end

function love.update( dt )
    for i,v in ipairs(sol.planets) do
        v.directionFromSun = v.directionFromSun + v.orbitSpeed * dt / 5
    end
end