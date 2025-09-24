Bird = Class{}

local GRAVITY = 6

function Bird:init()
    self.image = love.graphics.newImage('graphics/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    -- Make the hitbox more forgiving by increasing the offset and reducing the hitbox size
    local hitboxOffset = 5
    local hitboxShrink = 10
    if (self.x + hitboxOffset) + (self.width - hitboxShrink) >= pipe.x and self.x + hitboxOffset <= pipe.x + PIPE_WIDTH then
        if (self.y + hitboxOffset) + (self.height - hitboxShrink) >= pipe.y and self.y + hitboxOffset <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt 

    -- TODO: add mouse functionality
    if love.keyboard.wasPressed('space') then 
        self.dy = -2
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, self.x, self.y)

    --love.graphics.setColor(1, 0, 0, 1)
    --love.graphics.rectangle('line', self.x + 2, self.y + 2, self.width - 4, self.height - 4)
end