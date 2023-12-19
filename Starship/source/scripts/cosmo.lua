local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk


class('Cosmo').extends(AnimatedSprite)

function Cosmo:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local cosmoImageTable = gfx.imagetable.new("/assets/images/cosmo-idle-walk-table-32-32")
    Cosmo.super.init(self, cosmoImageTable)

    self:addState("idlesouth", 1, 4, { tickStep = 4 })
    self:addState("idlenorth", 17, 20, { tickStep = 4 })
    self:addState("idleeast", 9, 12, { tickStep = 4 })
    self:addState("idlewest", 25, 28, { tickStep = 4 })
    self:addState("west", 29, 32, { tickStep = 4 })
    self:addState("east", 13, 16, { tickStep = 4 })
    self:addState("north", 21, 24, { tickStep = 4 })
    self:addState("south", 5, 8, { tickStep = 4 })
    self:addState("northeast", 37, 40, { tickStep = 4 })
    self:addState("northwest", 33, 36, { tickStep = 4 })
    self:addState("southeast", 41, 44, { tickStep = 4 })
    self:addState("southwest", 45, 48, { tickStep = 4 })





    -- self:setCenter(0, 0)
    cosmoX = self.x
    cosmoY = self.y
    self:playAnimation()
    CosmoInteractBtn()
    bMenu()
    bMenuShow = false
    showIntBtn = false
    -- Sprite properties
    self:moveTo(x, y)
    self:setZIndex(5)
    self:setCollideRect(11, 20, 10, 10)
    self:setTag(TAGS.Cosmo)

    -- Physics properties
    self.xVelocity = 0
    self.yVelocity = 0
    self.maxSpeed = 4
    self.drag = 0.1

    isPlaying = false

    -- Cosmo State
    self.dir = 1
    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false
    self.dead = false
    self.hasKey = false
    self.hasAlphaKey = false

    self.TextboxShow = false
    playersteps = pd.sound.fileplayer.new('assets/sounds/step_3')
    playerheal = pd.sound.fileplayer.new('assets/sounds/heal')
    playersteps:setVolume(.2)
    stepTimer = 0
    _G.AlphaKey = false
    _G.BetaKey = false
    _G.SigmaKey = false
    _G.GammaKey = false
    --SFX

    battleFade = false


    --Base player attributes

    if playerLevel == nil then
        playerLevel = 1
    else
        playerLevel = playerLevel
    end
    if playerXP == nil then
        playerXP = 0
    else
        playerXP = playerXP
    end
    if playerNextLevel == nil then
        playerNextLevel = 100
    else
        playerNextLevel = playerNextLevel
    end
    if playerMaxHP == nil then
        playerMaxHP = 30
    else
        playerMaxHP = playerMaxHP + (playerLevel * 2)
    end
    if playerHP == nil then
        playerHP = playerMaxHP
    else
        playerHP = playerHP
    end
end

function Cosmo:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Pickup or tag == TAGS.Hazard or tag == TAGS.Prop or tag == TAGS.Laser or tag == TAGS.Ship then
        return gfx.sprite.kCollisionTypeOverlap
    end
    return gfx.sprite.kCollisionTypeSlide
end

function footSteps(self)
    if self.xVelocity ~= 0 or self.yVelocity ~= 0 then
        if (isPlaying == false) then
            playersteps:play()
            isPlaying = true
        end
        stepTimer += 1
    end

    if stepTimer >= 10 then
        isPlaying = false
        stepTimer = 0
    end
end

function Cosmo:update()
    if self.dead then
        return
    end
    cosmoX = self.x
    cosmoY = self.y
    if self.maxSpeed > 4 then
        self.maxSpeed = 4
    end
    footSteps(self)
    cosmoHUD()
    if _G.paused == false then
        self:handleState()
        self:handleMovementAndCollisions()
        self:updateAnimation()
        self:handleLeveling()
        if pd.buttonIsPressed(pd.kButtonB) then
            bMenuShow = true
            if playdate.buttonJustPressed(playdate.kButtonLeft) then
                limamusic:setVolume(0.2)
                lavenmusic:setVolume(0.2)
                paused = true
                self.xVelocity = 0
                self.yVelocity = 0


                manager:push(PauseScene())
            end
            if playdate.buttonJustPressed(playdate.kButtonDown) then
                self.xVelocity = 0
                self.yVelocity = 0

                playerHP = playerHP + 5

                if playerHP >= playerMaxHP then
                    playerHP = playerMaxHP
                else
                    playerheal:play(1)
                end
            end
        elseif pd.buttonJustReleased(pd.kButtonB) then
            bMenuShow = false
        end
    else
        self:changeToIdleState()
    end
end

function Cosmo:handleState()
    if self.currentState == "idle" then
        self:handleGroundInput()
    else
        self:handleGroundInput()
    end
end

function Cosmo:handleLeveling()
    if playerNextLevel - playerXP <= 0 then
        playerLevel = playerLevel + 1

        remainingXP = playerNextLevel - playerXP
        playerXP = 0 + remainingXP * -1
        playerNextLevel = 100 * playerLevel
    end
end

function Cosmo:handleMovementAndCollisions()
    cameraX = 0
    cameraY = 0
    newX = math.floor(self.x - 200, 400)
    newY = math.floor(self.y - 120, 240)
    if (newX ~= -cameraX) or (newY ~= -cameraY) then
        cameraX = -newX
        cameraY = -newY
        if cameraX >= 0 then
            cameraX = 0
        end
        if cameraX <= -levelWidth + 400 then
            cameraX = -levelWidth + 400
        end
        if cameraY <= -levelHeight + 240 then
            cameraY = -levelHeight + 240
        end
        if cameraY > 0 then
            cameraY = 0
        end
        gfx.setDrawOffset(cameraX, cameraY)
        playdate.graphics.sprite.addDirtyRect(newX, newY, 400, 240)
    end



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
        collisionObject:alphaCollision(self)
        self:alphaCollision(collisionObject)
        if collisionType == gfx.sprite.kCollisionTypeSlide then
            if collision.normal.y == -1 then
                self.touchingGround = true
            elseif collision.normal.y == 1 then
                self.touchingCeiling = true
            end

            if collision.normal.x ~= 0 then
                self.touchingWall = true
            end
        end




        if collisionTag == TAGS.Ship then
            showIntBtn = true



            if pd.buttonJustReleased(pd.kButtonA) then
                limamusic:stop()
                lavenmusic:stop()


                hudShow = false
                paused  = true
                gfx.sprite.removeAll()


                manager:enter(ShipInteriorScene())
            end
        elseif collisionTag == TAGS.Shop then

        elseif collisionTag == TAGS.Pickup then
            collisionObject:pickUp(self)
        end
    end

    if self.x < 0 then
        self.gameManager:enterRoom("west")
    elseif self.x > levelWidth then
        self.gameManager:enterRoom("east")
    elseif self.y < 0 then
        self.gameManager:enterRoom("north")
    elseif self.y > levelHeight then
        self.gameManager:enterRoom("south")
    end
    if died then
        self:die()
    end
end

function Cosmo:damage(amount)

end

function Cosmo:die()
    self.xVelocity = 0
    self.yVelocity = 0
    self.dead = true
    self:setCollisionsEnabled(false)
    pd.timer.performAfterDelay(200, function()
        self:setCollisionsEnabled(true)
        self.gameManager:resetCosmo()
        self.dead = false
    end)
end

-- Input Helper Functions
function Cosmo:handleGroundInput()
    if pd.buttonIsPressed(pd.kButtonLeft) then
        self:changeToRunState("left")
    elseif pd.buttonIsPressed(pd.kButtonRight) then
        self:changeToRunState("right")
    elseif pd.buttonIsPressed(pd.kButtonUp) then
        self:changeToRunState("up")
    elseif pd.buttonIsPressed(pd.kButtonDown) then
        self:changeToRunState("down")
    else
        self:changeToIdleState()
        playersteps:stop()
    end
end

-- State transitions
function Cosmo:changeToIdleState()
    self.xVelocity = 0
    self.yVelocity = 0
    posX           = false
    negX           = false

    if pd.buttonJustReleased(pd.kButtonLeft) then
        self:changeState("idlewest")
    elseif pd.buttonJustReleased(pd.kButtonRight) then
        self:changeState("idleeast")
    elseif pd.buttonJustReleased(pd.kButtonUp) then
        self:changeState("idlenorth")
    elseif pd.buttonJustReleased(pd.kButtonDown) then
        self:changeState("idlesouth")
    end
end

function Cosmo:changeToRunState(direction)
    if not pd.buttonIsPressed(pd.kButtonB) then
        if pd.buttonJustPressed(pd.kButtonLeft) then
            self.xVelocity = -self.maxSpeed
            self.yVelocity = self.yVelocity
        elseif pd.buttonJustPressed(pd.kButtonRight) then
            self.xVelocity = self.maxSpeed
            self.yVelocity = self.yVelocity
        elseif pd.buttonJustPressed(pd.kButtonUp) then
            self.yVelocity = -self.maxSpeed
            self.xVelocity = self.xVelocity
        elseif pd.buttonJustPressed(pd.kButtonDown) then
            self.yVelocity = self.maxSpeed
            self.xVelocity = self.xVelocity
        end
        if pd.buttonJustReleased(pd.kButtonLeft) then
            self.xVelocity = 0
        elseif pd.buttonJustReleased(pd.kButtonRight) then
            self.xVelocity = 0
        elseif pd.buttonJustReleased(pd.kButtonUp) then
            self.yVelocity = 0
        elseif pd.buttonJustReleased(pd.kButtonDown) then
            self.yVelocity = 0
        end
        if self.xVelocity < 0 and self.yVelocity == 0 then
            self:changeState("west")
        end
        if self.xVelocity > 0 and self.yVelocity == 0 then
            self:changeState("east")
        end
        if self.xVelocity == 0 and self.yVelocity < 0 then
            self:changeState("north")
        end
        if self.xVelocity == 0 and self.yVelocity > 0 then
            self:changeState("south")
        end
        if self.xVelocity > 0 and self.yVelocity > 0 then
            self:changeState("southeast")
        end
        if self.xVelocity < 0 and self.yVelocity > 0 then
            self:changeState("southwest")
        end
        if self.xVelocity > 0 and self.yVelocity < 0 then
            self:changeState("northeast")
        end
        if self.xVelocity < 0 and self.yVelocity < 0 then
            self:changeState("northwest")
        end
    end

    if direction == "left" then
        posX = true
        negX = false
    elseif direction == "right" then
        posX = false
        negX = true
    end

    if self.touchingWall == true then
        posX = false
        negX = false
    end
end

class('CosmoInteractBtn').extends(AnimatedSprite) --OLD

function CosmoInteractBtn:init(x, y)
    btnImageTable = gfx.imagetable.new("assets/images/abtn-table-16-16")
    InteractBtn.super.init(self, btnImageTable)

    self:addState("hide", 1, 1, { tickStep = 1 })
    self:addState("show", 2, 2, { tickStep = 1 })
    self.currentState = "show"
    self:playAnimation()

    self:setCenter(0.5, 0.5)
    self:add()
    self:setZIndex(Z_INDEXES.Player)
    self:moveTo(-100, -100)
end

function CosmoInteractBtn:update()
    self:updateAnimation()
    if showIntBtn == true then
        self:moveTo(cosmoX, cosmoY - 24)
    elseif showIntBtn == false then
        self:moveTo(-100, -100)
    end
end

-- function CosmoInteractBtn() --NEW
--     if showIntBtn == true then
--         gfx.setColor(gfx.kColorBlack)
--         if newX > levelWidth then
--             newX = levelWidth
--         else
--             newX = newX
--         end
--         gfx.fillRect(0 + newX, 190 + newY, 100, 30)
--         gfx.setColor(gfx.kColorWhite)
--         gfx.setFont(font2)
--         gfx.setColor(gfx.kColorWhite)
--         gfx.drawTextAligned("Action", 20 + newX, 195 + newY, kTextAlignment.left)
--     end
-- end
class('ShipTakeoff').extends(AnimatedSprite)

function ShipTakeoff:init(x, y)
    gfx.setBackgroundColor(gfx.kColorBlack)

    shiptakeoffImageTable = gfx.imagetable.new("assets/images/burgertakeoff-table-400-240")

    Ship.super.init(self, shiptakeoffImageTable)
    self:addState("idle", 1, 15, { tickStep = 8 })
    self.currentState = "idle"
    self:setZIndex(1000)


    self:setCenter(0, 0)
    self:moveTo(newX, newY)
    self:add()
    self:playAnimation()
    self:setTag(TAGS.Ship)
end

function ShipTakeoff:update()
    self:updateAnimation()
    shipTimer = pd.timer.performAfterDelay(3000, function()
        self:remove()
    end)
end

function cosmoSortOrder(self)
    if cosmoY > self.y + 10 then
        self:setZIndex(4)
    else
        self:setZIndex(10)
    end
end

class('bMenu').extends(AnimatedSprite)

function bMenu:init(x, y)
    bMenuImageTable = gfx.imagetable.new("assets/images/bmenu-table-64-64")
    bMenu.super.init(self, bMenuImageTable)

    self:addState("hide", 1, 1, { tickStep = 1 })
    self:addState("show", 1, 1, { tickStep = 1 })
    self.currentState = "show"
    self:playAnimation()

    self:setCenter(0.5, 0.5)
    self:add()
    self:setZIndex(Z_INDEXES.Player)
    self:moveTo(-100, -100)
end

function bMenu:update()
    self:updateAnimation()
    if bMenuShow == true then
        self:moveTo(cosmoX, cosmoY - 32)
    elseif bMenuShow == false then
        self:moveTo(-100, -100)
    end
end

function BattleTimer()
    battleFade = true
    returnRoomNumber = roomNumber
    battlestartmusic:play()

    battlestartmusic:setVolume(0.5)
    BattleEnterTimer = pd.timer.performAfterDelay(2300, function()

    end)
end

class('BattleFadeImage').extends(gfx.sprite)
function BattleFadeImage:init(x, y)
    local loadingImage = gfx.image.new("assets/images/testbattle")
    self:setZIndex(1000)
    self:setImage(loadingImage)
    self.speed = 4.8
    self.x = -cameraX + 400
    self.y = -cameraY - 100
    self:moveTo(self.x, self.y)
    self:setCenter(0, 0)
    self:add()
    print(enemyName)
end

function BattleFadeImage:update()
    if battleFade == true then
        hudShow = false
        returnX = cosmoX
        returnY = cosmoY
        returnRoom = levelName
        self.x -= self.speed
        if self.x <= cosmoX - 200 then
            self.x = cosmoX - 200
            battlestartmusic:stop()
            manager:push(BattleScene())
        end


        self:moveTo(self.x, self.y)
    end
end

function cosmoHUD()
    if cameraX == nil then
        cameraX = 0
    end
    if cameraY == nil then
        cameraY = 0
    end
    if hudShow == true then
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(255 + -cameraX, 200 + -cameraY, 136, 30)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRect(256 + -cameraX, 201 + -cameraY, 128, 28)
        gfx.drawRect(383 + -cameraX, 201 + -cameraY, 7, 28)
        gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(383 + -cameraX, 201 + -cameraY, 7, 28)
        gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)

        gfx.setFont(fontHud)
        --player healthbar
        gfx.drawRect(285 + -cameraX, 208 + -cameraY, 74, 9)
        gfx.drawRect(358 + -cameraX, 208 + -cameraY, 6, 9)
        gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(358 + -cameraX, 208 + -cameraY, 6, 9)
        gfx.setDitherPattern(.25, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(287 + -cameraX, 210 + -cameraY, 70, 5)
        gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(287 + -cameraX, 210 + -cameraY, playerHP / playerMaxHP * 70, 5)


        --player level bar
        gfx.drawRect(285 + -cameraX, 216 + -cameraY, 54, 7)
        gfx.drawRect(338 + -cameraX, 216 + -cameraY, 5, 7)
        gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(338 + -cameraX, 216 + -cameraY, 5, 7)
        gfx.setDitherPattern(.25, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(287 + -cameraX, 218 + -cameraY, 50, 3)
        gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)
        gfx.fillRect(287 + -cameraX, 218 + -cameraY, playerXP / playerNextLevel * 50, 3)
        gfx.drawTextAligned("lv " .. playerLevel, 280 + -cameraX, 208 + -cameraY, kTextAlignment.right)
        

    end
end
