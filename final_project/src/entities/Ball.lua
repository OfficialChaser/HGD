Ball = Class{}

function Ball:init(world, x, y)
    self.radius = 8
    self.aim_radius = 24
    self.stop_velocity = 10

    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.shape = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.body:setLinearDamping(1)
    self.fixture:setRestitution(1)
    
    self.dragging = false

    self.speed = 0.0
end

function Ball:update(dt)
    local vx, vy = self.body:getLinearVelocity()
    self.speed = math.sqrt(vx * vx + vy * vy)
    if self.speed < self.stop_velocity then
        self.body:setLinearVelocity(0, 0)
    end
end

function Ball:mousepressed(x, y)
    local bx, by = self.body:getPosition()
    local dx, dy = x - bx, y - by

    if dx*dx + dy*dy <= self.aim_radius*self.aim_radius then
        local vx, vy = self.body:getLinearVelocity()
        if math.abs(vx) < 5 and math.abs(vy) < 5 then
            self.dragging = true
            self.startX, self.startY = x, y
            self.body:setLinearVelocity(0, 0)
        end
    end
end

function Ball:mousemoved(x, y)
    if self.dragging then
        self.endX, self.endY = x, y
    else
        self.endX, self.endY = nil, nil
    end
end

function Ball:mousereleased(x, y)
    if not self.dragging then return end

    local fx = self.startX - x
    local fy = self.startY - y

    self.body:applyLinearImpulse(fx * 2, fy * 2)
    self.dragging = false
end

function Ball:render()
    local bx, by = self.body:getPosition()

    -- Ball
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', bx, by, self.radius)

    -- Aim radius
    if self.speed == 0 then
        love.graphics.circle('line', bx, by, self.aim_radius)
    end

    -- Aim line
    if self.dragging then
        love.graphics.setColor(1, 1, 1, 1)
        if self.endX and self.endY then
            love.graphics.line(self.startX, self.startY, self.endX, self.endY)
        end
    end
end

return Ball
