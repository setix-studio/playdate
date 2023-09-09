local pd <const> = playdate
local gfx <const> = pd.graphics

class('HUD').extends(Player)

function HUD:createHUD()
    gfx.setColor(gfx.kColorWhite)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
   

    keySprite = gfx.sprite.new()
   
    self:updateDisplay()
    keySprite:setCenter(0, 0)
    keySprite:moveTo(320, 8)
    keySprite:add()
    hbX= 60
    hbY = 20
    hbMax = 100
    Player.healthBar = Healthbar(hbX, hbY, hbMax)
   
end

function HUD:updateDisplay()
    keyText = "KEYS: " .. _G.keyTotal
   local ktextWidth, ktextHeight = gfx.getTextSize(keyText)
    local keyImage = gfx.image.new(ktextWidth + 5, ktextHeight)
    gfx.pushContext(keyImage)
    playdate.graphics.setFont(font1)
        gfx.drawText(keyText, 0, 0, font)
    gfx.popContext()
    keySprite:setImage(keyImage)
    
end

function HUD:update()
    self:updateDisplay()
end

function HUD:incrementKeys()
    _G.keyTotal += 1
    self:updateDisplay()
end
function HUD:decreaseKeys()
    _G.keyTotal -= 1
    self:updateDisplay()
end

function HUD:resetKeys()
    _G.keyTotal = 0
    self:updateDisplay()
end

class('Healthbar').extends(gfx.sprite)

function Healthbar:init(x, y, maxHealth, currentHealth)
    Healthbar.super.init(self)
    self.maxHealth = maxHealth
    _G.health = maxHealth
    self.currentHealth = _G.health
    currentHealth = self.maxHealth
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