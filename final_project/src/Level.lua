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
    },
    [3] = {
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
        par = 3,
        gravity = { x = 0, y = 200 }
    },
    [4] = {
        ballStart = {x = 100, y = 200},
        hole = {x = 550, y = 200},
        walls = {
            -- Outer rectangle
            {x = 50,  y = 100, w = 540, h = 12, rotation = 0}, -- top
            {x = 50,  y = 300, w = 540, h = 12, rotation = 0}, -- bottom
            {x = 50,  y = 100, w = 12,  h = 212, rotation = 0}, -- left
            {x = 578, y = 100, w = 12,  h = 212, rotation = 0}, -- right

            -- Middle horizontal plank
            {x = 200, y = 180, w = 200, h = 12, rotation = 0},

            -- Slanted ramp to the right
            {x = 400, y = 150, w = 150, h = 12, rotation = 40}, -- -30 degrees

            -- Slanted ramp to the left
            {x = 420, y = 230, w = 120, h = 12, rotation = 30}, -- 30 degrees

            -- Near-hole horizontal plank
            {x = 450, y = 200, w = 100, h = 12, rotation = 0},
        },
        par = 3
    }

}

function Level:get(levelNumber)
    return self.levels[levelNumber]
end

return Level
