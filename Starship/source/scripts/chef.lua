local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk


class('Chef').extends(AnimatedSprite)

function Chef:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local chefImageTable = gfx.imagetable.new("/assets/images/chef2-table-32-32")
    Chef.super.init(self, chefImageTable)

    self:addState("idle", 1, 4, { tickStep = 4 })
    self:addState("run", 5, 11, { tickStep = 4 })
    self:addState("jump", 5, 5)
    self:addState("dash", 9, 9)


    self:playAnimation()
    ChefInteractBtn()
    showIntBtn = false
    -- Sprite properties
    self:moveTo(x, y)
    self:setZIndex(Z_INDEXES.Player)
    self:setCollideRect(10, 13, 11, 16)
    self:setTag(TAGS.Chef)

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
    self.doubleJumpAbility = true
    self.dashAbility = true
    self.ceilingCling = false

    -- Double Jump
    self.doubleJumpAvailable = true

    -- Dash
    self.dashAvailable = true
    self.dashSpeed = 10
    self.dashMinimumSpeed = 5
    self.dashDrag = 0.8

    -- Chef State
    self.dir = 1
    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false
    self.dead = false
    self.hasKey = false
    self.hasAlphaKey = false

    self.TextboxShow = false
    Sidekick()
    chefX = self.x
    chefY = self.y

    _G.AlphaKey = false
    _G.BetaKey = false
    _G.SigmaKey = false
    _G.GammaKey = false
    --SFX
    dash = pd.sound.fileplayer.new('assets/sounds/dash')
    dash:setVolume(.7)
    jump = pd.sound.fileplayer.new('assets/sounds/jump')
    jump:setVolume(.7)
end

function Chef:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Pickup or tag == TAGS.Hazard or tag == TAGS.Camera or tag == TAGS.Prop or tag == TAGS.Laser or tag == TAGS.Ship then
        return gfx.sprite.kCollisionTypeOverlap
    end
    return gfx.sprite.kCollisionTypeSlide
end

function Chef:update()
    if self.dead then
        return
    end
    chefX = self.x
    chefY = self.y
    _G.keyTotal = _G.keyTotal

    self:updateJumpBuffer()

    if _G.paused == false then
        self:handleState()
        self:handleMovementAndCollisions()
        self:updateAnimation()
    else
        self:changeToIdleState()
    end
end

function Chef:updateJumpBuffer()
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

function Chef:chefJumped()
    return self.jumpBuffer > 0
end

function Chef:handleState()
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

function Chef:handleMovementAndCollisions()
    newX = math.floor(self.x - 200, 400)
    newY = math.floor(self.y - 120, 240)
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.xVelocity, self.y + self.yVelocity)

    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false
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
        end

        if collisionTag == TAGS.Ship then
            showIntBtn = true
            jump:setVolume(0)
            if pd.buttonJustReleased(pd.kButtonA) then
                limamusic:stop()
                lavenmusic:stop()

                ShipTakeoff()
                spawnTimer = pd.timer.performAfterDelay(3100, function()
                    levelNum = 0

                    manager:push(LoadingScene())
                end)
            end
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

function Chef:damage(amount)

end

function Chef:die()
    self.xVelocity = 0
    self.yVelocity = 0
    self.dead = true
    self:setCollisionsEnabled(false)
    pd.timer.performAfterDelay(200, function()
        self:setCollisionsEnabled(true)
        self.gameManager:resetChef()
        self.dead = false
    end)
end

-- Input Helper Functions
function Chef:handleGroundInput(direction)
    if self:chefJumped() then
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

function Chef:handleAirInput()
    if self:chefJumped() and self.doubleJumpAvailable and self.doubleJumpAbility then
        self.doubleJumpAvailable = false

        self:changeToJumpState()
    elseif pd.buttonJustPressed(pd.kButtonB) and self.dashAvailable and self.dashAbility then
        self:changeToDashState()
    elseif pd.buttonIsPressed(pd.kButtonLeft) then
        self.xVelocity = -self.maxSpeed
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self.xVelocity = self.maxSpeed
    end
end

-- State transitions
function Chef:changeToIdleState()
    self.xVelocity = 0
    posX = false
    negX = false

    self:changeState("idle")
end

function Chef:changeToRunState(direction)
    if direction == "left" then
        followLeft = true

        self.xVelocity = -self.maxSpeed
        self.globalFlip = 1
    elseif direction == "right" then
        followLeft = false

        self.xVelocity = self.maxSpeed
        self.globalFlip = 0
    end
    if direction == "left" and self.touchingWall == false then
        posX = true
        negX = false
    elseif direction == "right" and self.touchingWall == false then
        posX = false
        negX = true
    end
    self:changeState("run")
end

function Chef:changeToJumpState()
    jump:play()
    self.yVelocity = self.jumpVelocity
    if self.touchingWall == false then
        self.jumpBuffer = 0
    end
    self:changeState("jump")
end

function Chef:changeToFallState()
    self:changeState("jump")
end

function Chef:changeToDashState()
    dash:play()
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
function Chef:applyGravity()
    self.yVelocity += self.gravity
    if self.touchingGround or self.touchingCeiling then
        self.yVelocity = 0
    end
end

function Chef:applyDrag(amount)
    if self.xVelocity > 0 then
        self.xVelocity -= amount
    elseif self.xVelocity < 0 then
        self.xVelocity += amount
    end

    if math.abs(self.xVelocity) < self.minimumAirSpeed or self.touchingWall then
        self.xVelocity = 0
    end
end

class('ChefInteractBtn').extends(AnimatedSprite)

function ChefInteractBtn:init(x, y)
    btnImageTable = gfx.imagetable.new("assets/images/abtn-table-16-16")
    InteractBtn.super.init(self, btnImageTable)

    self:addState("hide", 1, 1, { tickStep = 1 })
    self:addState("show", 2, 2, { tickStep = 1 })
    self.currentState = "show"
    self:playAnimation()

    self:setCenter(0, 0)
    self:add()
    self:setZIndex(Z_INDEXES.Player)
    self:moveTo(-100, -100)
end

function ChefInteractBtn:update()
    self:updateAnimation()
    if showIntBtn == true then
        self:moveTo(newX + 192, newY + 90)
    elseif showIntBtn == false then
        self:moveTo(-100, -100)
    end
end

class('Sidekick').extends(AnimatedSprite)

function Sidekick:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local sidekickImageTable = gfx.imagetable.new("/assets/images/sidekick-table-16-16")
    Sidekick.super.init(self, sidekickImageTable)

    self:addState("idle", 1, 4, { tickStep = 4 })
    self:addState("run", 5, 11, { tickStep = 4 })
    self:addState("jump", 5, 5)
    self:addState("dash", 9, 9)

    followLeft = false

    self:playAnimation()

    -- Sprite properties

    self:setZIndex(Z_INDEXES.Player)
    self:setTag(TAGS.Chef)
end

function Sidekick:update()
    self:updateAnimation()
    if followLeft == true then
        self:moveTo(chefX + 22, chefY)
        self.globalFlip = 1
    else
        self:moveTo(chefX - 22, chefY)
        self.globalFlip = 0
    end
end
