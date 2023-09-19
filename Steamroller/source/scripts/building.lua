local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Building').extends(AnimatedSprite)

function Building:init()
    Building = gfx.image.new("assets/images/building")
    self:setImage(Building)
    
    self.x = math.random(40, 380)
    self.y = math.random(40, 200)
    self:moveTo(self.x, self.y)
    self:setZIndex(Z_INDEXES.Building)
    self:setCollideRect(4, 4, 118, 118 )
    self:setTag(TAGS.Building)

    self:add()

end

