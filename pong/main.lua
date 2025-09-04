push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
CPU_SPEED = PADDLE_SPEED * 0.8

WINNING_SCORE = 5

currentDifficulty = 'Choose one!'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- create game objects
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    servingPlayer = 1

    -- set game state
    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'serve' then 
        ball.dy = math.random(-50, 50)

        if servingPlayer == 1 then 
            ball.dx = math.random(140, 200)
        else 
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then 
        -- collision with left (player 2 score)
        if ball.x + ball.width < player1.x then 
            servingPlayer = 1
            player2.score = player2.score + 1
            sounds['score']:play()

            if player2.score == WINNING_SCORE then 
                winningPlayer = 2
                gameState = 'win'
            else
                ball:reset()
                gameState = 'serve'
            end
        end

        -- collision with right (player 1 score)
        if ball.x > player2.x + player2.width then 
            servingPlayer = 2
            player1.score = player1.score + 1
            sounds['score']:play()

            if player1.score == WINNING_SCORE then 
                winningPlayer = 1
                gameState = 'win'
            else
                ball:reset()
                gameState = 'serve'
            end
        end

        if ball:collides(player1) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + player1.width

            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:setPitch(math.random(90, 110) / 100)
            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - ball.width

            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else 
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:setPitch(math.random(110, 130) / 100)
            sounds['paddle_hit']:play()
        end

        -- collision with top of screen
        if ball.y <= 0 then 
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- collision with bottom of screen
        if ball.y + ball.height >= VIRTUAL_HEIGHT then 
            ball.y = VIRTUAL_HEIGHT - ball.height 
            ball.dy = -ball.dy 
            sounds['wall_hit']:play()
        end

        ball:update(dt)
    end

    if love.keyboard.isDown('w') then 
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then 
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if gameState == 'play' then
        local ballCenter = ball.y + ball.height / 2
        local player2Center = player2.y + player2.height / 2
        local deadzone = 5

        if currentDifficulty == 'Medium' or currentDifficulty == 'Hard' then
            if ball.dx > 0 and ball.x > VIRTUAL_WIDTH / 4 then
                if ballCenter > player2Center + deadzone then
                    player2.dy = CPU_SPEED
                elseif ballCenter < player2Center - deadzone then
                    player2.dy = -CPU_SPEED
                else
                    player2.dy = 0
                end
            elseif ball.dx < 0 and ball.x < VIRTUAL_WIDTH / 2 and currentDifficulty == 'Hard' then
                if player2Center < VIRTUAL_HEIGHT / 2 - deadzone then
                    player2.dy = CPU_SPEED
                elseif player2Center > VIRTUAL_HEIGHT / 2 + deadzone then
                    player2.dy = -CPU_SPEED
                else
                    player2.dy = 0
                end
            end
        elseif currentDifficulty == 'Easy' then
            deadzone = 10
            if ball.dx > 0 and ball.x > VIRTUAL_WIDTH / 2 then
                if ballCenter > player2Center + deadzone then
                    player2.dy = CPU_SPEED
                elseif ballCenter < player2Center - deadzone then
                    player2.dy = -CPU_SPEED
                else
                    player2.dy = 0
                end
            else
                player2.dy = 0
            end
        end
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then 
        love.event.quit()
    elseif key == 'enter' or key == 'return' or key == 'space' then 
        if gameState == 'serve' then 
            gameState = 'play'
        elseif gameState == 'win' then 
            gameState = 'start'

            ball:reset()

            player1.score = 0
            player2.score = 0

            if winningPlayer == 1 then 
                servingPlayer = 2
            else 
                servingPlayer = 1
            end
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(0, 0, 0, 255/255)

    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
        displayScores()
        displayButtons()
    elseif gameState == 'serve' then 
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. ' to serve', 0, 20, VIRTUAL_WIDTH, 'center')
        displayScores()
    elseif gameState == 'win' then 
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!', 0, 20, VIRTUAL_WIDTH, 'center')
        displayScores()
    elseif gameState == 'play' then 
        -- print nothing
    end

    player1:render()
    player2:render()
    ball:render()

    displayUI()

    push:apply('end')
end

function displayUI()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Difficulty: ' .. tostring(currentDifficulty), 0, 10, VIRTUAL_WIDTH - 5, "right")
end

function displayScores()
    -- draw scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2.score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayButtons()
    -- draw buttons
    love.graphics.setFont(largeFont)
    love.graphics.print('Choose difficulty:', VIRTUAL_WIDTH / 2 - 70, VIRTUAL_HEIGHT / 3 + 60)

    -- locals
    local easyButton = {x = VIRTUAL_WIDTH / 2 - 18, y = VIRTUAL_HEIGHT / 3 + 80, width = 36, height = 13}
    local mediumButton = {x = VIRTUAL_WIDTH / 2 - 28, y = VIRTUAL_HEIGHT / 3 + 100, width = 58, height = 13}
    local hardButton = {x = VIRTUAL_WIDTH / 2 - 18, y = VIRTUAL_HEIGHT / 3 + 120, width = 36, height = 13}

    if isButtonHovered(easyButton.x, easyButton.y, easyButton.width, easyButton.height) then
        -- do something for easy button hover
        love.graphics.setColor(0, 255/255, 0, 255/255)
        checkMousePressed('Easy')
    else
        love.graphics.setColor(0, 255/255, 0, 100/255)
    end
    love.graphics.print('Easy', easyButton.x, easyButton.y)
    if isButtonHovered(mediumButton.x, mediumButton.y, mediumButton.width, mediumButton.height) then
        -- do something for medium button hover
        love.graphics.setColor(255/255, 255/255, 0, 255/255)
        checkMousePressed('Medium')
    else
        love.graphics.setColor(255/255, 255/255, 0, 100/255)
    end
    love.graphics.print('Medium', mediumButton.x, mediumButton.y)
    if isButtonHovered(hardButton.x, hardButton.y, hardButton.width, hardButton.height) then
        -- do something for hard button hover
        love.graphics.setColor(255/255, 0, 0, 255/255)
        checkMousePressed('Hard')
    else
        love.graphics.setColor(255/255, 0, 0, 100/255)
    end
    love.graphics.print('Hard', hardButton.x, hardButton.y)
end

function isButtonHovered(bx, by, bw, bh)
    local mx, my = love.mouse.getPosition()
    mx = mx * VIRTUAL_WIDTH / WINDOW_WIDTH
    my = my * VIRTUAL_HEIGHT / WINDOW_HEIGHT

    return mx >= bx and mx <= bx + bw and my >= by and my <= by + bh
end

function checkMousePressed(difficulty)
    if love.mouse.isDown(1) then
        setDifficulty(difficulty)
    end
end

function setDifficulty(difficulty)
    currentDifficulty = difficulty
    if difficulty == 'Easy' then
        CPU_SPEED = PADDLE_SPEED * 0.6
    elseif difficulty == 'Medium' then
        CPU_SPEED = PADDLE_SPEED * 0.7
    elseif difficulty == 'Hard' then
        CPU_SPEED = PADDLE_SPEED * 0.8
    end
    gameState = 'serve'
end