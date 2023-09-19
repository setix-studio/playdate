local pd <const> = playdate
local gfx <const> = playdate.graphics

class('SkyBG').extends(AnimatedSprite)

function SkyBG:init()
    
    local skyImage <const> = gfx.image.new("assets/images/sky")
    self:setZIndex(Z_INDEXES.BG)
    self:setImage(skyImage)
    self:add()
 
end
function SkyBG:update()
  
end