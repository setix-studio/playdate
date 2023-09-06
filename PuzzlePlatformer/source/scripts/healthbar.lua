local pd <const> = playdate
local gfx <const> = pd.graphics

class('Healthbar').extends(gfx.sprite)

function Healthbar:init(x, y, maxHealth)
    Healthbar.super.init(self)
    self.maxHealth = maxHealth
    _G.health = maxHealth
    self:moveTo(x, y)
    self:updateHealth(maxHealth)
    self:add()
end

function Healthbar:updateHealth(newHealth)
    local maxWidth = 100
    local height = 10
    local healthbarWidth = (newHealth / self.maxHealth) * maxWidth
    local healthbarImage = gfx.image.new(maxWidth, height)
    gfx.pushContext(healthbarImage)
        gfx.fillRect(0, 0, healthbarWidth, height)
    gfx.popContext()
    self:setImage(healthbarImage)
end



function Healthbar:damage(amount)
    _G.health -= amount
    
    self:updateHealth(_G.health)
end