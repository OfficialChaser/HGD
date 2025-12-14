-- MULLIGAN! - Ball Prototype using Ball class

VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

require 'src/Dependencies'


function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('MULLIGAN!')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -------------------------------------------------
    -- PHYSICS WORLD (TOP-DOWN)
    -------------------------------------------------
    world = love.physics.newWorld(0, 0)

    -------------------------------------------------
    -- BALL
    -------------------------------------------------
    ball = Ball(world, VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)

    -------------------------------------------------
    -- WALLS
    -------------------------------------------------
    walls = {}

    local function makeWall(x1, y1, x2, y2)
        local body = love.physics.newBody(world, 0, 0, 'static')
        local shape = love.physics.newEdgeShape(x1, y1, x2, y2)
        love.physics.newFixture(body, shape)
        table.insert(walls, shape)
    end

    makeWall(0, 0, VIRTUAL_WIDTH, 0)
    makeWall(0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    makeWall(0, 0, 0, VIRTUAL_HEIGHT)
    makeWall(VIRTUAL_WIDTH, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

-------------------------------------------------
function push.resize(w, h)
    push:resize(w, h)
end

-------------------------------------------------
function love.update(dt)
    world:update(dt)
    ball:update(dt)
end

-------------------------------------------------
function love.mousepressed(mx, my, button)
    if button ~= 1 then return end

    local x = mx * VIRTUAL_WIDTH / love.graphics.getWidth()
    local y = my * VIRTUAL_HEIGHT / love.graphics.getHeight()

    ball:mousepressed(x, y)
end

-------------------------------------------------
function love.mousereleased(mx, my, button)
    if button ~= 1 then return end

    local x = mx * VIRTUAL_WIDTH / love.graphics.getWidth()
    local y = my * VIRTUAL_HEIGHT / love.graphics.getHeight()

    ball:mousereleased(x, y)
end

-------------------------------------------------
function love.mousemoved(mx, my)
    local x = mx * VIRTUAL_WIDTH / love.graphics.getWidth()
    local y = my * VIRTUAL_HEIGHT / love.graphics.getHeight()

    ball:mousemoved(x, y)
end

-------------------------------------------------
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-------------------------------------------------
function love.draw()
    push:start()

    -- Background
    drawCheckeredBackground()

    -- Ball
    ball:render()

    push:finish()
end

