Transition = {}

Transition.active = false
Transition.alpha = 0
Transition.phase = 'delay' -- 'delay' -> 'in' -> 'out'

-- Defaults
Transition.defaultSpeed = 1.5
Transition.defaultDelay = 0

-- Runtime values
Transition.speed = Transition.defaultSpeed
Transition.delay = 0
Transition.delayTimer = 0
Transition.onMidpoint = nil

function Transition:start(onMidpoint, speed, delay)
    self.active = true
    self.alpha = 0

    self.phase = (delay and delay > 0) and 'delay' or 'in'
    self.delay = delay or self.defaultDelay
    self.delayTimer = 0

    self.speed = speed or self.defaultSpeed
    self.onMidpoint = onMidpoint
end

function Transition:update(dt)
    if not self.active then return end
    print(self.delay, self.delayTimer, self.phase)

    if self.phase == 'delay' then
        self.delayTimer = self.delayTimer + dt
        if self.delayTimer >= self.delay then
            self.phase = 'in'
        end

    elseif self.phase == 'in' then
        self.alpha = math.min(1, self.alpha + self.speed * dt)

        if self.alpha >= 1 then
            if self.onMidpoint then
                self.onMidpoint()
                self.onMidpoint = nil
            end
            self.phase = 'out'
        end

    elseif self.phase == 'out' then
        self.alpha = math.max(0, self.alpha - self.speed * dt)

        if self.alpha <= 0 then
            self.active = false
        end
    end
end

function Transition:render()
    if not self.active then return end

    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.rectangle(
        'fill',
        0,
        0,
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT
    )
    love.graphics.setColor(1, 1, 1, 1)
end

return Transition
