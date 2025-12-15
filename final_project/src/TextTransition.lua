TextTransition = {}

TextTransition.active = false
TextTransition.y = 0
TextTransition.alpha = 1
TextTransition.phase = 'delay' -- 'delay' -> 'in' -> 'out'

-- Defaults
TextTransition.defaultSpeed = 200  -- pixels per second
TextTransition.defaultDelay = 0
TextTransition.defaultText = ''
TextTransition.defaultFont = nil
TextTransition.defaultX = 0
TextTransition.defaultY = 0

-- Runtime values
TextTransition.speed = TextTransition.defaultSpeed
TextTransition.delay = 0
TextTransition.delayTimer = 0
TextTransition.onMidpoint = nil
TextTransition.text = ''
TextTransition.font = nil
TextTransition.x = 0
TextTransition.targetY = 0

function TextTransition:start(text, font, x, targetY, speed, delay, onMidpoint)
    self.active = true
    self.text = text or self.defaultText
    self.font = font or self.defaultFont
    self.x = x or self.defaultX
    self.targetY = targetY or self.defaultY
    self.y = love.graphics.getHeight()  -- start at bottom
    self.alpha = 1

    self.phase = (delay and delay > 0) and 'delay' or 'in'
    self.delay = delay or self.defaultDelay
    self.delayTimer = 0

    self.speed = speed or self.defaultSpeed
    self.onMidpoint = onMidpoint
end

function TextTransition:update(dt)
    if not self.active then return end

    if self.phase == 'delay' then
        self.delayTimer = self.delayTimer + dt
        if self.delayTimer >= self.delay then
            self.phase = 'in'
        end

    elseif self.phase == 'in' then
        self.y = math.max(self.targetY, self.y - self.speed * dt)

        if self.y <= self.targetY then
            if self.onMidpoint then
                self.onMidpoint()
                self.onMidpoint = nil
            end
            self.phase = 'hold'
        end

    elseif self.phase == 'hold' then
        -- Optional: you can set a hold timer here if you want the text to linger
        self.phase = 'out'  -- immediately go out for now

    elseif self.phase == 'out' then
        self.y = self.y - self.speed * dt
        self.alpha = math.max(0, self.alpha - dt) -- fade out slightly

        if self.alpha <= 0 then
            self.active = false
        end
    end
end

function TextTransition:render()
    if not self.active then return end

    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x - 2, self.y - 2)  -- shadow offset
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.print(self.text, self.x, self.y)
    love.graphics.setColor(1, 1, 1, 1)
end

return TextTransition
