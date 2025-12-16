TextTransition = {}

TextTransition.active = false
TextTransition.phase = 'delay'

-- Defaults
TextTransition.defaultSpeed = 200          -- pixels per second
TextTransition.defaultDelay = 0
TextTransition.defaultHold = 0.6
TextTransition.defaultText = ''
TextTransition.defaultFont = nil
TextTransition.defaultX = 0
TextTransition.defaultTargetY = 0

-- Runtime
TextTransition.text = ''
TextTransition.font = nil
TextTransition.x = 0
TextTransition.y = 0
TextTransition.targetY = 0
TextTransition.alpha = 1

TextTransition.speed = 200
TextTransition.delay = 0
TextTransition.delayTimer = 0
TextTransition.hold = 0
TextTransition.holdTimer = 0

TextTransition.onMidpoint = nil

function TextTransition:start(
    text,
    font,
    x,
    targetY,
    speed,
    delay,
    hold,
    onMidpoint
)
    self.active = true

    self.text = text or self.defaultText
    self.font = font or self.defaultFont
    self.x = x or self.defaultX
    self.targetY = targetY or self.defaultTargetY

    self.y = love.graphics.getHeight() + 20
    self.alpha = 1

    self.speed = speed or self.defaultSpeed
    self.delay = delay or self.defaultDelay
    self.hold = hold or self.defaultHold

    self.delayTimer = 0
    self.holdTimer = 0

    self.onMidpoint = onMidpoint

    self.phase = (self.delay > 0) and 'delay' or 'in'
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
        self.holdTimer = self.holdTimer + dt
        if self.holdTimer >= self.hold then
            self.phase = 'out'
        end

    elseif self.phase == 'out' then
        self.y = self.y - self.speed * dt
        self.alpha = math.max(0, self.alpha - dt * 1.5)

        if self.alpha <= 0 then
            self.active = false
        end
    end
end

function TextTransition:render()
    if not self.active then return end

    love.graphics.setFont(self.font)

    local textWidth = self.font:getWidth(self.text)

    -- Blur background
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- Shadow
    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.printf(
        self.text,
        math.floor(self.x - textWidth / 2) + 2,
        math.floor(self.y),
        textWidth,
        'center'
    )

    -- Text
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.printf(
        self.text,
        math.floor(self.x - textWidth / 2),
        math.floor(self.y - 4),
        textWidth,
        'center'
    )

    love.graphics.setColor(1, 1, 1, 1)
end


return TextTransition
