StartState = Class{__includes = BaseState}

function StartState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Press Enter to Start", 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
end

function StartState:keypressed(key)
    if key == 'return' then
        gStateMachine:change('play')
    end
end
