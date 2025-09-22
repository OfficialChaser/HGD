ScoreState = Class{__includes = BaseState}

high_score = 0

function ScoreState:enter(params)
    self.score = params.score
    if self.score > high_score then
        high_score = self.score
    end
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oh no! You lost!', 0, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Score: ' .. tostring(high_score), 0, VIRTUAL_HEIGHT / 2 + 12, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, VIRTUAL_HEIGHT / 2 + 26, VIRTUAL_WIDTH, 'center')
end