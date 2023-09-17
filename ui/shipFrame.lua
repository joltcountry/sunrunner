require ("ui.CRTFrame")

ShipFrame = CRTFrame:new(30, 90, 40, 9)

ShipFrame.on = true

function ShipFrame:render(scene)
    love.graphics.setFont(smallfont)
    love.graphics.setColor(.5, 1, .5)
    self:print("Location:", 5, 2)
    self:print("Warp range:", 5, 22)
    self:print("Scan range:", 5, 42)
    self:print("Plotting range:", 5, 62)
    self:print("Credits:", 550, 2)
    if (game.myship.route and #game.myship.route > 1) then
        self:print("Route plotted:", 250, 2)
        self:print("Next waypoint:", 250, 22)
    end
    love.graphics.setColor(0, .7, 0)
    self:print(galaxy.stars[game.myship.loc].name, 100, 2)
    self:print(game.myship.travelRange, 100, 22)
    self:print(game.myship.scanningRange, 100, 42)
    self:print(game.myship.plottingRange, 100, 62)
    self:print(game.credits, 600, 2)
    if (game.myship.route and #game.myship.route > 1) then
        local target = galaxy.stars[game.myship.route[#game.myship.route]]
        self:print(target.built and target.name or "Unexplored", 350, 2)
        self:print(galaxy.stars[game.myship.route[2]].name, 350, 22)
    end
end
