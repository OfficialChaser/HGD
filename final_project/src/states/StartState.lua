StartState = Class{__includes = BaseState}

function StartState:render()

    -- Title
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(big_font)
    love.graphics.printf("MULLIGAN!", 0, VIRTUAL_HEIGHT / 3 - 6, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("MULLIGAN!", 4, VIRTUAL_HEIGHT / 3 - 10, VIRTUAL_WIDTH, 'center')

    -- Instructions
    love.graphics.setFont(reg_font)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("- Press any key -", 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("- Press any key -", 2, VIRTUAL_HEIGHT / 2 + 8, VIRTUAL_WIDTH, 'center')

    -- Credits
    love.graphics.setFont(small_font)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("A Game by OfficialChaser", 0, VIRTUAL_HEIGHT - 30, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("A Game by OfficialChaser", 1, VIRTUAL_HEIGHT - 31, VIRTUAL_WIDTH, 'center')
end

function StartState:update(dt)
    backgroundOffsetY = (backgroundOffsetY + backgroundScrollSpeedY * dt) % TILE_SIZE
end

function StartState:keypressed(key)
    if key and not Transition.active then
        mulligans = 3
        Transition:start(function()
            gStateMachine:change('play', 4)
        end)
        
    end
end
