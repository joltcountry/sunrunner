require 'obj.scene'
require 'buttons'

local mainMenuScene = Scene:new()
local solarSystemScene = Scene:new()
local dockedScene = Scene:new()
local shipScene = Scene:new()
local starmapScene = Scene:new()

Scenes = {
    mainMenu = mainMenuScene,
    solarSystem = solarSystemScene,
    docked = dockedScene,
    ship = shipScene,
    starmap = starmapScene
}

function mainMenuScene:draw()
    love.graphics.setFont(font48);
    love.graphics.setColor(.5,.9, .5)
    love.graphics.printf(TITLE, 10, 10, love.graphics.getWidth(), 'center');
end

mainMenuScene:addButton(Buttons.newGame);
mainMenuScene:addButton(Buttons.exit);

function solarSystemScene:draw()
    self.solarSystem:draw()
    love.graphics.setFont(font48);
    love.graphics.setColor(.5,.9, .5)
    love.graphics.printf("Solar System: "..self.solarSystem.name, 10, 10, love.graphics.getWidth(), 'center');
end

function solarSystemScene:mousepressed(x, y, i)
    if (self.solarSystem.mousepressed) then
        self.solarSystem:mousepressed(x, y, i)
    end
end

solarSystemScene:addButton(Buttons.mainMenu);
solarSystemScene:addButton(Buttons.solarSystem);
solarSystemScene:addButton(Buttons.docked);
solarSystemScene:addButton(Buttons.ship);
solarSystemScene:addButton(Buttons.starmap);

function dockedScene:draw()
    love.graphics.setFont(font48);
    love.graphics.setColor(.5,.9, .5)
    if self.planet then
        love.graphics.printf("Docked at: "..self.planet.name, 10, 10, love.graphics.getWidth(), 'center');
    else
        love.graphics.printf("Not currently docked.", 10, 10, love.graphics.getWidth(), 'center');
    end
end

dockedScene:addButton(Buttons.mainMenu);
dockedScene:addButton(Buttons.solarSystem);
dockedScene:addButton(Buttons.docked);
dockedScene:addButton(Buttons.ship);
dockedScene:addButton(Buttons.starmap);

function shipScene:draw()
    love.graphics.setFont(font48);
    love.graphics.setColor(.5,.9, .5)
    love.graphics.printf("Ship Statistics", 10, 10, love.graphics.getWidth(), 'center');
end

shipScene:addButton(Buttons.mainMenu);
shipScene:addButton(Buttons.solarSystem);
shipScene:addButton(Buttons.docked);
shipScene:addButton(Buttons.ship);
shipScene:addButton(Buttons.starmap);

function starmapScene:draw()
    love.graphics.setFont(font48);
    love.graphics.setColor(.5,.9, .5)
    love.graphics.printf("Starmap", 10, 10, love.graphics.getWidth(), 'center');
end

starmapScene:addButton(Buttons.mainMenu);
starmapScene:addButton(Buttons.solarSystem);
starmapScene:addButton(Buttons.docked);
starmapScene:addButton(Buttons.ship);
starmapScene:addButton(Buttons.starmap);