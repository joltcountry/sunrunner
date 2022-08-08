require 'obj.button'

local mainMenuButton = Button:new('Main Menu', 300,1030, function()
    gamestate.scene = Scenes.mainMenu
end)

local solarSystemButton = Button:new('Solar System', 600,1030, function()
    gamestate.scene = Scenes.solarSystem
end)

local dockedButton = Button:new('Docked', 900,1030, function()
    gamestate.scene = Scenes.docked
end)

local shipButton = Button:new('Ship', 1200,1030, function()
    gamestate.scene = Scenes.ship
end)

local starmapButton = Button:new('Starmap', 1500,1030, function()
    gamestate.scene = Scenes.starmap
end)

local newGameButton = Button:new('New Game', 850, 500, function()
    gamestate.scene = Scenes.solarSystem

    sol = SolarSystem:new('Lovetrade')

    for i=1, 8 do 
        newPlanet = Planet:new('Planet'..i)
        newPlanet.distanceFromSun = i+3
        sol:addPlanet(newPlanet)
    end

    Scenes.solarSystem.solarSystem = sol
    gamestate.shipLocation = nil
end)

local exitButton = Button:new('Exit Game', 850, 600, function()
    love.event.quit()
end)

Buttons = {
    mainMenu = mainMenuButton,
    solarSystem = solarSystemButton,
    docked = dockedButton,
    ship = shipButton,
    starmap = starmapButton,
    newGame = newGameButton,
    exit = exitButton
}