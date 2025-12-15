PlayState = Class{__includes = BaseState}

function PlayState:enter(level_num)
    backgroundOffsetY = 0
    self.levelNumber = level_num
    self.levelData = Level:get(self.levelNumber)

    -- Physics world
    self.world = love.physics.newWorld(0, 0)

    -- Ball
    self.ball = Ball(self.world, self.levelData.ballStart.x, self.levelData.ballStart.y)

    -- Walls
    self.walls = {}
    for _, w in pairs(self.levelData.walls) do
        local body = love.physics.newBody(self.world, 0, 0, 'static')
        local shape = love.physics.newEdgeShape(unpack(w))
        love.physics.newFixture(body, shape)
        table.insert(self.walls, shape)
    end
end

function PlayState:update(dt)
    self.world:update(dt)
    self.ball:update(dt)
end

function PlayState:render()
    -- Draw walls
    love.graphics.setColor(1, 1, 1, 1)
    for _, shape in pairs(self.walls) do
        local bx1, by1, bx2, by2 = shape:getPoints()
        love.graphics.line(bx1, by1, bx2, by2)
    end

    -- Draw ball
    self.ball:render()
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
