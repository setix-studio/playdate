local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Enemy').extends(AnimatedSprite)
function Enemy:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local playerImageTable = gfx.imagetable.new("assets/images/enemy-table-16-16")
    Player.super.init(self, playerImageTable)

    self:addState("idle", 1, 1, { tickStep = 4 })
    self:addState("active", 2, 5, { tickStep = 4 })
    self:addState("dead", 6, 6, { tickStep = 4 })
    self.currentState = "idle"
    self:changeToIdleState()
    self:playAnimation()

    x = math.random(50, 380)
    y = math.random(50, 200)
    self:playAnimation()
    -- Sprite properties
    self:moveTo(x, y)
    self:setZIndex(Z_INDEXES.Enemy)
    self:setCollideRect(0, 0, 14, 16)
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
        if collisionType == gfx.sprite.kCollisionTypeOverlap and collisionTag ~= TAGS.Player then
            self:remove()
            enemyCounter -= 1
        end
    end
end

function Enemy:update()
    self:updateAnimation()

    self:handleMovementAndCollisions()
end

function Enemy:changeToIdleState()
    enemyState = 3
    spawnTimer = pd.timer.performAfterDelay(2000, function()
        self:changeToActiveState()
    end)
    self:changeState("idle")
end

function Enemy:changeToActiveState()
    enemyState = 2


    spawnTimer = pd.timer.performAfterDelay(5000, function()
        self:changeToDeadState()
    end)
    self:changeState("active")
end

function Enemy:changeToDeadState()
    enemyState = 1
    spawnTimer = pd.timer.performAfterDelay(2000, function()
        enemyCounter -= 1
        self:remove()
    end)
    self:changeState("dead")
end
