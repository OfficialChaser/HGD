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

        -- Set rotation if specified (convert degrees to radians)
        if w.rotation then
            body:setAngle(math.rad(w.rotation))
        end

        local shape = love.physics.newRectangleShape(w.w, w.h)
        local fixture = love.physics.newFixture(body, shape)

        table.insert(self.walls, {
            body = body,
            shape = shape,
            w = w.w,
            h = w.h
        })
    end

    self.won = false
end

function PlayState:update(dt)
    self.world:update(dt)
    self.ball:update(dt)
    self.hole:update(dt)

    if self.hole:checkWin(self.ball) and not self.won then
        self.won = true
        self.hole:startSink(self.ball)
        ball_drop:play()
        if self.levelNumber == #Level.levels then
            -- Last level completed
            Transition:start(function()
                gStateMachine:change('start', 1) end, 1.5, 1)
            return
        end
        Transition:start(function()
            gStateMachine:change('play', self.levelNumber + 1) end, 1.5, 1)
    end

    if  self.ball.strokes == self.levelData.par and self.ball.body:getLinearVelocity() == 0 and not self.won then
        if mulligans <= 0 then
            Transition:start(function()
                gStateMachine:change('start', self.levelNumber) end, 1.5, 1)
        else
            self:mulligan()
        end
    end
end

function PlayState:render()
    for _, wall in pairs(self.walls) do
        local x, y = wall.body:getPosition()
        local angle = wall.body:getAngle()

        love.graphics.push()
        love.graphics.translate(x, y)
        love.graphics.rotate(angle)

        -- Outline
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle(
            'fill',
            -wall.w / 2 - 2,
            -wall.h / 2 - 2,
            wall.w + 4,
            wall.h + 4
        )

        -- Wall fill
        love.graphics.setColor(0.55, 0.27, 0.07, 1)
        love.graphics.rectangle(
            'fill',
            -wall.w / 2,
            -wall.h / 2,
            wall.w,
            wall.h
        )

        love.graphics.pop()
    end

    -- Draw hole
    self.hole:render()

    -- Draw ball
    if not self.won then
        self.ball:render()
    end

    -- Draw Level
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(reg_font)
    love.graphics.print('Level ' .. tostring(self.levelNumber), 8, 12)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Level ' .. tostring(self.levelNumber), 10, 10)

    -- Draw Instructions
    if self.levelNumber == 1 then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.setFont(reg_font)
        love.graphics.print('Click and drag the ball to putt', 120 - 2, 90)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('Click and drag the ball to putt', 120, 88)
    end

    -- Draw Par
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(reg_font)
    love.graphics.print('Par: ' .. tostring(self.levelData.par), VIRTUAL_WIDTH - 92, 12)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Par: ' .. tostring(self.levelData.par), VIRTUAL_WIDTH - 90, 10)

    -- Draw Strokes
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(reg_font)
    love.graphics.print('Strokes: ' .. tostring(self.ball.strokes), VIRTUAL_WIDTH - 154, 42)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Strokes: ' .. tostring(self.ball.strokes), VIRTUAL_WIDTH - 152, 40)

    -- Draw Mulligans
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(reg_font)
    love.graphics.print('Mulligans: ' .. tostring(mulligans), 242, 12)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Mulligans: ' .. tostring(mulligans), 244, 10)
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

    if key == 'r' and not Transition.active then
        Transition:start(function()
            gStateMachine:change('play', gStateMachine.current.levelNumber)
        end)
    end

    if key == 'm' and mulligans > 0 and not Transition.active and self.ball.body:getLinearVelocity() == 0 then
        self:mulligan()
    end
end

function PlayState:mulligan()
    past_pos = self.ball.body:getPosition()
    self.ball.body:setPosition(self.ball.prevX, self.ball.prevY)
    self.ball.body:setLinearVelocity(0, 0)

    if past_pos ~= self.ball.body:getPosition() then
        mulligans = mulligans - 1
        self.ball.strokes = math.max(0, self.ball.strokes - 1)
    end
end