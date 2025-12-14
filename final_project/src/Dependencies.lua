Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/StateMachine'
require 'src/states/StartState'
require 'src/states/PlayState'

Ball = require 'src/entities/Ball'

-- Background
TILE_SIZE = 32

LIGHT_GREEN = {0.65, 0.85, 0.65, 1}
DARK_GREEN  = {0.45, 0.75, 0.45, 1}

function drawCheckeredBackground()
    for y = 0, VIRTUAL_HEIGHT, TILE_SIZE do
        for x = 0, VIRTUAL_WIDTH, TILE_SIZE do
            if ((x / TILE_SIZE + y / TILE_SIZE) % 2 == 0) then
                love.graphics.setColor(LIGHT_GREEN)
            else
                love.graphics.setColor(DARK_GREEN)
            end

            love.graphics.rectangle('fill', x, y, TILE_SIZE, TILE_SIZE)
        end
    end
end