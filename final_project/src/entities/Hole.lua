Hole = Class{}

function Hole:init(world, x, y)
    self.x = x
    self.y = y

    self.radius = 14        -- visual hole size
    self.triggerRadius = 12 -- collision threshold
    self.winSpeed = 150      -- max speed to count as sunk

    -- Physics sensor
    self.body = love.physics.newBody(world, x, y, 'static')
    self.shape = love.physics.newCircleShape(self.triggerRadius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setSensor(true)
end

function Hole:checkWin(ball)
    local bx, by = ball.body:getPosition()
    local dx = bx - self.x
    local dy = by - self.y
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist <= self.triggerRadius then
        local vx, vy = ball.body:getLinearVelocity()
        local speed = math.sqrt(vx * vx + vy * vy)

        if speed <= self.winSpeed then
            return true
        end
    end

    return false
end

function Hole:render()
    -- Hole shadow
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('fill', self.x, self.y, self.radius)

    -- Inner darkness
    love.graphics.setColor(0.15, 0.15, 0.15, 1)
    love.graphics.circle('fill', self.x, self.y, self.radius - 3)
end

return Hole
