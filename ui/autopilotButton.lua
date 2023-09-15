require("ui.button")
require("scenes.warp")

AutopilotButton = Button:new(91, 95, 8, 4, "Next Waypoint", { 1, 1, .5 }, { .2, .2, .5})

function AutopilotButton:update(dt)
    if game.myship.route and #game.myship.route > 1 then
        self.active = true
    else
        self.active = false
    end
end

function AutopilotButton:clicked(x, y, button)
    if button == 1 then
        self.isClicked = true
        WarpScene:load(game.myship.route[1], game.myship.route[2])
        game.myship:moveTo(game.myship.route[2])
        table.remove(game.myship.route, 1)
        if #game.myship.route == 1 then
            game.myship.route = nil
        end
    end
end
