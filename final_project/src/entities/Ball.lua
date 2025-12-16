Ball = Class{}

function Ball:init(world, x, y)
    self.radius = 8
    self.aim_radius = 24


    self.stop_velocity = 10
    self.gravity_stop_velocity = 50

    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.shape = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    
    self.dragging = false

    self.speed = 0.0

    self.strokes = 0

    self.prevX, self.prevY = x, y

    self.gravity = false

    self.mulligan_warning = false

    self.restrict = false
end

function Ball:update(dt)
    local vx, vy = self.body:getLinearVelocity()
    self.speed = math.sqrt(vx * vx + vy * vy)

    -- No Gravity mode
    if self.speed < self.stop_velocity and not self.gravity then
        self.body:setLinearVelocity(0, 0)
    end

    -- Gravity mode
    if self.gravity and vx < self.gravity_stop_velocity and math.abs(vy) < 0.01 then
        self.body:setLinearVelocity(0, 0)
    end
end

function Ball:mousepressed(x, y)
    if self.restrict then return end
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
    if self.restrict then return end
    if self.dragging then
        self.endX, self.endY = x, y
    else
        self.endX, self.endY = nil, nil
    end
end

function Ball:mousereleased(x, y)
    if self.restrict then return end
    if not self.dragging then return end

    local fx = self.startX - x
    local fy = self.startY - y
    if math.floor(fx + fy) == 0 then return end

    self.prevX, self.prevY = self.body:getPosition()
    self.body:applyLinearImpulse(fx * 2, fy * 2)
    self.strokes = self.strokes + 1
    self.dragging = false

    putt_sound:stop()
    putt_sound:play()
end

function Ball:render()
    local bx, by = self.body:getPosition()
    
    love.graphics.setLineWidth(2)

    -- Mulligan preview
    if mulligans > 0 then
        if self.mulligan_warning then
            love.graphics.setColor(1, 0, 0, 0.5)
        else
            love.graphics.setColor(0, 0, 0, 0.5)
        end
        local mx = math.floor(self.prevX)
        local my = math.floor(self.prevY)
        love.graphics.circle('fill', mx, my, self.radius + 1)
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.setFont(small_font)
        love.graphics.printf('M', mx - 30, my - 4, 60, 'center')
    end
    
    -- Aim radius
    if math.floor(self.speed) == 0 and not self.restrict then
        love.graphics.setColor(0, 0, 0, 0.15)
        love.graphics.circle('fill', bx, by, self.aim_radius)
    end

    -- Outline
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle('fill', bx, by, self.radius + 2)

    -- Ball
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', bx, by, self.radius)

    -- Aim line
    if self.dragging then
        love.graphics.setColor(1, 1, 1, 1)
        if self.endX and self.endY then
            love.graphics.line(self.startX, self.startY, self.endX, self.endY)
        end
    end

    -- Mulligan Warning
    if self.mulligan_warning then
        tx = math.floor(bx)
        ty = math.floor(by)
        love.graphics.setFont(small_font)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf('Press [M] to use a mulligan', tx - 50, ty - 30, 100, 'center')
    end

end

function Ball:setGravityMode(enabled)
    if enabled then
        -- Less damping so gravity can pull the ball naturally
        self.body:setLinearDamping(1)
        self.fixture:setRestitution(0)
        self.aim_radius = 32
        self.gravity = true
    else
        -- More damping for top-down precision putting
        self.body:setLinearDamping(1)
         self.fixture:setRestitution(1)
    end
end

return Ball
