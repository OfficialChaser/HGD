Flag = Class{__includes = Entity}

function Flag:init(def)
    Entity.init(self, def)
end

function Flag:update(dt)
    Entity.update(self, dt)
end

function Flag:render()
    Entity.render(self)
end

function Flag:collides(target)
    return Entity.collides(self, target)
end

function Flag:onCollide(target)
    if target == gStateMachine.current.player and not self.hit then
        gSounds['flagpole']:play()
        self.hit = true
        gStateMachine:change('play', {
            score = target.score + 1000,
            level = gStateMachine.current.level + 1
        })
    end
end