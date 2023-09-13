require "utils"

a = {12, 18, 3409, 23489, 34, 18, 349, 549, 123, 349, 238727}

for i = 1, #a do
    for j = i+2, #a do
        if a[i] == a[j] then
            print("snipping ".. a[i])
            for x = i+1, j do
                print ("trying to remove " .. x)
                table.remove(a, i+1)
            end
            print("snipped " .. a[i].. ", table is now "..dump(a))
        end
    end
end

print("finished, table is now "..dump(a))
