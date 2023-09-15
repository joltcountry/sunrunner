require("ui.button")
require("scenes.warp")

AutopilotButton = Button:new(90, 95, 8, 4, "Autopilot")

function AutopilotButton:clicked(button)
    if game.myship.route and button == 1 then
        self.isClicked = true
        game.myship:moveTo(game.myship.route[2])
        WarpScene:load()
        table.remove(game.myship.route, 1)
        if #game.myship.route == 1 then
            game.myship.route = nil
        end
    end
end
