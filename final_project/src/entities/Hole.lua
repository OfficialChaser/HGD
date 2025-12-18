Hole = Class{}

function Hole:init(world, x, y)
    self.x = x
    self.y = y

    self.radius = 14        -- visual hole size
    self.triggerRadius = 12 -- collision threshold
    self.winSpeed = 270     -- max speed to count as sunk

    -- Physics sensor (still useful later)
    self.body = love.physics.newBody(world, x, y, 'static')
    self.shape = love.physics.newCircleShape(self.triggerRadius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setSensor(true)

    -------------------------------------------------
    -- Sink animation state
    -------------------------------------------------
    self.sinking = false
    self.sinkRadius = 0
    self.sinkSpeed = 10
    self.ball = nil
end

-------------------------------------------------
-- Called from PlayState when you detect a win
-------------------------------------------------
function Hole:startSink(ball)
    self.sinking = true
    self.ball = ball
    self.sinkRadius = ball.radius

    -- Freeze real ball
    ball.body:setLinearVelocity(0, 0)
    ball.body:setActive(false)
end

-------------------------------------------------
function Hole:update(dt)
    if self.sinking then
        self.sinkRadius = self.sinkRadius - self.sinkSpeed * dt

        if self.sinkRadius <= 0 then
            self.sinkRadius = 0
            self.sinking = false
        end
    end
end

-------------------------------------------------
-- Your original logic (unchanged)
-------------------------------------------------
function Hole:checkWin(ball)
    if self.sinking then return false end

    local bx, by = ball.body:getPosition()
    local dx = bx - self.x
    local dy = by - self.y
    local dist = math.sqrt(dx * dx + dy * dy)

    if dist <= self.triggerRadius then
        local vx, vy = ball.body:getLinearVelocity()
        local speed = math.sqrt(vx * vx + vy * vy)
        local ws = self.winSpeed
        if ball.gravity then
            ws  = ws + 100
        end
        if speed <= ws then
            return true
        end
    end

    return false
end

-------------------------------------------------
function Hole:render()
    -- Hole shadow
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('fill', self.x, self.y, self.radius)

    -- Inner darkness
    love.graphics.setColor(0.15, 0.15, 0.15, 1)
    love.graphics.circle('fill', self.x, self.y, self.radius - 3)

    -- Sinking ball animation
    if self.sinking and self.sinkRadius > 0 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle('fill', self.x, self.y, self.sinkRadius)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return Hole
