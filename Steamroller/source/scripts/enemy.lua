local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Enemy').extends(AnimatedSprite)

function Enemy:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local playerImageTable = gfx.imagetable.new("assets/images/mole-table-24-24")
    Player.super.init(self, playerImageTable)

    self:addState("idle", 1, 4, { tickStep = 4 })
    self:playAnimation()

    x = math.random(10, 380)
    y = math.random(10, 200)
    self:playAnimation()
    -- Sprite properties
    self:moveTo(x, y)
    self:setZIndex(Z_INDEXES.Enemy)
    self:setCollideRect(5, 4, 14, 18)
    self:setTag(TAGS.Enemy)

    --Sprite Attributes
end

function Enemy:collisionResponse(other)
   
    return "overlap"
end


function Enemy:handleMovementAndCollisions()
    local _, _, collisions, length = self:moveWithCollisions(self.x, self.y)

    for i = 1, length do
        local collision = collisions[i]
        local collisionType = collision.type
        local collisionObject = collision.other
        local collisionTag = collisionObject:getTag()
            if collisionTag == TAGS.Building then
                    self:remove()
            end
     
        
    end
end

function Enemy:update()
    self:updateAnimation()

    self:handleMovementAndCollisions()
end