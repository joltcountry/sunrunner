function printThreeThings(a, b, c)
    print(a, b, c)
end

function returnTwoThings()
    return 2, 3
end

printThreeThings(returnTwoThings())  -- prints "1 2 nil"
printThreeThings(1, returnTwoThings())  -- prints "1 3 nil"
