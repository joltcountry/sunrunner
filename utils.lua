function getDistance(sourceX, sourceY, targetX, targetY)
    local dx = sourceX - targetX
    local dy = sourceY - targetY
    return math.sqrt ( dx * dx + dy * dy )
end