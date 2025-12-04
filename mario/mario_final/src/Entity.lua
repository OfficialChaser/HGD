--[[
    GD50
    Super Mario Bros. Remake

    -- Entity Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def)
    -- position
    self.x = def.x
    self.y = def.y

    -- velocity
    self.dx = 0
    self.dy = 0

    -- dimensions
    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.stateMachine = def.stateMachine

    self.direction = 'left'

    -- reference to tile map so we can check collisions
    self.map = def.map

    -- reference to level for tests against other entities + objects
    self.level = def.level

end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)
    if self.stateMachine then
        self.stateMachine:update(dt)
    end
end

function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end

function Entity:render()
    -- determine quad to draw with safe fallbacks
    local quad = nil
    local framesForTexture = gFrames[self.texture]

    if self.currentAnimation and type(self.currentAnimation.getCurrentFrame) == 'function' then
        local frameIndex = self.currentAnimation:getCurrentFrame()
        if framesForTexture then quad = framesForTexture[frameIndex] end
    end

    -- fallback to entity's frame property (if present)
    if not quad and self.frame and framesForTexture then
        quad = framesForTexture[self.frame]
    end

    -- final fallback to first frame
    if not quad and framesForTexture then
        quad = framesForTexture[1]
    end

    -- if we still don't have a quad, bail out to avoid crashing
    if not quad then
        print("Warning: missing quad for texture '" .. tostring(self.texture) .. "' in Entity:render()")
        return
    end

    love.graphics.draw(gTextures[self.texture], quad,
        math.floor(self.x) + 8, math.floor(self.y) + 10, 0, self.direction == 'right' and 1 or -1, 1, 8, 10)
end