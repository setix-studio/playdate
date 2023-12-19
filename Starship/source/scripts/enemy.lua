local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Enemy').extends(AnimatedSprite)
function Enemy:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local enemyImageTable = gfx.imagetable.new("assets/images/asteroids-table-128-128")
    Enemy.super.init(self, enemyImageTable)
    asteroidFrame = math.random(1,5)
    self:addState("idle", asteroidFrame, asteroidFrame)
    self:addState("active", asteroidFrame, asteroidFrame)
    self:addState("dead", asteroidFrame, asteroidFrame)
    self.currentState = "idle"
    self:changeToIdleState()
    self:playAnimation()

    x = math.random(50, 1500)
    y = math.random(50, 2000)
    self:playAnimation()
    -- Sprite properties
    self:moveTo(x, y)
    self:setZIndex(math.random(0, 200))
    self:setCollideRect(0, 0, 14, 16)
    self:setTag(TAGS.Enemy)
    self.speed = math.random(3, 6)
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
        if collisionType == gfx.sprite.kCollisionTypeOverlap and collisionTag ~= TAGS.Player then
            -- self:remove()
        end
    end
end

function Enemy:update()
    self:updateAnimation()

    self.x += self.speed
    self.y += self.speed

    self:handleMovementAndCollisions()
end

function Enemy:changeToIdleState()
    spawnTimer = pd.timer.performAfterDelay(100, function()
        self:changeToActiveState()
    end)
    self:changeState("idle")
end

function Enemy:changeToActiveState()
    spawnTimer = pd.timer.performAfterDelay(22000, function()
        self:changeToDeadState()
    end)

    self:changeState("active")
end

function Enemy:changeToDeadState()
    spawnTimer = pd.timer.performAfterDelay(2000, function()
        self:remove()
    end)
    self:changeState("dead")
end
