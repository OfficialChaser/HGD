local back_clouds_scroll = 0
local middle_clouds_scroll = 0
local front_clouds_scroll = 0

local BACK_CLOUDS_SCROLL_SPEED = 30
local MIDDLE_CLOUDS_SCROLL_SPEED = 60
local FRONT_CLOUDS_SCROLL_SPEED = 90
push = require 'lib/push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144


local background = love.graphics.newImage('graphics/background.png')
local back_clouds = love.graphics.newImage('graphics/back_clouds.png')
local middle_clouds = love.graphics.newImage('graphics/middle_clouds.png')
local front_clouds = love.graphics.newImage('graphics/front_clouds.png')

-- Parallax variables removed

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Domestic Pigeon 3.0')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    back_clouds_scroll = (back_clouds_scroll + BACK_CLOUDS_SCROLL_SPEED * dt) % (back_clouds:getWidth() / 2)
    middle_clouds_scroll = (middle_clouds_scroll + MIDDLE_CLOUDS_SCROLL_SPEED * dt) % (middle_clouds:getWidth() / 2)
    front_clouds_scroll = (front_clouds_scroll + FRONT_CLOUDS_SCROLL_SPEED * dt) % (front_clouds:getWidth() / 2)
    -- Use cloud image widths for smooth parallax looping
    -- No parallax, clouds are static
end

function love.draw()
    push:start()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(back_clouds, -back_clouds_scroll, 0)
    love.graphics.draw(middle_clouds, -middle_clouds_scroll, 0)
    love.graphics.draw(front_clouds, -front_clouds_scroll, 0)

    push:finish()
end