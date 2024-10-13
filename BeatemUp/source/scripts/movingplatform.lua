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
    self:setCollideRect(0, 0, 14, 14)

    self.fields = entity.fields
    self.isMoving = false
    self.xVelocity = 0
    self.yVelocity = 0
    self:Moving()
    hitWall = false
end

function Movingplatform:collisionResponse(other)
    if other:getTag() == TAGS.Chef then
        Chef.xVelocity = self.xVelocity
        Chef.yVelocity = self.yVelocity
        return gfx.sprite.kCollisionTypeSlide
    elseif other:getTag() == TAGS.Hazard then
        return gfx.sprite.kCollisionTypeOverlap
    end

    return gfx.sprite.kCollisionTypeBounce
end

function Movingplatform:update()
    if _G.isMoving == true then
        self:Moving()
    end
end

function Movingplatform:Moving()
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)

    for i = 1, length do
        local collision = collisions[i]
        if collision.other:getTag() ~= TAGS.Chef then
            hitWall = true
        end
    end
    if hitWall == true and self.xVelocity == -1 then
        self.xVelocity = self.xVelocity * -1
        self.yVelocity = self.yVelocity * -1
        hitWall = false
    elseif hitWall == true and self.xVelocity == 1 then
        self.xVelocity = self.xVelocity * -1
        self.yVelocity = self.yVelocity * -1
        hitWall = false
    elseif hitWall == false and self.xVelocity == 0 then
        self.xVelocity = self.fields.xVelocity
        self.yVelocity = self.fields.yVelocity
    end
    print(self.xVelocity)
end
