--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    self.level = LevelMaker.generate(10 * day, 10)
    self.tileMap = self.level.tileMap
    self.background = ({1, 3})[math.random(2)]
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6
    -- debug: show collision shapes
    self.showCollision = false

    self.player = Player({
        x = 0, y = 0,
        width = 14, height = 20,
        texture = 'green-alien',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        level = self.level
    })

    self:spawnEnemies()

    self.acidRains = {}
    for i = 1, 100 do
        local acidRain = AcidRain({
            x = math.random(0, VIRTUAL_WIDTH - 16),
            y = math.random(-VIRTUAL_HEIGHT, 0),
            width = 1,
            height = 4,
            texture = 'acid',
        }, math.random(30, 60))
        table.insert(self.acidRains, acidRain)
    end

    self.player:changeState('falling')
end

function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()

    -- update player and level
    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera()

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end

    -- toggle collision debug drawing
    if love.keyboard.wasPressed('c') then
        self.showCollision = not self.showCollision
    end

    for k, acidRain in pairs(self.acidRains) do
        acidRain:update(dt)
        acidRain:render()
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    self.level:render()

    self.player:render()

    for k, acidRain in pairs(self.acidRains) do
       acidRain:render()
    end
    -- draw collision shapes if enabled
    if self.showCollision then
        -- draw tile collision boxes (collidable tiles)
        love.graphics.setColor(1, 0, 0, 0.5)
        for y = 1, self.tileMap.height do
            for x = 1, self.tileMap.width do
                local tile = self.tileMap.tiles[y][x]
                if tile and tile:collidable() then
                    love.graphics.rectangle('fill', (tile.x - 1) * TILE_SIZE, (tile.y - 1) * TILE_SIZE, tile.width, tile.height)
                end
            end
        end

        -- draw objects (all objects bounding boxes)
        love.graphics.setColor(0, 0, 1, 0.5)
        for k, object in pairs(self.level.objects) do
            love.graphics.rectangle('fill', object.x, object.y, object.width, object.height)
        end

        -- draw entities (including player)
        love.graphics.setColor(0, 1, 0, 0.5)
        for k, entity in pairs(self.level.entities) do
            love.graphics.rectangle('fill', entity.x, entity.y, entity.width, entity.height)
        end

        -- player box (distinct color)
        love.graphics.setColor(1, 1, 0, 0.6)
        love.graphics.rectangle('fill', self.player.x, self.player.y, self.player.width, self.player.height)

        love.graphics.setColor(1, 1, 1, 1)
        
    end
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(score), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(score), 4, 4)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print('Day: ' .. tostring(day), VIRTUAL_WIDTH - 60, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Day: ' .. tostring(day), VIRTUAL_WIDTH - 59, 4)
    love.graphics.setColor(1, 1, 1, 1)
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end

--[[
    Adds a series of enemies to the level randomly.
]]
function PlayState:spawnEnemies()
    -- spawn snails in the level
    for x = 1, self.tileMap.width do

        -- flag for whether there's ground on this column of the level
        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    -- random chance, 1 in 20
                    if math.random(20) == 1 then
                        
                        -- instantiate snail, declaring in advance so we can pass it into state machine
                        local snail
                        snail = Snail {
                            texture = 'creatures',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            stateMachine = StateMachine {
                                ['idle'] = function() return SnailIdleState(self.tileMap, self.player, snail) end,
                                ['moving'] = function() return SnailMovingState(self.tileMap, self.player, snail) end,
                                ['chasing'] = function() return SnailChasingState(self.tileMap, self.player, snail) end
                            }
                        }
                        snail:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, snail)
                    end
                end
            end
        end
    end
end