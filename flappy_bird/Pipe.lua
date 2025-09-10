Pipe = Class{}

PIPE_SPEED = -60

PIPE_HEIGHT = 288
PIPE_WIDTH = 28

function Pipe:init()
    self.image = love.graphics.newImage('graphics/pipe.png')

    self.x = VIRTUAL_WIDTH + self.width
    self.y = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT - 10)

    self.orientation = orientation
end

function Pipe:render()
    love.graphics.draw(self.image, math.floor(self.x + 0.5), 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 0, 1, self.orientation == 'top' and -1 or 1
    )
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SPEED * dt
end 