Flag = Class{__includes = Entity}

function Flag:init(def)
    Entity.init(self, def)
    -- pick a random frame first
    local choice = ({3, 5, 6})[math.random(3)]

    -- create the animation
    self.animation = Animation {
        frames = {choice},
        interval = 0.1
    }

    self.currentAnimation = self.animation

    -- pick a random flag topper frame (from gFrames['flag_toppers'])
    local topper_choice
    if choice == 3 then
        topper_choice = 7
    elseif choice == 5 then
        topper_choice = 25
    else
        topper_choice = 34
    end
    self.flag_topper = gFrames['flag_toppers'][topper_choice]
end

function Flag:update(dt)
    -- advance the flag's animation (if present)
    self.currentAnimation:update(dt)
    Entity.update(self, dt)
end

function Flag:render()
    Entity.render(self)
    
    -- draw the flag topper on top
    if self.flag_topper then
        love.graphics.draw(gTextures['flags'], self.flag_topper,
            math.floor(self.x), math.floor(self.y) + 16, 0, self.direction == 'right' and 1 or -1, 1, 8, 10)
    end
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