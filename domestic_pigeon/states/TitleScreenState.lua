TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    -- nothing
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Domestic Pigeon', 0, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 8, VIRTUAL_WIDTH, 'center')
end