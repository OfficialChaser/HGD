Level = {}

-- Example: each level is a table
Level.levels = {
    [1] = {
        ballStart = {x = 100, y = 185},
        hole = {x = 540, y = 185},
        walls = {
            {x = 50,  y = 110, w = 540, h = 12},
            {x = 50,  y = 250, w = 540, h = 12},
            {x = 50,  y = 110, w = 12,  h = 152},
            {x = 578, y = 110, w = 12,  h = 152}
        },
        par = 2
    },
    [2] = {
        ballStart = {x = 100, y = 270},
        hole = {x = 540, y = 140},
        walls = {
            {x = 268,  y = 70, w = 320, h = 12},
            {x = 50,  y = 330, w = 350, h = 12},
            {x = 50,  y = 200, w = 230, h = 12},
            {x = 400,  y = 200, w = 190, h = 12},
            {x = 268,  y = 70, w = 12,  h = 142},
            {x = 50,  y = 200, w = 12,  h = 142},
            {x = 400, y = 200, w = 12,  h = 142},
            {x = 778, y = 200, w = 12,  h = 142},
            {x = 580,  y = 70, w = 12,  h = 142},
        },
        par = 2
    }
}

function Level:get(levelNumber)
    return self.levels[levelNumber]
end

return Level
