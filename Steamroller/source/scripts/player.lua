local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk


class('Player').extends(AnimatedSprite)

function Player:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local playerImageTable = gfx.imagetable.new("assets/images/player-table-48-48")
    Player.super.init(self, playerImageTable)

    self:addState("idle", 1, 1, { tickStep = 1 })
    self:addState("moving", 1, 4, { tickStep = self.speed })
    self.currentState = "idle"
    self:playAnimation()

    self:moveTo(x, y)
    self:setZIndex(Z_INDEXES.Player)
    self:setCenter(0, 0)
    --self:setCollideRect(8, 10, 28, 28)
    self:setCollideRect(0, 0, self:getSize())
    self:setTag(TAGS.Player)

    self.speed = 0
    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false

    sfxMole = pd.sound.fileplayer.new('assets/sounds/sfx_mole')
    sfxSquish = pd.sound.fileplayer.new('assets/sounds/sfx_squished')
    sfxDrive = pd.sound.fileplayer.new('assets/sounds/sfx_drive')
    sfxBackup = pd.sound.fileplayer.new('assets/sounds/sfx_backup')
end

function Player:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Enemy or tag == TAGS.Prop then
        return gfx.sprite.kCollisionTypeOverlap
    else
        return gfx.sprite.kCollisionTypeFreeze
    end
end

function Player:update()
    if paused == false then
        self:handleMovementAndCollisions()
        self:updateAnimation()
        self:setCollideRect(0, 0, self:getSize())
        --  if angle <= 359  and angle >= 181 then
        --      self:setCollideRect(20, 20, 28, 28)
        --  elseif angle <= 180  and angle >= 100 then
        --      self:setCollideRect(20, 20, 28, 28)
        -- elseif angle <= 179  and angle >= 91 then
        --     self:setCollideRect(20, 20, 28, 28)
        --end
        if enemyCounter >= 10 then

        end
    end
end

function Player:handleMovementAndCollisions()
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
    angle = angle



    if pd.buttonIsPressed('up') then
        self.speed = 2
        sfxDrive:setVolume(0.6)
        sfxDrive:play()
        self:changeToMovingState()
        self:moveTo(x, y)
    elseif pd.buttonIsPressed('down') then
        self.speed = -1
        sfxBackup:setVolume(0.2)
        sfxBackup:play()
        self:changeToMovingState()
        self:moveTo(x, y)
    elseif pd.buttonJustReleased('down') then
        sfxBackup:stop()
    else
        sfxDrive:stop()
        self:changeToIdleState()
    end
    self:setRotation(angle)
    gfx.sprite.update()
    self:setCenter(0.5, 0.5)
    self:setCollideRect(10, 10, 28, 28)
    local _, _, collisions, length = self:moveWithCollisions(self.x, self.y)
    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false
    for i = 1, length do
        local collision = collisions[i]
        local collisionType = collision.type
        local collisionObject = collision.other
        local collisionTag = collisionObject:getTag()
        collisionObject:alphaCollision(self)
        self:alphaCollision(collisionObject)
        if collisionType == gfx.sprite.kCollisionTypeOverlap then
            if self:alphaCollision(collisionObject) then
                if collisionTag == TAGS.Enemy then
                    score += 1
                    enemyCounter -= 1
                    levelTime += enemyState

                    sfxMole:play()
                    sfxSquish:play()
                    collisionObject.remove(collisionObject)
                end
                if collisionTag == TAGS.Prop then
                    collisionObject:changetoDestroyState()

                    sfxBarrelHit:play()
                    sfxBarrelDestroy:play()
                end
            end
        end
    end
end

function Player:changeToIdleState()
    self:changeState("idle")
end

function Player:changeToMovingState()
    self:changeState("moving")
end
