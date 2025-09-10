PipePair = Class{}

local GAP_HEIGHT = 70
local PIPE_SCROLL = -60

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.pipes = {
        ['top'] = Pipe(self.y),
        ['bottom'] = Pipe(self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end

function PipePair:update(dt)
    for k, pipe in pairs(self.pipes) do
        pipe.x = pipe.x + PIPE_SCROLL * dt
    end
end

function PipePair:offscreen()
    return self.x < -PIPE_WIDTH
end