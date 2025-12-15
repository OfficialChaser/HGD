-- General
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

-- States
require 'src/StateMachine'
require 'src/states/BaseState' 
require 'src/states/StartState'
require 'src/states/PlayState'

-- Entities
Ball = require 'src/entities/Ball'
Hole = require 'src/entities/Hole'

-- Assets
big_font = love.graphics.newFont('fonts/PixelOperator8-Bold.ttf', 48)
reg_font = love.graphics.newFont('fonts/PixelOperator8-Bold.ttf', 16)
small_font = love.graphics.newFont('fonts/PixelOperator8-Bold.ttf', 8)

track1 = love.audio.newSource('sounds/track1.mp3', 'stream')
track2 = love.audio.newSource('sounds/track2.mp3', 'stream')
track3 = love.audio.newSource('sounds/track3.mp3', 'stream')

ball_drop = love.audio.newSource('sounds/ball_drop.mp3', 'static')
hit_wall = love.audio.newSource('sounds/hit_wall.wav', 'static')

-- Misc
require 'src/Level'
Transition = require 'src/Transition'

-- Background
backgroundOffsetX = 0
backgroundOffsetY = 0
backgroundScrollSpeedX = 20   -- pixels per second
backgroundScrollSpeedY = 30


TILE_SIZE = 32

LIGHT_GREEN = {0.62, 0.84, 0.55, 1}
DARK_GREEN  = {0.36, 0.68, 0.38, 1}

function drawCheckeredBackground()
    local tilesX = math.ceil(VIRTUAL_WIDTH / TILE_SIZE) + 1
    local tilesY = math.ceil(VIRTUAL_HEIGHT / TILE_SIZE) + 2  -- extra row for scrolling

    for row = 0, tilesY - 1 do
        for col = 0, tilesX - 1 do
            -- Determine color using integer indices
            local check = (col + row) % 2
            if check == 0 then
                love.graphics.setColor(LIGHT_GREEN)
            else
                love.graphics.setColor(DARK_GREEN)
            end

            -- Draw tile with offset
            local x = col * TILE_SIZE + backgroundOffsetX
            local y = row * TILE_SIZE + backgroundOffsetY - TILE_SIZE
            love.graphics.rectangle('fill', x, y, TILE_SIZE, TILE_SIZE)

            -- Optional: Draw tile borders for better visibility
            love.graphics.setColor(0, 0, 0, 0.05) 
            love.graphics.setLineWidth(4)
            love.graphics.rectangle('line', x, y, TILE_SIZE, TILE_SIZE)

        end
    end
end

