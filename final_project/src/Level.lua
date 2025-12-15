Level = {}

-- Example: each level is a table
Level.levels = {
    [1] = {
        ballStart = {x = 60, y = 180},
        walls = {
            {0, 0, 640, 0},
            {0, 360, 640, 360},
            {0, 0, 0, 360},
            {640, 0, 640, 360},
        },
        s = 1
    },
    [2] = {
        ballStart = {x = 100, y = 300},
        walls = {
            {0, 0, 640, 0},
            {0, 360, 640, 360},
            {0, 0, 0, 360},
            {640, 0, 640, 360},
            {200, 100, 400, 100}, -- extra wall for level 2
        }
    }
}

function Level:get(levelNumber)
    return self.levels[levelNumber]
end

return Level
