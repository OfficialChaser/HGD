--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Level = Class{}

function Level:init()
    
    -- create a new "world" (where physics take place), with no x gravity
    -- and 30 units of Y gravity (for downward force)
    self.world = love.physics.newWorld(0, 300)

    -- bodies we will destroy after the world update cycle; destroying these in the
    -- actual collision callbacks can cause stack overflow and other errors
    self.destroyedBodies = {}


    -- define collision callbacks for our world; the World object expects four,
    -- one for different stages of any given collision
function beginContact(a, b, coll)
    local udA = a:getUserData()
    local udB = b:getUserData()

    -- convenience functions
    local function isPlayer(ud) return ud == 'Player' end
    local function isAlien(ud) return ud == 'Alien' end
    local function isObstacle(ud) return type(ud) == 'table' and ud.__index == Obstacle end
    local function isGround(ud) return ud == 'Ground' end

    -----------------------------------------------------
    -- PLAYER + OBSTACLE
    -----------------------------------------------------
    if (isPlayer(udA) and isObstacle(udB)) or (isPlayer(udB) and isObstacle(udA)) then
        local playerFixture = isPlayer(udA) and a or b
        local obstacle = isObstacle(udA) and udA or udB

        local vx, vy = playerFixture:getBody():getLinearVelocity()
        local speed = math.abs(vx) + math.abs(vy)

        if speed > 20 then
            if obstacle:getHealth() == 1 then
                table.insert(self.destroyedBodies, obstacle.body)
            else
                obstacle.health = obstacle.health - 1
            end
        end
    end

    -----------------------------------------------------
    -- OBSTACLE + ALIEN (FALLING DEBRIS)
    -----------------------------------------------------
    if (isObstacle(udA) and isAlien(udB)) or (isObstacle(udB) and isAlien(udA)) then
        local obstacleUD = isObstacle(udA) and udA or udB
        local alienUD    = isAlien(udA) and udA or udB

        -- Get the actual FIXTURES
        local obstacleFix = isObstacle(udA) and a or b
        local alienFix    = isAlien(udA) and a or b

        -- Get obstacle velocity from its FIXTURE (not userdata)
        local vx, vy = obstacleFix:getBody():getLinearVelocity()
        local speed = math.abs(vx) + math.abs(vy)

        if speed > 10 then
            -- DESTROY using the FIXTURE's body
            table.insert(self.destroyedBodies, alienFix:getBody())
        end
    end


    -----------------------------------------------------
    -- PLAYER + ALIEN
    -----------------------------------------------------
    if (isPlayer(udA) and isAlien(udB)) or (isPlayer(udB) and isAlien(udA)) then
        local playerFix = isPlayer(udA) and a or b
        local alien     = isAlien(udA) and udA or udB

        local vx, vy = playerFix:getBody():getLinearVelocity()
        local speed = math.abs(vx) + math.abs(vy)

        if speed > 40 then
            table.insert(self.destroyedBodies, alien.body)
        end
    end

    -----------------------------------------------------
    -- PLAYER + GROUND (play bounce sound)
    -----------------------------------------------------
    if (isPlayer(udA) and isGround(udB)) or (isPlayer(udB) and isGround(udA)) then
        gSounds['bounce']:stop()
        gSounds['bounce']:play()
    end
end


    -- the remaining three functions here are sample definitions, but we are not
    -- implementing any functionality with them in this demo; use-case specific
    -- http://www.iforce2d.net/b2dtut/collision-anatomy
    function endContact(a, b, coll)
        
    end

    function preSolve(a, b, coll)

    end

    function postSolve(a, b, coll, normalImpulse, tangentImpulse)

    end

    -- register just-defined functions as collision callbacks for world
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- shows alien before being launched and its trajectory arrow
    self.launchMarker = AlienLaunchMarker(self.world)

    -- aliens in our scene
    self.aliens = {}

    -- obstacles guarding aliens that we can destroy
    self.obstacles = {}

    -- simple edge shape to represent collision for ground
    self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH * 3, 0)

    if level == 1 then
        launchesLeft = 2
        -- spawn an alien to try and destroy
        table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - TILE_SIZE - ALIEN_SIZE / 2, 'Alien'))

        -- spawn a few obstacles
        table.insert(self.obstacles, Obstacle(self.world, 'vertical',
            VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 35 - 110 / 2, 2))
        table.insert(self.obstacles, Obstacle(self.world, 'vertical',
            VIRTUAL_WIDTH - 35, VIRTUAL_HEIGHT - 35 - 110 / 2, 2))
        table.insert(self.obstacles, Obstacle(self.world, 'horizontal',
            VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - 35 - 110 - 35 / 2))
        table.insert(self.obstacles, Obstacle(self.world, 'vertical',
            VIRTUAL_WIDTH - 80, 120, 2))
    elseif level == 2 then
        launchesLeft = 2
            -- spawn an alien to try and destroy
        table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - TILE_SIZE - ALIEN_SIZE / 2, 'Alien'))
        table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_WIDTH - 80, 50, 'Alien'))

        -- spawn a few obstacles
        table.insert(self.obstacles, Obstacle(self.world, 'vertical',
            VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 35 - 110 / 2))
        table.insert(self.obstacles, Obstacle(self.world, 'vertical',
            VIRTUAL_WIDTH - 35, VIRTUAL_HEIGHT - 35 - 110 / 2))
    end
-- ground data
self.groundBody = love.physics.newBody(self.world, -VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 35, 'static')
self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape)
self.groundFixture:setFriction(0.5)
self.groundFixture:setUserData('Ground')

-- background graphics
self.background = Background()
end

function Level:update(dt)
    
    -- update launch marker, which shows trajectory
    self.launchMarker:update(dt)

    -- Box2D world update code; resolves collisions and processes callbacks
    self.world:update(dt)

    -- destroy all bodies we calculated to destroy during the update call
    for k, body in pairs(self.destroyedBodies) do
        if not body:isDestroyed() then 
            body:destroy()
        end
    end

    -- reset destroyed bodies to empty table for next update phase
    self.destroyedBodies = {}

    -- remove all destroyed obstacles from level
    for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].body:isDestroyed() then
            table.remove(self.obstacles, i)

            -- play random wood sound effect
            local soundNum = math.random(5)
            gSounds['break' .. tostring(soundNum)]:stop()
            gSounds['break' .. tostring(soundNum)]:play()
        end
    end

    -- remove all destroyed aliens from level
    for i = #self.aliens, 1, -1 do
        if self.aliens[i].body:isDestroyed() then
            table.remove(self.aliens, i)
            gSounds['kill']:stop()
            gSounds['kill']:play()
        end
    end

    -- replace launch marker if original alien stopped moving
    if self.launchMarker.launched then
        local xPos, yPos = self.launchMarker.alien.body:getPosition()
        local xVel, yVel = self.launchMarker.alien.body:getLinearVelocity()
        
        -- if we fired our alien to the left or it's almost done rolling, respawn
        if (xPos < 0 or (math.abs(xVel) < 20 and math.abs(yVel) < 1 and yPos > VIRTUAL_HEIGHT - 70)) and launchesLeft > 0 then
            self.launchMarker.alien.body:destroy()
            self.launchMarker = AlienLaunchMarker(self.world)
        end
    end

    if #self.aliens == 0 and level ~= final_level then
        level = level + 1
        gStateMachine:change('play')
    end
end

function Level:render()
    
    -- render ground tiles across full scrollable width of the screen
    for x = -VIRTUAL_WIDTH, VIRTUAL_WIDTH * 2, 35 do
        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12], x, VIRTUAL_HEIGHT - 35)
    end

    self.launchMarker:render()

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    for k, obstacle in pairs(self.obstacles) do
        obstacle:update()
        obstacle:render()
    end

    -- render instruction text if we haven't launched bird and level is 1
    if not self.launchMarker.launched and level == 1 then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('Click and drag circular alien to shoot!',
            0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- render victory text if all aliens are dead
    if #self.aliens == 0 then
        love.graphics.setFont(gFonts['huge'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
end