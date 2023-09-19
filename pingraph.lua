pingraph = {}

setmetatable(pingraph, { __index = function(self, key) return love.graphics[key] end } )

function pingraph.draw(img, x, y, rot, scale)
    rot = rot or 0
    scale = scale or 1
    love.graphics.draw(img, x, y, rot, scale * game.scale)
end

-- function pingraph.line(startX, startY, endX, endY)
--     love.graphics.line(startX * game.scale, startY * game.scale, endX * game.scale, endY * game.scale)
-- end

-- function pingraph.circle(mode, x, y, radius)
--     love.graphics.circle(mode, x * game.scale, y * game.scale, radius * game.scale)
-- end

-- function pingraph.setLineWidth(w)
--     love.graphics.setLineWidth(w * game.scale)
-- end

-- -- function pingraph.setScissor(x, y, w, h)
-- --     if x then
-- --         love.graphics.setScissor(x * game.scale, y * game.scale, w * game.scale, h * game.scale)
-- --     else
-- --         love.graphics.setScissor()
-- --     end
-- -- end

-- function pingraph.print(msg, x, y)
--     love.graphics.print(msg, x * game.scale, y * game.scale)
-- end