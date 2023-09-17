require("ui.button")
require("scenes.warp")

CancelRouteButton = Button:new(91, 90, 8, 4, "Cancel Route", { 1, 1, .5 }, { .2, .2, .5})

function CancelRouteButton:update(dt)
    if game.myship.route and #game.myship.route > 1 then
        self.active = true
    else
        self.active = false
    end
end

function CancelRouteButton:clicked(x, y, button)
    if button == 1 then
        game.myship.route = nil
    end
end