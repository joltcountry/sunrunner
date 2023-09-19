function getDir(sourceX, sourceY, targetX, targetY)
	return math.deg(math.atan2(targetY - sourceY, targetX - sourceX)) + 90
end

function getDistance(sourceX, sourceY, targetX, targetY)
    local dx = sourceX - targetX
    local dy = sourceY - targetY
    return math.sqrt ( dx * dx + dy * dy )
end

function dashedLine(x1, y1, x2, y2)
    local deltaX, deltaY = x2 - x1, y2 - y1
    local len = math.max (math.abs(deltaX), math.abs(deltaY))
  
    for iStep = 0, len do -- including first and last points
      if iStep % 8 > 3 then
        pingraph.points(x1 + deltaX * iStep/len, y1 + deltaY * iStep/len)
      end
    end
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end
