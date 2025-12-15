Level = {}

-- Example: each level is a table
Level.levels = {
    [1] = {
        ballStart = {x = 100, y = 180},
        walls = {
            {x = 50,  y = 110, w = 540, h = 12},
            {x = 50,  y = 250, w = 540, h = 12},
            {x = 50,  y = 110, w = 12,  h = 140},
            {x = 578, y = 110, w = 12,  h = 140}
        }
    },
    [2] = {
        ballStart = {x = 100, y = 300},
        walls = {
            {x = 0,  y = 0,   w = 640, h = 12},
            {x = 0,  y = 360, w = 640, h = 12},
            {x = 0,  y = 0,   w = 12,  h = 360},
            {x = 640, y = 0,   w = 12,  h = 360},
            {x = 200, y = 100, w = 400, h = 12}, -- extra wall for level 2
        }
    }
}

function Level:get(levelNumber)
    return self.levels[levelNumber]
end

return Level
