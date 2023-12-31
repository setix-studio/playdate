local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk


class('Player').extends(AnimatedSprite)

function Player:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local playerImageTable = gfx.imagetable.new("images/norman-table-24-24")
    Player.super.init(self, playerImageTable)

    self:addState("idle", 1, 2, { tickStep = 8 })
    self:addState("run", 3, 6, { tickStep = 4 })
    self:addState("jump", 6, 6)
    self:addState("dash", 7, 7)
    self:addState("platform", 1, 2, { tickStep = 8 })
    self:addState("ceiling", 8, 8, { tickStep = 8 })
    self:addState("floor", 1, 2, { tickStep = 8 })

    self:playAnimation()

    -- Sprite properties
    self:moveTo(x, y)
    self:setZIndex(Z_INDEXES.Player)
    self:setCollideRect(4, 2, 18, 22)
    self:setTag(TAGS.Player)

    -- Physics properties
    self.xVelocity = 0
    self.yVelocity = 0
    self.gravity = 1.0
    self.maxSpeed = 3
    self.jumpVelocity = -6
    self.drag = 0.1
    self.minimumAirSpeed = 0.5

    self.jumpBufferAmount = 5
    self.jumpBuffer = 0

    -- Abilities
    self.doubleJumpAbility = false
    self.dashAbility = false
    self.ceilingCling = false

    -- Double Jump
    self.doubleJumpAvailable = true

    -- Dash
    self.dashAvailable = true
    self.dashSpeed = 10
    self.dashMinimumSpeed = 5
    self.dashDrag = 0.8

    -- Player State
    self.dir = 1
    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false
    self.dead = false
    self.hasKey = false
    self.hasAlphaKey = false

    self.TextboxShow = false

    _G.AlphaKey = false
    _G.BetaKey = false
    _G.SigmaKey = false
    _G.GammaKey = false
    --SFX
    sfxRun = pd.sound.fileplayer.new('assets/sounds/sfx/footstep')
end

function Player:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Pickup or tag == TAGS.Hazard or tag == TAGS.Camera or tag == TAGS.Prop or tag == TAGS.Laser then
        return gfx.sprite.kCollisionTypeOverlap
    end
    return gfx.sprite.kCollisionTypeSlide
end

function Player:update()
    if self.dead then
        return
    end

    _G.keyTotal = _G.keyTotal

    self:updateJumpBuffer()

    if _G.paused == false then
        self:handleState()
        self:handleMovementAndCollisions()
        self:updateAnimation()
    else
        self:changeToIdleState()
    end
    self:cameraFollow()
end

function Player:cameraFollow()
    if self.x < _G.cameraX - 20 then
        frameCount = 1
    elseif self.x < _G.cameraX - 20 then
        frameCount = 1
    elseif self.x > _G.cameraX + 30 then
        frameCount = 5
    elseif self.x < _G.cameraX - 10 then
        frameCount = 2
    elseif self.x > _G.cameraX + 20 then
        frameCount = 4
    else
        frameCount = 3
    end
end

function Player:updateJumpBuffer()
    self.jumpBuffer -= 1
    if self.jumpBuffer <= 0 then
        self.jumpBuffer = 0
    end
    if pd.buttonJustPressed(pd.kButtonA) then
        self.jumpBuffer = self.jumpBufferAmount
    end
    if self.gravity == -1 then
        self:setImageFlip(gfx.kImageFlippedY)
    end
end

function Player:playerJumped()
    return self.jumpBuffer > 0
end

function Player:handleState()
    if self.currentState == "idle" then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == "run" then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == "ceiling" then
        self:applyGravity()
        self:handleGroundInput()
    elseif self.currentState == "jump" then
        if self.touchingGround then
            self:changeToIdleState()
        end
        self:applyGravity()
        self:applyDrag(self.drag)
        self:handleAirInput()
    elseif self.currentState == "dash" then
        self:applyDrag(self.dashDrag)
        if math.abs(self.xVelocity) <= self.dashMinimumSpeed then
            self:changeToFallState()
        end
    end
end

function Player:handleMovementAndCollisions()
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)

    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false
    self.onPlatform = false
    local died = false

    for i = 1, length do
        local collision = collisions[i]
        local collisionType = collision.type
        local collisionObject = collision.other
        local collisionTag = collisionObject:getTag()
        if collisionType == gfx.sprite.kCollisionTypeSlide then
            if collision.normal.y == -1 then
                self.touchingGround = true
                self.doubleJumpAvailable = true
                self.dashAvailable = true
            elseif collision.normal.y == 1 then
                self.touchingCeiling = true
            end

            if collision.normal.x ~= 0 then
                self.touchingWall = true
            end

            if not pd.buttonIsPressed(pd.kButtonA) then
                if not pd.buttonIsPressed(pd.kButtonLeft) then
                    if not pd.buttonIsPressed(pd.kButtonRight) then
                        if collisionTag == TAGS.Platform and collision.normal.y == -1 then
                            self.onPlatform = true
                            self.doubleJumpAvailable = true
                            self.dashAvailable = true
                            if collision.other.xVelocity > 0 or collision.other.xVelocity < 0 then
                                self.xVelocity = collision.other.xVelocity
                            elseif collision.other.yVelocity > 0 or collision.other.yVelocity < 0 then
                                self:changeToIdleState()
                            end
                            self:changeToPlatformState()
                        end
                    else
                        self:changeToRunState("right")
                        self:changeState("run")
                    end
                else
                    self:changeToRunState("left")
                    self:changeState("run")
                end
            else
                self:changeToRunState("jump")
                self:changeState("jump")
            end
        end

        if collisionTag == TAGS.Camera then
            self.cameraRange = true
        elseif collisionTag ~= TAGS.Camera then
            self.cameraRange = false
        end
        if collisionTag == TAGS.Laser then
            self:die()
            -- self:damage(1)
            -- if _G.health <= 0 then
            --     _G.health = 0
            --     died = true
            -- end
        elseif collisionTag == TAGS.Spikes then
            self:die()
        elseif collisionTag == TAGS.Pickup then
            collisionObject:pickUp(self)
        elseif collisionTag == TAGS.Door and self.hasKey == true and self.hasAlphaKey == true and _G.doorType == "Alpha" then
            if _G.doorType == "Alpha" then
                collisionObject.fields.unlocked = true
                collisionObject.remove(collisionObject)
                self.hasAlphaKey = false
                _G.AlphaKey = false
                _G.keyTotal -= 1
                if _G.keyTotal <= 0 then
                    self.hasKey = false
                end
            end
        elseif collisionTag == TAGS.Door and self.hasKey == true and self.hasBetaKey == true and _G.doorType == "Beta" then
            if _G.doorType == "Beta" then
                collisionObject.fields.unlocked = true
                collisionObject.remove(collisionObject)
                self.hasBetaKey = false
                _G.BetaKey = false
                _G.keyTotal -= 1
                if _G.keyTotal <= 0 then
                    self.hasKey = false
                end
            end
        elseif collisionTag == TAGS.Door and self.hasKey == true and self.hasSigmaKey == true and _G.doorType == "Sigma" then
            collisionObject.fields.unlocked = true
            collisionObject.remove(collisionObject)
            self.hasSigmaKey = false
            _G.SigmaKey = false
            _G.keyTotal -= 1
            if _G.keyTotal <= 0 then
                self.hasKey = false
            end
        elseif collisionTag == TAGS.Door and self.hasKey == true and self.hasGammaKey == true and _G.doorType == "Gamma" then
            collisionObject.fields.unlocked = true
            collisionObject.remove(collisionObject)
            self.hasGammaKey = false
            _G.GammaKey = false
            _G.keyTotal -= 1
            if _G.keyTotal <= 0 then
                self.hasKey = false
            end
        end
    end
    if self.xVelocity < 0 then
        self.globalFlip = 1
    elseif self.xVelocity > 0 then
        self.globalFlip = 0
    end

    if self.x < 0 then
        self.gameManager:enterRoom("west")
    elseif self.x > 400 then
        self.gameManager:enterRoom("east")
    elseif self.y < 0 then
        self.gameManager:enterRoom("north")
    elseif self.y > 240 then
        self.gameManager:enterRoom("south")
    end
    if died then
        self:die()
    end
end

function Player:damage(amount)

end

function Player:die()
    self.xVelocity = 0
    self.yVelocity = 0
    self.dead = true
    self:setCollisionsEnabled(false)
    pd.timer.performAfterDelay(200, function()
        self:setCollisionsEnabled(true)
        self.gameManager:resetPlayer()
        self.dead = false
    end)
end

-- Input Helper Functions
function Player:handleGroundInput(direction)
    if self:playerJumped() then
        self:changeToJumpState()
    elseif pd.buttonIsPressed(pd.kButtonLeft) and pd.buttonJustPressed(pd.kButtonB) and self.dashAvailable and self.dashAbility then
        self:changeToDashState()
    elseif pd.buttonIsPressed(pd.kButtonRight) and pd.buttonJustPressed(pd.kButtonB) and self.dashAvailable and self.dashAbility then
        self:changeToDashState()
    elseif pd.buttonIsPressed(pd.kButtonLeft) then
        self:changeToRunState("left")
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self:changeToRunState("right")
    else
        self:changeToIdleState()
    end
end

function Player:handleAirInput()
    if self:playerJumped() and self.doubleJumpAvailable and self.doubleJumpAbility then
        self.doubleJumpAvailable = false
        if self.gravity == -1 then
            self:setImageFlip(gfx.kImageFlippedY)
        end
        self:changeToJumpState()
    elseif pd.buttonJustPressed(pd.kButtonB) and self.dashAvailable and self.dashAbility then
        if self.gravity == -1 then
            self:setImageFlip(gfx.kImageFlippedY)
        end
        self:changeToDashState()
    elseif pd.buttonIsPressed(pd.kButtonLeft) then
        self.xVelocity = -self.maxSpeed
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.xVelocity = self.maxSpeed
    end
end

-- State transitions
function Player:changeToIdleState()
    self.xVelocity = 0

    self:changeState("idle")
end

function Player:changeToRunState(direction)
    if direction == "left" then
        self.xVelocity = -self.maxSpeed
        self.globalFlip = 1
    elseif direction == "right" then
        self.xVelocity = self.maxSpeed
        self.globalFlip = 0
    end

    self:changeState("run")
end

function Player:changeToJumpState()
    if self.gravity == -1 then
        self.yVelocity = -self.jumpVelocity
        self:setImageFlip(gfx.kImageFlippedY)
    else
        self.yVelocity = self.jumpVelocity
    end
    self.jumpBuffer = 0
    self:changeState("jump")
end

function Player:changeToFallState()
    if self.gravity == -1 then
        self:setImageFlip(gfx.kImageFlippedY)
    end
    self:changeState("jump")
end

function Player:changeToPlatformState()
    self:changeState("platform")
end

function Player:changeToDashState()
    self.dashAvailable = false
    self.yVelocity = 0
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self.xVelocity = -self.dashSpeed
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.xVelocity = self.dashSpeed
    else
        if self.globalFlip == 1 then
            self.xVelocity = -self.dashSpeed
        else
            self.xVelocity = self.dashSpeed
        end
    end
    self:changeState("dash")
end

-- Physics Helper Functions
function Player:applyGravity()
    self.yVelocity += self.gravity
    if self.touchingGround or self.touchingCeiling then
        self.yVelocity = 0
    end
end

function Player:applyDrag(amount)
    if self.xVelocity > 0 then
        self.xVelocity -= amount
    elseif self.xVelocity < 0 then
        self.xVelocity += amount
    end

    if math.abs(self.xVelocity) < self.minimumAirSpeed or self.touchingWall then
        self.xVelocity = 0
    end
end
