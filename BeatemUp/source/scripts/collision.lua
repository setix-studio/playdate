local pd <const> = playdate
local gfx <const> = pd.graphics

class('Collision').extends(AnimatedSprite)

function Collision:init(x, y, entity)
  self.fields = entity.fields


  self:setTag(TAGS.Collision)
  self:moveTo(x, y)
  self:add()
  self:setCollideRect(0, 0, self:getSize())
end
function Collision:collisionResponse(other)
  return "overlap"
end