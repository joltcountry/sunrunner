require ("ui.simpleFrame")

StarFrame = SimpleFrame:new(80, 2, 19, 50, { .7, .7, .7 }, {.0, .2, .2})

function StarFrame:update(dt, scene)
    if (scene.state.hovered) then self.active = true else self.active = false end
end

function StarFrame:render(scene)
    if (scene.state.hovered) then
        local star = galaxy.stars[scene.state.hovered]
        love.graphics.setFont(mediumfont)
        love.graphics.setColor(1,1,1)
        if not star.built then
            love.graphics.setColor(1,.5,.5)
            self:printCentered("Unexplored", self.height / 2 - mediumfont:getHeight("Unexploed") / 2)
        else 
            self:printCentered(star.name, 5)
            self:line(30, 40, self.width - 30, 40)
            love.graphics.setColor(star.color1)
            self:circle("fill", self.width/2, 95, 40)
            love.graphics.setColor(.7,.7,.7)
            love.graphics.setLineWidth(1)
            self:line(self.width / 2, 147, self.width / 2, 425)
            love.graphics.setColor(1, 1, 1)

            -- draw planets
            for i = 1, 9 do
                local v = star:getPlanetAtOrbit(i)
                if v then
                    self:drawImage(planetImages[v.type], self.width / 2 - planetImages[v.type]:getWidth() * .2 / 2, 123 + i * 30, 0, .2)
                    -- draw moons
                    love.graphics.setColor(.6, .6, .6)
                    for m = 1, #v.moons do
                        self:circle("fill", self.width / 2 - 15 - (m * 15), 135 + i * 30, 5)
                    end
                else
                    love.graphics.setColor(.7,.7,.7)
                    love.graphics.setLineWidth(1)
                    self:line(self.width / 2 - 5, 135 + i * 30, self.width / 2 + 5, 135 + i * 30)
                end
            end

                
        end
    end
end
