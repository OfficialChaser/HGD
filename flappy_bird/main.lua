push = require 'lib/push'
Class = require 'lib/class'

require 'Bird'

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
    back_clouds_scroll = (back_clouds_scroll + BACK_CLOUDS_SCROLL_SPEED * dt) % (back_clouds:getWidth() / 2)
    middle_clouds_scroll = (middle_clouds_scroll + MIDDLE_CLOUDS_SCROLL_SPEED * dt) % (middle_clouds:getWidth() / 2)
    front_clouds_scroll = (front_clouds_scroll + FRONT_CLOUDS_SCROLL_SPEED * dt) % (front_clouds:getWidth() / 2)

    bird:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(back_clouds, -back_clouds_scroll, 0)
    love.graphics.draw(middle_clouds, -middle_clouds_scroll, 0)

    bird:render()

    love.graphics.draw(front_clouds, -front_clouds_scroll, 0)

    push:finish()
end