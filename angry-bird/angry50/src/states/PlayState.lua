--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.level = Level()
    self.levelTranslateX = 0
    self.max_scroll = 1500
    local launchedPlayer = self.level.launchMarker.alien
    local timeAfterLaunch = 0.0
    local canRestart = false
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    if love.keyboard.wasPressed('r') and  canRestart then
        gStateMachine:change('play')
    end

    -- update player stuff
    self:updatePlayerTracker(dt)

    -- update camera
    if love.keyboard.isDown('left') then
        self.levelTranslateX = self.levelTranslateX + MAP_SCROLL_X_SPEED * dt
        
        if self.levelTranslateX > VIRTUAL_WIDTH then
            self.levelTranslateX = VIRTUAL_WIDTH
        else
            
            -- only update background if we were able to scroll the level
            self.level.background:update(dt)
        end
    elseif love.keyboard.isDown('right') then
        self.levelTranslateX = self.levelTranslateX - MAP_SCROLL_X_SPEED * dt

        if self.levelTranslateX < -VIRTUAL_WIDTH then
            self.levelTranslateX = -VIRTUAL_WIDTH
        else
            
            -- only update background if we were able to scroll the level
            self.level.background:update(dt)
        end
    end


    self.level:update(dt)
end

function PlayState:render()
    -- render background separate from level rendering
    self.level.background:render()

    -- Print FPS
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)

    -- Print Level
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level: ' .. tostring(level), 0, 5, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    -- Print Launches Left
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.printf('Launches Left: ' .. tostring(launchesLeft), 0, 35, VIRTUAL_WIDTH, 'center')
    
    -- Print restart if needed
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 0, 0, 1)
    if canRestart then
        love.graphics.print('Press [R] to Restart', VIRTUAL_WIDTH - 180, 5)
    end
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.translate(math.floor(self.levelTranslateX), 0)
    self.level:render()
end

function PlayState:updatePlayerTracker(dt)
    launchedPlayer = self.level.launchMarker.alien

    if launchedPlayer then
        timeAfterLaunch = timeAfterLaunch + dt
        local launchedX, launchedY = launchedPlayer.body:getPosition()
        local launchedVelX, launchedVelY = launchedPlayer.body:getLinearVelocity()

        if timeAfterLaunch > 3 and (math.abs(launchedVelX) + math.abs(launchedVelY) < 100) then
            canRestart = true
        end

    else
        timeAfterLaunch = 0.0
        canRestart = false
    end
end
