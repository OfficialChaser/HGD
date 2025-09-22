PauseState = Class{__includes = BaseState}

function PauseState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf("Game Paused\nPress Enter to Resume", 0, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, 'center')
end

function update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end