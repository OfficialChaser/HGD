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
        resizable = false
    })

    -------------------------------------------------
    -- STATE MACHINE
    -------------------------------------------------
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play']  = function() return PlayState()  end
    }
    gStateMachine:change('start')


    -- Audio
    track1:setLooping(true)
    track2:setLooping(true)
    track3:setLooping(true)
    track1:play()
end

-------------------------------------------------
function push.resize(w, h)
    push:resize(w, h)
end

-------------------------------------------------
function love.update(dt)
    Transition:update(dt)
    gStateMachine:update(dt)
end

-------------------------------------------------
function love.mousepressed(mx, my, button)
    local x = mx * VIRTUAL_WIDTH / love.graphics.getWidth()
    local y = my * VIRTUAL_HEIGHT / love.graphics.getHeight()
    if gStateMachine.current.mousepressed then
        gStateMachine.current:mousepressed(x, y, button)
    end
end

-------------------------------------------------

function love.mousereleased(mx, my, button)
    local x = mx * VIRTUAL_WIDTH / love.graphics.getWidth()
    local y = my * VIRTUAL_HEIGHT / love.graphics.getHeight()
    if gStateMachine.current.mousereleased then
        gStateMachine.current:mousereleased(x, y, button)
    end
end

-------------------------------------------------

function love.mousemoved(mx, my)
    local x = mx * VIRTUAL_WIDTH / love.graphics.getWidth()
    local y = my * VIRTUAL_HEIGHT / love.graphics.getHeight()
    if gStateMachine.current.mousemoved then
        gStateMachine.current:mousemoved(x, y)
    end
end


-------------------------------------------------
function love.keypressed(key)
    if gStateMachine.current.keypressed then
        gStateMachine.current:keypressed(key)
    end
    if key == 'escape' then
        love.event.quit()
    end

end

-------------------------------------------------
function love.draw()
    push:start()
    drawCheckeredBackground()
    gStateMachine:render()
    Transition:render()
    push:finish()
end

