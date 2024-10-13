local gfx <const> = playdate.graphics


class('Camera').extends(AnimatedSprite)

function Camera:init(x, y, entity)
    frameCount = 1
    local cameraImage = gfx.image.new("images/camera" .. frameCount)
    self:setImage(cameraImage)

    self:setZIndex(Z_INDEXES.Prop)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:setTag(TAGS.Camera)

    self.fields = entity.fields
    _G.cameraX = self.fields.xPos
    _G.cameraY = self.y
end

function Camera:collisionResponse(other)
    if other:getTag() == TAGS.Chef then
        return gfx.sprite.kCollisionTypeOverlap
    end
end

function Camera:update()
    local cameraImage = gfx.image.new("images/camera" .. frameCount)
    self:setImage(cameraImage)
end
