Transition = {}

Transition.active = false
Transition.alpha = 0
Transition.speed = 1.5
Transition.onMidpoint = nil
Transition.phase = 'in' -- 'in' -> 'out'

function Transition:start(onMidpoint)
    self.active = true
    self.alpha = 0
    self.phase = 'in'
    self.onMidpoint = onMidpoint
end

function Transition:update(dt)
    if not self.active then return end

    if self.phase == 'in' then
        self.alpha = math.min(1, self.alpha + self.speed * dt)

        if self.alpha >= 1 then
            if self.onMidpoint then
                self.onMidpoint()
                self.onMidpoint = nil
            end
            self.phase = 'out'
        end
    else
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
