PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 28
PIPE_HEIGHT = 72
GAP_HEIGHT = 56

BIRD_WIDTH = 25
BIRD_HEIGHT = 20

SPAWN_INTERVAL = 2

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    if self.timer > SPAWN_INTERVAL then
        -- TODO: fix this
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-60, 60), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT - 16))
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y))

        -- reset timer
        self.timer = 0
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- score a point if the pipe has gone past the bird to the left all the way
        -- be sure to ignore it if it's already been scored
        if not pair.scored then
            if pair.x + PIPE_WIDTH / 2 < self.bird.x then
 
                pair.scored = true
                self.score = self.score + 1
                sounds['score']:play()
            end
        end

        -- update position of pair
        pair:update(dt)
    end

    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                -- TODO: what state do we change to here and how?
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- update bird based on gravity and input
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end
    love.graphics.setFont(mediumFont)
    love.graphics.setColor(236/255, 233/255, 16/255, 1)
    love.graphics.print(tostring(self.score), self.bird.x + self.bird.width / 2 - mediumFont:getWidth(tostring(self.score)) / 2 + 1, self.bird.y - 16)
    self.bird:render()
end

function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end