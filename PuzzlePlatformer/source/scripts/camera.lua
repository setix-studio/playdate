local gfx <const> = playdate.graphics


class('Camera').extends(AnimatedSprite)

function Camera:init(x, y, entity)
    frameCount = 1
    local cameraImage = gfx.image.new("images/camera"..frameCount)
    self:setImage(cameraImage)
    self:setZIndex(Z_INDEXES.Prop)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
    
    self:setTag(TAGS.Prop)
    self:setCollideRect(0, 0, self:getSize())

   self.fields = entity.fields
   _G.cameraX = self.fields.xPos
end



function Camera:update()
    
    local cameraImage = gfx.image.new("images/camera"..frameCount)
    self:setImage(cameraImage)
end