PlayState = Class{__includes = BaseState}

function PlayState:enter(level_num)
    backgroundOffsetY = 0
    self.levelNumber = level_num
    self.levelData = Level:get(self.levelNumber)

    -- Physics world
    self.world = love.physics.newWorld(0, 0)

    -- Ball
    self.ball = Ball(self.world, self.levelData.ballStart.x, self.levelData.ballStart.y)

    -- Hole
    self.hole = Hole(
        self.world,
        self.levelData.hole.x,
        self.levelData.hole.y
    )


    -- Walls
    self.walls = {}

    for _, w in pairs(self.levelData.walls) do
        local body = love.physics.newBody(
            self.world,
            w.x + w.w / 2,
            w.y + w.h / 2,
            'static'
        )

        local shape = love.physics.newRectangleShape(w.w, w.h)
        local fixture = love.physics.newFixture(body, shape)

        table.insert(self.walls, {
            body = body,
            shape = shape,
            w = w.w,
            h = w.h
        })
    end
end

function PlayState:update(dt)
    self.world:update(dt)
    self.ball:update(dt)

    if self.hole:checkWin(self.ball) then
        gStateMachine:change('start') -- temporary
        -- later: next level, score screen, etc.
    end
end

function PlayState:render()
    for _, wall in pairs(self.walls) do
        local x, y = wall.body:getPosition()

        -- Outline
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle(
            'fill',
            x - wall.w / 2 - 2,
            y - wall.h / 2 - 2,
            wall.w + 4,
            wall.h + 4
        )

        -- Wall fill
        love.graphics.setColor(0.55, 0.27, 0.07, 1)
        love.graphics.rectangle(
            'fill',
            x - wall.w / 2,
            y - wall.h / 2,
            wall.w,
            wall.h
        )
    end

    -- Draw hole
    self.hole:render()

    -- Draw ball
    self.ball:render()

    -- Draw Level
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(reg_font)
    love.graphics.print('Level ' .. tostring(self.levelNumber), 8, 12)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Level ' .. tostring(self.levelNumber), 10, 10)

    -- Drawn Instructions
    if self.levelNumber == 1 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(reg_font)
        love.graphics.print('Click and drag the ball to putt', 120 - 2, 82)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('Click and drag the ball to putt', 120, 80)
    end

end

-------------------------------------------------
-- Input handling
-------------------------------------------------
function PlayState:mousepressed(x, y, button)
    if button ~= 1 then return end
    self.ball:mousepressed(x, y)
end

function PlayState:mousereleased(x, y, button)
    if button ~= 1 then return end
    self.ball:mousereleased(x, y)
end

function PlayState:mousemoved(x, y)
    self.ball:mousemoved(x, y)
end

function PlayState:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
