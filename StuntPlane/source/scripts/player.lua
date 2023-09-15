local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Player').extends(AnimatedSprite)

function Player:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local playerImageTable = gfx.imagetable.new("assets/images/testplane-table-64-64")
    Player.super.init(self, playerImageTable)

    self:addState("straight", 1, 2, { tickStep = 1 })
    self:addState("turndown", 3, 4, { tickStep = 1 })
    self:addState("flatup", 5, 6, { tickStep = 1 })

    siren = playdate.sound.fileplayer.new("assets/sounds/siren")
    siren:setVolume(0)
    siren:play()
    self:playAnimation()
    sirenVol = 0
    -- Sprite properties
    self:moveTo(x, y)
    self:setZIndex(Z_INDEXES.Player)
    self:setCollideRect(2, 2, 20, 22)
    self:setTag(TAGS.Player)
    
    --Sprite Attributes
    self.speed = 0
    self.rotation = 0
    self.flip = 0
end

function Player:update()
    self:updateAnimation()
    self:movePlane()
    

    self:changeToStraightState()
    
end

function Player:movePlane()
    
    -- if self.y <= 10  then
    --     self.y = 10
    -- elseif self.y >= 210 then
    --     self.y = 210
    -- end
    -- self.y += self.speed
    -- local change, acceleratedChange = pd.getCrankChange()
    -- self.speed += change /10
    -- self:moveTo(self.x, self.y)

    
    local change, acceleratedChange = pd.getCrankChange()
    
    sirenVol += change / 1000
    
    siren:setVolume(sirenVol)
  
end

function Player:changeToStraightState()
    self:changeState("straight")
    
end

function Player:changeToTurnDownState()
    self:changeState("turndown")
    
end

function Player:changeToFlatUpState()
    self:changeState("flatup")
    
end

