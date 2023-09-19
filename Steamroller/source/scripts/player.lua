local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Player').extends(AnimatedSprite)

function Player:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local playerImageTable = gfx.imagetable.new("assets/images/player-table-48-48")
    Player.super.init(self, playerImageTable)

    self:addState("north", 1, 1, { tickStep = 1 })
    self:addState("northeast", 2, 2, { tickStep = 1 })
    self:addState("northwest", 8, 8, { tickStep = 1 })
    self:addState("east", 3, 3, { tickStep = 1 })
    self:addState("south", 5, 5, { tickStep = 1 })
    self:addState("southeast", 4, 4, { tickStep = 1 })
    self:addState("southwest", 6, 6, { tickStep = 1 })
    self:addState("west", 7, 7, { tickStep = 1 })


    self:playAnimation()

    self:moveTo(x, y)
    self:setZIndex(Z_INDEXES.Player)
    self:setCollideRect(0, 0, self:getSize())
    self:setTag(TAGS.Player)

    self.speed = 2

    sfxSquish = pd.sound.fileplayer.new('assets/sounds/sfx_squished')
end

function Player:update()
    self:updateAnimation()
    self:movePlane()

    self:handleMovementAndCollisions()

    -- if _G.angle == 90 then
    --     self:changeToNorthState()
    -- elseif _G.angle > 0 and _G.angle < 90 then
    --     self:changeToNorthEastState()
    -- elseif _G.angle > 90 and _G.angle < 179 then
    --     self:changeToNorthWestState()
    -- elseif _G.angle == 0 then
    --     self:changeToEastState()
    -- elseif _G.angle == 180 then
    --     self:changeToWestState()
    -- elseif _G.angle > 180 and _G.angle < 269 then
    --     self:changeToSouthWestState()
    -- elseif _G.angle == 270 then
    --     self:changeToSouthState()
    -- elseif _G.angle > 270 and _G.angle < 359 then
    --     self:changeToSouthEastState()
    -- end
end

function Player:movePlane()
    if self.x <= 10 then
        self.x = 10
    elseif self.x >= 390 then
        self.x = 390
    elseif self.y <= 10 then
        self.y = 10
    elseif self.y >= 210 then
        self.y = 210
    end

    angle = pd.getCrankPosition()

    local x = self.x + self.speed * math.cos(math.rad(angle))
    local y = self.y + self.speed * math.sin(math.rad(angle))
    _G.angle = angle

    if pd.buttonIsPressed('up') then
        self.speed = 2
        self:moveTo(x, y)
    end
    if pd.buttonIsPressed('right') then
        self:moveTo(x, y)
    end
    if pd.buttonIsPressed('down') then
        self.speed = -2
        self:moveTo(x, y)
    end
    if pd.buttonIsPressed('left') then
        self:moveTo(x, y)
    end
    self:setRotation(angle)
    gfx.sprite.update()



    self:setCollideRect(0, 0, self:getSize())
end

function Player:changeToNorthState()
    self:changeState("north")
end

function Player:changeToNorthEastState()
    self:changeState("northeast")
end

function Player:changeToNorthWestState()
    self:changeState("northwest")
end

function Player:changeToEastState()
    self:changeState("east")
end

function Player:changeToSouthState()
    self:changeState("south")
end

function Player:changeToSouthEastState()
    self:changeState("southeast")
end

function Player:changeToSouthWestState()
    self:changeState("southwest")
end

function Player:changeToWestState()
    self:changeState("west")
end

function Player:collisionResponse()
    return "overlap"
end

function Player:handleMovementAndCollisions()
    local _, _, collisions, length = self:moveWithCollisions(self.x, self.y)

    for i = 1, length do
        local collision = collisions[i]
        local collisionType = collision.type
        local collisionObject = collision.other
        local collisionTag = collisionObject:getTag()
        if collisionType == gfx.sprite.kCollisionTypeOverlap then
            if collisionTag == TAGS.Enemy then
                if self:alphaCollision(collisionObject) then
                    _G.score += 1
                    sfxSquish:play()
                    collisionObject.remove(collisionObject)
                end
            end

            if collisionTag == TAGS.Building then
                if self:alphaCollision(collisionObject) then
                    self.speed = 0
                else
                    self.speed = 2
                end
            end
        end
    end
end

function Player:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Enemy then
        return gfx.sprite.kCollisionTypeOverlap
    else
        return gfx.sprite.kCollisionTypeOverlap
    end
end
