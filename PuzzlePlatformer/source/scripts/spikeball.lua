local gfx <const> = playdate.graphics



class('Spikeball').extends(AnimatedSprite)


function Spikeball:init(x, y, entity)
    imagetable = gfx.imagetable.new("images/burst-table-16-16")
    self:setZIndex(Z_INDEXES.Hazard)
    Spikeball.super.init(self, imagetable)
    self:addState("idle")
    self.currentState = "idle"
    self.platformOn = false
    self:setImage(image)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:playAnimation()


    self:setTag(TAGS.Laser)
    self:setCollideRect(4, 4, 8, 8)

    local fields = entity.fields
    self.xVelocity = fields.xVelocity
    self.yVelocity = fields.yVelocity
end

function Spikeball:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Player then
        return gfx.sprite.kCollisionTypeOverlap
    end
    if tag == TAGS.Pickup or tag == TAGS.Hazard or tag == TAGS.Camera or tag == TAGS.Prop then
        return gfx.sprite.kCollisionTypeSlide
    end
    return gfx.sprite.kCollisionTypeBounce
end

function Spikeball:update()
    self:updateAnimation()
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)
    local hitWall = false
    for i = 1, length do
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
