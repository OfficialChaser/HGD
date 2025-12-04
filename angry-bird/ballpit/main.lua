--[[ 
    GD50
    Angry Birds (Modified for Circular Ground with Rotating Circle)
]]

VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

push = require 'push'

---------------------------------------------------------
-- BALL SPAWNER FUNCTION
---------------------------------------------------------
function spawnBall(x, y)
    local body = love.physics.newBody(world, x, y, 'dynamic')
    body:setLinearDamping(0)
    body:setAngularDamping(0)

    local fixture = love.physics.newFixture(body, ballShape)
    fixture:setFriction(0)
    fixture:setRestitution(1)

    table.insert(dynamicBodies, {
        body,
        r = math.random(),
        g = math.random(),
        b = math.random()
    })

    table.insert(dynamicFixtures, fixture)
end

---------------------------------------------------------
function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Circular Ground Demo')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    ---------------------------------------------------------
    -- COUNTER + TIMER + BALL SPAWN SETTINGS
    ---------------------------------------------------------
    ballCount = 0
    gameTimer = 45           -- seconds
    timerFont = love.graphics.newFont(16)
    ballsPerSpawn = 3        -- default number of balls to spawn when one leaves

    -- Button positions
    plusX, plusY = 50, 5
    minusX, minusY = 80, 5
    buttonWidth, buttonHeight = 20, 20

    ---------------------------------------------------------
    -- WORLD + ROTATING CIRCLE WITH HOLE
    ---------------------------------------------------------
    world = love.physics.newWorld(0, 100)

    circleX = VIRTUAL_WIDTH / 2
    circleY = VIRTUAL_HEIGHT / 2
    circleRadius = 150
    circleSegments = 64

    local holeStart = math.rad(140)
    local holeEnd   = math.rad(170)

    -- Kinematic body for rotation
    circleBody = love.physics.newBody(world, circleX, circleY, "kinematic")
    circleBody:setAngularVelocity(math.rad(30)) -- 30 degrees/sec

    circleEdges = {}

    for i = 1, circleSegments do
        local angle1 = (i - 1) * (2 * math.pi / circleSegments)
        local angle2 = i * (2 * math.pi / circleSegments)
        if not (angle1 >= holeStart and angle2 <= holeEnd) then
            local x1 = math.cos(angle1) * circleRadius
            local y1 = math.sin(angle1) * circleRadius
            local x2 = math.cos(angle2) * circleRadius
            local y2 = math.sin(angle2) * circleRadius
            local edge = love.physics.newEdgeShape(x1, y1, x2, y2)
            table.insert(circleEdges, love.physics.newFixture(circleBody, edge))
        end
    end

    ---------------------------------------------------------
    -- DYNAMIC BALLS
    ---------------------------------------------------------
    dynamicBodies = {}
    dynamicFixtures = {}
    ballShape = love.physics.newCircleShape(5)
    spawnBall(circleX, circleY)
    spawnBall(circleX - 5, circleY)
    spawnBall(circleX + 5, circleY)
end

---------------------------------------------------------
function push.resize(w, h)
    push:resize(w, h)
end

---------------------------------------------------------
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

---------------------------------------------------------
-- MOUSE CLICK HANDLER FOR BUTTONS
---------------------------------------------------------
function love.mousepressed(mx, my, button)
    local scaleX = VIRTUAL_WIDTH / love.graphics.getWidth()
    local scaleY = VIRTUAL_HEIGHT / love.graphics.getHeight()
    local x, y = mx * scaleX, my * scaleY

    if x >= plusX and x <= plusX + buttonWidth and y >= plusY and y <= plusY + buttonHeight then
        ballsPerSpawn = math.min(5, ballsPerSpawn + 1)
    elseif x >= minusX and x <= minusX + buttonWidth and y >= minusY and y <= minusY + buttonHeight then
        ballsPerSpawn = math.max(2, ballsPerSpawn - 1)
    end
end

---------------------------------------------------------
-- UPDATE: WORLD + ESCAPE CHECK + TIMER
---------------------------------------------------------
function love.update(dt)
    world:update(dt)

    -- Timer
    gameTimer = gameTimer - dt
    if gameTimer <= 0 then
        gameTimer = 45 -- reset timer
    end

    -- Ball escapes
    for i = #dynamicBodies, 1, -1 do
        local body = dynamicBodies[i][1]
        local x, y = body:getX(), body:getY()
        local dx, dy = x - circleX, y - circleY
        local dist = math.sqrt(dx*dx + dy*dy)

        if dist > circleRadius + 10 then
            body:destroy()
            table.remove(dynamicBodies, i)
            table.remove(dynamicFixtures, i)
            ballCount = ballCount + 1

            -- spawn ballsPerSpawn balls
            for j = 1, ballsPerSpawn do
                spawnBall(circleX + (j-1)*5, circleY)
            end
        end
    end
end

---------------------------------------------------------
function love.draw()
    push:start()

    -- Circle
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setLineWidth(2)
    for _, fixture in ipairs(circleEdges) do
        local shape = fixture:getShape()
        love.graphics.line(circleBody:getWorldPoints(shape:getPoints()))
    end

    -- Balls
    for i = 1, #dynamicBodies do
        love.graphics.setColor(dynamicBodies[i].r, dynamicBodies[i].g, dynamicBodies[i].b, 1)
        love.graphics.circle('fill', dynamicBodies[i][1]:getX(), dynamicBodies[i][1]:getY(), ballShape:getRadius())
    end

    -- Ball Counter
    love.graphics.setFont(timerFont)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Balls Escaped: " .. ballCount, VIRTUAL_WIDTH - 150, 5)

    -- Timer
    love.graphics.print(string.format("Time: %.1f", gameTimer), VIRTUAL_WIDTH / 2 - 40, 5)

    -- Buttons
    love.graphics.setColor(0, 0.8, 0, 1)
    love.graphics.rectangle('fill', plusX, plusY, buttonWidth, buttonHeight)
    love.graphics.rectangle('fill', minusX, minusY, buttonWidth, buttonHeight)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("+", plusX+5, plusY)
    love.graphics.print("-", minusX+5, minusY)
    love.graphics.print("Spawn: "..ballsPerSpawn, minusX+40, minusY)

    push:finish()
end
