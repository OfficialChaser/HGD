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
        ballStart = {x = 80, y = 190},
        hole = {x = 160, y = 290},
        walls = {
            -- Outer rectangle
            {x = 20,  y = 65, w = 600, h = 12}, -- top
            {x = 20,  y = 338, w = 600, h = 12}, -- bottom
            {x = 20,  y = 65, w = 12,  h = 285}, -- left
            {x = 610, y = 65, w = 12,  h = 285}, -- right

            -- Horizontals
            {x = 20, y = 230, w = 200, h = 12},
            {x = 210, y = 150, w = 188, h = 12},

            -- Verticals
            {x = 210,  y = 150, w = 12,  h = 92},
            {x = 388,  y = 150, w = 12,  h = 92},
            {x = 298,  y = 258, w = 12,  h = 92},

            -- Diagonals
            {x = 11, y = 103, w = 106, h = 12, rotation = -45},
            {x = 531, y = 100, w = 100, h = 12, rotation = 45},
            {x = 528, y = 300, w = 104, h = 12, rotation = -45},
            {x = 288, y = 310, w = 80, h = 12, rotation = 45},
            {x = 318, y = 181, w = 90, h = 12, rotation = 45},
            {x = 202, y = 181, w = 90, h = 12, rotation = -45},
            {x = 240, y = 310, w = 80, h = 12, rotation = -45},
        },
        par = 3
    },
    [4] = {
        ballStart = {x = 100, y = 185},
        hole = {x = 540, y = 185},
        walls = {
            -- Outer Box
            {x = 50,  y = 110, w = 540, h = 12},
            {x = 50,  y = 250, w = 540, h = 12},
            {x = 50,  y = 110, w = 12,  h = 152},
            {x = 578, y = 110, w = 12,  h = 152},

            -- Verticals
            {x = 220,  y = 110, w = 12,  h = 50},
            {x = 220,  y = 212, w = 12,  h = 50},
            {x = 420,  y = 110, w = 12,  h = 20},
            {x = 420,  y = 180, w = 12,  h = 82},

            -- Diagonals
            {x = 354, y = 230, w = 80, h = 12, rotation = -30},
        },
        par = 2,
        gravity = { x = 0, y = 400 }
    },
    [5] = {
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

            -- Verticals
            {x = 268,  y = 260, w = 12,  h = 82},

            -- Diagonals
            {x = 202, y = 310, w = 80, h = 12, rotation = -30},
        },
        par = 3,
        gravity = { x = 0, y = 200 }
    },
    [6] = {
        ballStart = {x = 80, y = 180},
        hole = {x = 110, y = 318},
        walls = {
            -- Outer rectangle
            {x = 20,  y = 65, w = 600, h = 12}, -- top
            {x = 20,  y = 338, w = 600, h = 12}, -- bottom
            {x = 20,  y = 65, w = 12,  h = 285}, -- left
            {x = 610, y = 65, w = 12,  h = 285}, -- right

            -- Horizontals
            {x = 20, y = 230, w = 200, h = 12},
            {x = 210, y = 150, w = 188, h = 12},

            -- Verticals
            {x = 210,  y = 150, w = 12,  h = 92},
            {x = 388,  y = 150, w = 12,  h = 92},
            {x = 298,  y = 258, w = 12,  h = 92},

            -- Diagonals
            {x = 11, y = 103, w = 106, h = 12, rotation = -45},
            {x = 531, y = 100, w = 100, h = 12, rotation = 45},
            {x = 528, y = 300, w = 104, h = 12, rotation = -45},
            {x = 288, y = 310, w = 80, h = 12, rotation = 45},
            {x = 318, y = 181, w = 90, h = 12, rotation = 45},
            {x = 202, y = 181, w = 90, h = 12, rotation = -45},
            {x = 240, y = 310, w = 80, h = 12, rotation = -45},
        },
        par = 3,
        gravity = { x = 0, y = 200 }
    },
    [7] = {
        ballStart = {x = 100, y = 185},
        hole = {x = 540, y = 185},
        walls = {
            {x = 50,  y = 110, w = 540, h = 12},
            {x = 50,  y = 250, w = 540, h = 12},
            {x = 50,  y = 110, w = 12,  h = 152},
            {x = 578, y = 110, w = 12,  h = 152}
        },
        par = 2,

        objects = {
        -- Rectangle
        {
            type = 'rect',
            x = 500, y = 190,
            w = 24, h = 48,
            color = {0.8, 0.2, 0.2},
            density = 1,
            restitution = 0.2
        },

            -- Circles
            {
                type = 'circle',
                x = 310, y = 140,
                radius = 16,
                color = {0.2, 0.4, 0.9},
                density = 0.3,
                restitution = 0.6
            },
            {
                type = 'circle',
                x = 310, y = 186,
                radius = 16,
                color = {0.4, 0.2, 0.6},
                density = 0.3,
                restitution = 0.6
            },
            {
                type = 'circle',
                x = 310, y = 230,
                radius = 16,
                color = {0.3, 0.6, 0.2},
                density = 0.3,
                restitution = 0.6
            }
        }
    },
    [8] = {
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

        par = 2,

        objects = {
            -- Heavy blocker (forces repositioning)
            {
                type = 'rect',
                x = 300, y = 235,
                w = 36, h = 36,
                color = {0.7, 0.3, 0.2},
                density = 2.5,
                restitution = 0.1
            },

            -- Light pinball-style bumpers
            {
                type = 'circle',
                x = 300, y = 165,
                radius = 14,
                color = {0.2, 0.6, 0.9},
                density = 0.1,
                restitution = 0.9
            },
            {
                type = 'circle',
                x = 360, y = 195,
                radius = 14,
                color = {0.2, 0.6, 0.9},
                density = 0.1,
                restitution = 0.9
            },

            -- Risk / reward deflector near the hole
            {
                type = 'rect',
                x = 485, y = 160,
                w = 20, h = 60,
                color = {0.9, 0.8, 0.2},
                density = 0.6,
                restitution = 0.4
            }
        }
    },
    [9] = {
        ballStart = {x = 80, y = 180},
        hole = {x = 110, y = 318},

        walls = {
            -- Outer rectangle
            {x = 20,  y = 65,  w = 600, h = 12},
            {x = 20,  y = 338, w = 600, h = 12},
            {x = 20,  y = 65,  w = 12,  h = 285},
            {x = 610, y = 65,  w = 12,  h = 285},

            -- Core maze
            {x = 20,  y = 230, w = 200, h = 12},
            {x = 210, y = 150, w = 188, h = 12},

            {x = 210, y = 150, w = 12, h = 92},
            {x = 388, y = 150, w = 12, h = 92},
            {x = 298, y = 258, w = 12, h = 92},

            {x = 288, y = 310, w = 80, h = 12, rotation = 45},
            {x = 202, y = 181, w = 90, h = 12, rotation = -45},
            {x = 318, y = 181, w = 90, h = 12, rotation = 45},
            {x = 528, y = 300, w = 104, h = 12, rotation = -45},
        },

        par = 4,

        objects = {
            -- Heavy gravity-controlled block (main puzzle)
            {
                type = 'rect',
                x = 300, y = 120,
                w = 42, h = 42,
                color = {0.75, 0.25, 0.25},
                density = 3.0,
                restitution = 0.05
            },

            -- Secondary lighter block (timing + positioning)
            {
                type = 'rect',
                x = 460, y = 280,
                w = 28, h = 28,
                color = {0.9, 0.6, 0.2},
                density = 0.8,
                restitution = 0.2
            },

            -- Single bumper (less chaos, more intention)
            {
                type = 'circle',
                x = 260, y = 200,
                radius = 14,
                color = {0.2, 0.6, 0.9},
                density = 0.2,
                restitution = 0.85
            },

            {
                type = 'rect',
                x = 160, y = 280,
                w = 14, h = 14,
                color = {0.6, 0.6, 0.9},
                density = 0.2,
                restitution = 0.85
            },
            {
                type = 'rect',
                x = 160, y = 300,
                w = 14, h = 14,
                color = {0.6, 0.3, 0.9},
                density = 0.2,
                restitution = 0.85
            },
            {
                type = 'rect',
                x = 160, y = 330,
                w = 14, h = 14,
                color = {0.1, 0.3, 0.8},
                density = 0.2,
                restitution = 0.85
            },
        },

        gravity = { x = 0, y = 300 }
    }


    


}

function Level:get(levelNumber)
    return self.levels[levelNumber]
end

return Level
