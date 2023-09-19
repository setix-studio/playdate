local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Cloud').extends(AnimatedSprite)

function Cloud:init()

    cloudImage  = gfx.image.new("assets/images/cloud" .. math.random(1,3))
    self:setZIndex(math.random(0,200))
    self:setImage(cloudImage)
    self:add()
    self.x = math.random(320, 480)
    self.y = math.random(0, 220)
    self:moveTo(self.x, self.y)

    self.speed = math.random(1,3)
    
    
end
function Cloud:update()
  self.x -= self.speed + math.random(1,2)
 
  self:moveTo(self.x, self.y)

  if self.x <= -60 then
    self:remove()
    cloudImage  = gfx.image.new("assets/images/cloud" .. math.random(1,3))
    self:setImage(cloudImage)
    self:add()
    self.x = math.random(420, 480)
    self.y = math.random(20, 180)
    self:moveTo(self.x, self.y)
  end
end