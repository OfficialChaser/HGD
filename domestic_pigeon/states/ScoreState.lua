ScoreState = Class{__includes = BaseState}

local GOLD_MEDAL_IMAGE = love.graphics.newImage('graphics/gold_medal.png')
local SILVER_MEDAL_IMAGE = love.graphics.newImage('graphics/silver_medal.png')
local BRONZE_MEDAL_IMAGE = love.graphics.newImage('graphics/bronze_medal.png')

local MEDAL_FRAME = love.graphics.newImage('graphics/medal_frame.png')


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
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    love.graphics.setFont(flappyFont)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Game Over...', 0, VIRTUAL_HEIGHT / 10, VIRTUAL_WIDTH, 'center')

    local medal
    local medalName
    if self.score >= 50 then
        medal = GOLD_MEDAL_IMAGE
        medalName = 'Gold'
    elseif self.score >= 30 then
        medal = SILVER_MEDAL_IMAGE
        medalName = 'Silver'
    elseif self.score >= 10 then
        medal = BRONZE_MEDAL_IMAGE
        medalName = 'Bronze'
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(MEDAL_FRAME, (VIRTUAL_WIDTH - MEDAL_FRAME:getWidth()) / 2, (VIRTUAL_HEIGHT - MEDAL_FRAME:getHeight()) / 2 - 12)
    local text = ""
    if medal then
        local medalX = (VIRTUAL_WIDTH / 2) - (medal:getWidth() / 2)
        local medalY = VIRTUAL_HEIGHT / 2 - medal:getHeight() / 2 - 12
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(medal, medalX, medalY)
        text = string.format("For achieving a score of %d, you got a %s medal!", self.score, medalName)
    else
        text = "Score more points to earn a medal!"
    end
    love.graphics.setFont(smallFont)
    love.graphics.printf(text, 0, VIRTUAL_HEIGHT / 2 + 5, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('High Score: ' .. tostring(high_score), 0, VIRTUAL_HEIGHT / 2 + 32, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, VIRTUAL_HEIGHT / 2 + 52, VIRTUAL_WIDTH, 'center')
end