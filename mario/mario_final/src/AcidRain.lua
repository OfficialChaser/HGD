AcidRain = Class{__includes = Entity}

function AcidRain:init(def, speed)
    Entity.init(self, def)
    currentAnimation = Animation {
        frames = {1},
        interval = 1
    }
    self.currentAnimation = currentAnimation
    self.speed = speed or 30
end

function AcidRain:update(dt)
    y = self.y + dt * self.speed
    if y > VIRTUAL_HEIGHT then
        y = -10
        x = math.random(0, level_width)
        self.x = x
    end
    self.y = y

    if gStateMachine.current.player then
        self:collides(gStateMachine.current.player)
        if gStateMachine.current.player then
            for k, object in pairs(gStateMachine.current.player.level.objects) do
                if object.solid then
                    self:collides(object)
                end
            end
        end
    end

    Entity.update(self, dt)
    self.currentAnimation:update(dt)
end

function AcidRain:render()
    love.graphics.draw(gTextures[self.texture], 
    gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
   self.x, self.y)
end

function AcidRain:collides(target)
    local result = Entity.collides(self, target)
    if result then 
        self:onCollide(target)
    end
    return result
end

function AcidRain:onCollide(target)
    if gStateMachine.current.player and target == gStateMachine.current.player then
        health = health - 1
        if health <= 0 then
            gSounds['kill']:play()
            gStateMachine:change('start')
        end
    end
    self.x = math.random(0, level_width)
    self.y = -10
end

