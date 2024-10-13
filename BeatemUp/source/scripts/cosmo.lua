local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk


class('Cosmo').extends(AnimatedSprite)

function Cosmo:init(x, y, gameManager)
    self.gameManager = gameManager

    -- State Machine
    local cosmoImageTable = gfx.imagetable.new("/assets/images/playertest-table-64-128")
    Cosmo.super.init(self, cosmoImageTable)

    self:addState("idleeast", 1, 1, { tickStep = 4 })
    self:addState("idlewest", 3, 3, { tickStep = 4 })
    self:addState("east", 1, 2, { tickStep = 4 })
    self:addState("west", 3, 4, { tickStep = 4 })
    self:addState("east", 1, 2, { tickStep = 4 })
    self:addState("eastpunch", 5, 6, { tickStep = 4, nextAnimation = "idleeast" })
    self:addState("westpunch", 7, 8, { tickStep = 4, nextAnimation = "idlewest" })
    self:addState("eastjump", 9, 13, { tickStep = 4, nextAnimation = "idlewest" })
    self:addState("westjump", 9, 13, { tickStep = 4, nextAnimation = "idlewest" })
 


    -- self:setCenter(0, 0)

    cosmoX = self.x
    cosmoY = self.y
    self:playAnimation()
    bMenuShow = false
    showIntBtn = false
    -- Sprite properties
    self:moveTo(x, y)
    self:setZIndex(self.y)
    self:setCollideRect(23, 77, 20, 40)
    self:setTag(TAGS.Cosmo)
    self.playerdirection = "west"

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
    if credits == nil then
        credits = 0
    else
        credits = credits
    end

    self.TextboxShow = false
    playersteps = pd.sound.fileplayer.new('assets/sounds/step_3')
    playerheal = pd.sound.fileplayer.new('assets/sounds/heal')
    playersteps:setVolume(.1)
    stepTimer = 0

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
        playerMaxHP = playerMaxHP
    end
    if playerHP == nil then
        playerHP = playerMaxHP
    else
        playerHP = playerHP
    end
    itemcount = 0
    itemoptions = {}
    for _, row in ipairs(recipes) do
        if row["category"] == "Snacks" then
            if row["quantity"] > 0 then
                itemcount = itemcount + row["quantity"]

                table.insert(itemoptions, row.name .. " " .. itemcount)
            end
        end
    end
end

function Cosmo:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Pickup or tag == TAGS.Hazard or tag == TAGS.Prop or tag == TAGS.intDoor or tag == TAGS.Door then
        return gfx.sprite.kCollisionTypeOverlap
    end
    return gfx.sprite.kCollisionTypeSlide
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
  
    cosmoHUD()
    self:setZIndex(self.y)
    if _G.paused == false then
        self:handleState()
        self:handleMovementAndCollisions()
        self:updateAnimation()
        self:handleLeveling()
        if hudShow == true then
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
                    limamusic:setVolume(0.2)
                    lavenmusic:setVolume(0.2)
                    paused = true
                    self.xVelocity = 0
                    self.yVelocity = 0

                    manager:push(questScene())
                end
                if playdate.buttonJustPressed(playdate.kButtonUp) then
                    limamusic:setVolume(0.2)
                    lavenmusic:setVolume(0.2)
                    paused = true
                    self.xVelocity = 0
                    self.yVelocity = 0

                    manager:push(rolodexScene())
                end
                if playdate.buttonJustPressed(playdate.kButtonRight) then
                    if playerHP < playerMaxHP then
                        playerHP = playerHP + math.ceil(playerMaxHP / 10)
                        if playerHP > playerMaxHP then
                            playerHP = playerMaxHP
                        end
                        playerheal:play(1)
                        itemcount = itemcount - 1
                        for _, row in ipairs(recipes) do
                            if row["category"] == "Snacks" then
                                if row["quantity"] > 0 then
                                    row["quantity"] = row["quantity"] - 1
                                    table.remove(itemoptions, row.row)
                                    table.insert(itemoptions, row.name .. " " .. row["quantity"])
                                end


                                recipeItem = row.name
                                if itemcount <= 0 then
                                    table.remove(itemoptions, row.row)
                                    itemoptions = itemoptions
                                end
                            end
                        end
                    end
                end
            elseif pd.buttonJustReleased(pd.kButtonB) then
                bMenuShow = false
            end
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
        playerMaxHP = playerMaxHP + (playerLevel * 2)
        playerHP = playerMaxHP
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

        elseif collisionTag == TAGS.Door then
            doorEnter = true
        elseif collisionTag == TAGS.intDoor then
            intDoor = true
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
    if paused == false then
        if pd.buttonJustReleased(pd.kButtonLeft) then
            self:changeState("idlewest")
            playerdirection="west"
            
        elseif pd.buttonJustReleased(pd.kButtonRight) then
            self:changeState("idleeast")
            playerdirection="east"
        end

        if pd.buttonJustReleased(pd.kButtonUp) or pd.buttonJustReleased(pd.kButtonDown)then
            if playerdirection == "west" then
                self:changeState("idlewest")
            elseif playerdirection == "east" then
            self:changeState("idleeast")

            end
        end

        if pd.buttonJustPressed(pd.kButtonA) then
            if playerdirection == "west" then
                self:changeState("westpunch")
            elseif playerdirection == "east" then
            self:changeState("eastpunch")

            end
        end

        if pd.buttonJustPressed(pd.kButtonB) then
            if playerdirection == "west" then
                self:changeState("westjump")
            elseif playerdirection == "east" then
            self:changeState("eastjump")

            end
        end
    end
end

function Cosmo:changeToRunState(direction)
    if paused == false then
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
    self:setZIndex(cosmoY)
    self:moveTo(-100, -100)
end

function CosmoInteractBtn:update()
    self:updateAnimation()
    self:setZIndex(cosmoY)

    if showIntBtn == true then
        self:moveTo(cosmoX, cosmoY - 24)
    elseif showIntBtn == false then
        self:moveTo(-100, -100)
    end
end

function cosmoSortOrder(self)
    if cosmoY >= self.y + 10 then
        self:setZIndex(10)
    else
        self:setZIndex(12)
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
    self:setZIndex(800)
    self:moveTo(-100, -100)
end

function bMenu:update()
    self:updateAnimation()
    if paused == false then
        if bMenuShow == true then
            self:moveTo(cosmoX, cosmoY)
        elseif bMenuShow == false then
            self:moveTo(-100, -100)
        end
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
        if walking == false then
            walkingCounter += 2
            if walkingCounter >= 100 then
                walkingCounter = 100
                hudUI()
            end
        else
            walkingCounter = 0
        end
    end
end

function hudUI()
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
    gfx.drawRect(290 + -cameraX, 208 + -cameraY, 74, 9)
    gfx.drawRect(363 + -cameraX, 208 + -cameraY, 6, 9)
    gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
    gfx.fillRect(363 + -cameraX, 208 + -cameraY, 6, 9)
    gfx.setDitherPattern(.25, gfx.image.kDitherTypeBayer8x8)
    gfx.fillRect(292 + -cameraX, 210 + -cameraY, 70, 5)
    gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)
    gfx.fillRect(292 + -cameraX, 210 + -cameraY, playerHP / playerMaxHP * 70, 5)


    --player level bar
    gfx.drawRect(290 + -cameraX, 216 + -cameraY, 54, 7)
    gfx.drawRect(343 + -cameraX, 216 + -cameraY, 5, 7)
    gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
    gfx.fillRect(343 + -cameraX, 216 + -cameraY, 5, 7)
    gfx.setDitherPattern(.25, gfx.image.kDitherTypeBayer8x8)
    gfx.fillRect(292 + -cameraX, 218 + -cameraY, 50, 3)
    gfx.setDitherPattern(0, gfx.image.kDitherTypeBayer8x8)
    gfx.fillRect(292 + -cameraX, 218 + -cameraY, playerXP / playerNextLevel * 50, 3)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setColor(gfx.kColorBlack)
    gfx.drawTextAligned("lv:" .. playerLevel, 285 + -cameraX, 213 + -cameraY, kTextAlignment.right)
    gfx.drawTextAligned("$" .. credits, 285 + -cameraX, 201 + -cameraY, kTextAlignment.right)

    gfx.fillRect(288 + -cameraX, 183 + -cameraY, 94, 18)
    gfx.setColor(gfx.kColorWhite)


    gfx.drawRect(290 + -cameraX, 185 + -cameraY, 90, 16)

    gfx.drawTextAligned(tostring(areaName), 295 + -cameraX, 185 + -cameraY, kTextAlignment.left)
end
