AcidRain = Class{__includes = Entity}

function AcidRain:init(def, speed)
    Entity.init(self, def)
    currentAnimation = Animation {
        frames = {1},
        interval = 1
    }
    self.currentAnimation = currentAnimation
    self.speed = speed or 30
    self.gravity = 9.8
end

function AcidRain:update(dt)
    y = self.y + dt * self.speed
    if y > VIRTUAL_HEIGHT then
        y = -10
        x = math.random(0, VIRTUAL_WIDTH - 16)
        self.x = x
    end
    self.y = y

    self:collides(gStateMachine.current.player)

    Entity.update(self, dt)
    self.currentAnimation:update(dt)
end

function AcidRain:render()
    Entity.render(self)
    -- show collision box for debugging
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end

function AcidRain:collides(target)
    local result = Entity.collides(self, target)
    if result then 
        self:onCollide(target)
    end
    return result
end

function AcidRain:onCollide(target)
    self.y = -10
end

