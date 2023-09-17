require ("ui.CRTFrame")

LeftFrame = CRTFrame:new(15, 74, 25 * 9/16, 25)

function LeftFrame:render(scene)

    love.graphics.setColor(0,.8,0)
    love.graphics.setFont(mediumfont)
    self:printCentered("TBD", self.height / 2)

end
