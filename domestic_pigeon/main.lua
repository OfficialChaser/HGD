push = require 'lib/push'

Class = require 'lib/class'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/PauseState'

require 'Bird'
require 'Pipe'
require 'PipePair'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 256
VIRTUAL_HEIGHT = 144

local background = love.graphics.newImage('graphics/background.png')
local back_clouds = love.graphics.newImage('graphics/back_clouds.png')
local middle_clouds = love.graphics.newImage('graphics/middle_clouds.png')
local front_clouds = love.graphics.newImage('graphics/front_clouds.png')

local back_clouds_scroll = 0
local middle_clouds_scroll = 0
local front_clouds_scroll = 0

local BACK_CLOUDS_SCROLL_SPEED = 30
local MIDDLE_CLOUDS_SCROLL_SPEED = 70
local FRONT_CLOUDS_SCROLL_SPEED = 90

-- global variable we can use to scroll the map
scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    math.randomseed(os.time())

    love.window.setTitle('Fifty Bird')
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}

    -- initialize mouse input table
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling then
        back_clouds_scroll = (back_clouds_scroll + BACK_CLOUDS_SCROLL_SPEED * dt) % (back_clouds:getWidth() / 2)
        middle_clouds_scroll = (middle_clouds_scroll + MIDDLE_CLOUDS_SCROLL_SPEED * dt) % (middle_clouds:getWidth() / 2)
        front_clouds_scroll = (front_clouds_scroll + FRONT_CLOUDS_SCROLL_SPEED * dt) % (front_clouds:getWidth() / 2)
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)
    
    love.graphics.draw(back_clouds, math.floor(-back_clouds_scroll - 0.5), 0)
    love.graphics.draw(middle_clouds, math.floor(-middle_clouds_scroll - 0.5), 0)
    gStateMachine:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(front_clouds, math.floor(-front_clouds_scroll + 0.5), 0)
    
    push:finish()
end