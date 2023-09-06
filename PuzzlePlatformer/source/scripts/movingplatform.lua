local gfx <const> = playdate.graphics

local movingplatformImage <const> = gfx.image.new("images/platform")

class('Movingplatform').extends(gfx.sprite)

function Movingplatform:init(x, y, entity)
    self:setZIndex(Z_INDEXES.Platform)
    self:setImage(movingplatformImage)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
    assert(movingplatformImage)
    self:setTag(TAGS.Platform)
    self:setCollideRect(2, 2, 12, 12)

    local fields = entity.fields
    self.xVelocity = fields.xVelocity
    self.yVelocity = fields.yVelocity
end

function Movingplatform:collisionResponse(other)
    if other:getTag() == TAGS.Player then
        Player.xVelocity = self.xVelocity
        Player.yVelocity = self.yVelocity
        return gfx.sprite.kCollisionTypeSlide

    end
    return gfx.sprite.kCollisionTypeBounce
end

function Movingplatform:update()
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
    local hitWall = false
    for i=1,length do
        local collision = collisions[i]
        if collision.other:getTag() ~= TAGS.Player then
            hitWall = true
        end
    end

    if hitWall then
        self.xVelocity *= -1
        self.yVelocity *= -1
    end
end