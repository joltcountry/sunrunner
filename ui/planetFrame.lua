require ("ui.frame")

PlanetFrame = Frame:new(80, 2, 19, 50, { .7, .2, .7 }, {.2, 0, .2})

local romans = { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" }
function PlanetFrame:update(dt, scene)
    if scene.state.hovered then self.active = true else self.active = false end
end

function PlanetFrame:render(scene)
    if (scene.state.hovered) then
        local planet = scene.state.star.planets[scene.state.hovered]
        -- Draw planet window thing
        love.graphics.setFont(mediumfont)
        love.graphics.setColor(1,1,1)
        self:printCentered(scene.state.star.name .. " " .. romans[scene.state.hovered], 5)
        self:line(30, 40, self.width - 30, 40)
        love.graphics.setColor(1,1,1)
        local planetImage = planetImages[planet.type]
        self:drawImage(planetImage, self.width / 2 - planetImage:getWidth() / 2, 55)
        love.graphics.setColor(.4,.4,.4)
        love.graphics.setLineWidth(1)
        self:line(self.width / 2, 192, self.width / 2, 425)
        love.graphics.setColor(.8, .8, .8)
        if planet.moons then
            for i = 1, #planet.moons do
                self:circle("fill", self.width / 2, 215 + 35 * (i-1), 12)
            end
        end
    end
end
