push = require 'lib/push'
Class = require 'lib/class'

require 'Bird'
require 'Pipe'
require 'PipePair'

local back_clouds_scroll = 0
local middle_clouds_scroll = 0
local front_clouds_scroll = 0

local BACK_CLOUDS_SCROLL_SPEED = 30
local MIDDLE_CLOUDS_SCROLL_SPEED = 60
local FRONT_CLOUDS_SCROLL_SPEED = 90

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144


local background = love.graphics.newImage('graphics/background.png')
local back_clouds = love.graphics.newImage('graphics/back_clouds.png')
local middle_clouds = love.graphics.newImage('graphics/middle_clouds.png')
local front_clouds = love.graphics.newImage('graphics/front_clouds.png')

local bird = Bird()

local pipe_pairs = {}
local pipe_spawn_timer = 0
local last_pipe_y = -PIPE_HEIGHT + math.random(80) + 20


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Domestic Pigeon 3.0')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

    pipe_spawn_timer = pipe_spawn_timer + dt
    if pipe_spawn_timer > 2 then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(last_pipe_y + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        last_pipe_y = y
        table.insert(pipe_pairs, PipePair(y))
        pipe_spawn_timer = 0
    end

    back_clouds_scroll = (back_clouds_scroll + BACK_CLOUDS_SCROLL_SPEED * dt) % (back_clouds:getWidth() / 2)
    middle_clouds_scroll = (middle_clouds_scroll + MIDDLE_CLOUDS_SCROLL_SPEED * dt) % (middle_clouds:getWidth() / 2)
    front_clouds_scroll = (front_clouds_scroll + FRONT_CLOUDS_SCROLL_SPEED * dt) % (front_clouds:getWidth() / 2)

    bird:update(dt)

    -- for every pipe in the pipes table
    for k, pair in pairs(pipe_pairs) do
        pair:update(dt)

        -- remove pipes that go off screen
        if pair.x < 0 then
            table.remove(pipe_pairs, k)
        end
    end

    -- clear input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(back_clouds, math.floor(-back_clouds_scroll - 0.5), 0)
    love.graphics.draw(middle_clouds, math.floor(-middle_clouds_scroll - 0.5), 0)

    bird:render()

    for k, pair in pairs(pipe_pairs) do
        pair:render()
    end

    love.graphics.draw(front_clouds, math.floor(-front_clouds_scroll + 0.5), 0)

    push:finish()
end