local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk


class('Player').extends(AnimatedSprite)

function Player:init(x, y, gameManager)
    self.gameManager = gameManager

    playerImageTable = gfx.imagetable.new("assets/images/tacoship1-table-96-96")

    -- State Machine

    Player.super.init(self, playerImageTable)

    self:addState("idle", 1, 1, { tickStep = 1 })
    self:addState("moving", 1, 1, { tickStep = shipSpeed })
    self:addState("southeast", 1, 1, { tickStep = shipSpeed })
    self:addState("east", 2, 2, { tickStep = shipSpeed })
    self:addState("northeast", 3, 3, { tickStep = shipSpeed })
    self:addState("north", 4, 4, { tickStep = shipSpeed })
    self:addState("northwest", 5, 5, { tickStep = shipSpeed })

    self:addState("west", 6, 6, { tickStep = shipSpeed })

    self:addState("southwest", 7, 7, { tickStep = shipSpeed })

    self:addState("south", 8, 8, { tickStep = shipSpeed })


    self.currentState = "idle"
    self:playAnimation()

    self:moveTo(x, y)
    self:setCenter(1, 1)
    self:setCollideRect(0, 0, self:getSize())
    self:setTag(TAGS.Player)
    self:setZIndex(Z_INDEXES.Player)
    InteractBtn()
    -- LimaTitle()
    -- LavenTitle()
    -- GarlielTitle()
    -- MushrooTitle()
    HUD()
    ThrustParticles()
    shipSpeed = 0
    minSpeed = 0
    maxSpeed = 6

    if newX == nil then
        newX = 0
    end

    if newY == nil then
        newY = 0
    end
    shipreturnX = newX
    shipreturnY = newY
end

function Player:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Enemy or tag == TAGS.Prop or tag == TAGS.Planet then
        return gfx.sprite.kCollisionTypeOverlap
    else
        return gfx.sprite.kCollisionTypeSlide
    end
end

function Player:update()
    if paused == false then
        self:handleMovementAndCollisions()
        self:updateAnimation()
        self:setCollideRect(0, 0, self:getSize())
    end


    local x = self.x + shipSpeed * math.cos(math.rad(angle))
    local y = self.y + shipSpeed * math.sin(math.rad(angle))
    self:moveTo(x, y)
    if angle <= 22 and angle >= 0 then
        self:changeState("east")
        thrustX = 160
        thrustY = 120
        thrustFlip = 180
    end
    if angle <= 360 and angle >= 341 then
        self:changeState("east")
        thrustX = 160
        thrustY = 120
        thrustFlip = 180
    end
    if angle <= 68 and angle >= 23 then
        self:changeState("southeast")
        thrustX = 160
        thrustY = 115
        thrustFlip = 200
    end
    if angle <= 113 and angle >= 69 then
        self:changeState("south")
        thrustX = 1210
        thrustY = 1190
        thrustFlip = 270
    end
    if angle <= 158 and angle >= 114 then
        self:changeState("southwest")
        thrustX = 240
        thrustY = 115
        thrustFlip = 340
    end
    if angle <= 205 and angle >= 159 then
        self:changeState("west")
        thrustX = 240
        thrustY = 120
        thrustFlip = 0
    end
    if angle <= 250 and angle >= 206 then
        self:changeState("northwest")
        thrustX = 240
        thrustY = 125
        thrustFlip = 20
    end
    if angle <= 295 and angle >= 251 then
        self:changeState("north")
        thrustX = 200
        thrustY = 120
        thrustFlip = 90
    end
    if angle <= 340 and angle >= 296 then
        self:changeState("northeast")
        thrustX = 160
        thrustY = 125
        thrustFlip = 160
    end
    if pd.buttonIsPressed(pd.kButtonB) and pd.buttonJustReleased(pd.kButtonLeft) then
        spacemusic:setVolume(0.2)

        shipSpeed = 0
        paused = true


        manager:push(PauseScene())
    end
    if pd.buttonIsPressed(pd.kButtonB) and pd.buttonJustPressed(playdate.kButtonDown) then
        spacemusic:setVolume(0)

        paused = true
        BattleFadeImage()
        BattleTimer()
    end
end

function Player:handleMovementAndCollisions()
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
        if cameraY <= -1500 then
            cameraY = -1500
        end
        gfx.setDrawOffset(cameraX, cameraY)
        playdate.graphics.sprite.addDirtyRect(newX, newY, 400, 240)
    end


    if self.x <= 20 then
        self.x = 20
    elseif self.x >= 1980 then
        self.x = 1980
    elseif self.y <= 20 then
        self.y = 20
    elseif self.y >= 1480 then
        self.y = 1480
    end




    angle = pd.getCrankPosition()

    local x = self.x + shipSpeed * math.cos(math.rad(angle))
    local y = self.y + shipSpeed * math.sin(math.rad(angle))
    angle = angle



    if playdate.buttonJustReleased(playdate.kButtonUp) then
        shipSpeed = shipSpeed + 2


        if shipSpeed >= maxSpeed then
            shipSpeed = maxSpeed
        end
        self:changeToMovingState()
    elseif pd.buttonJustReleased('down') then
        shipSpeed = shipSpeed - 2


        if shipSpeed <= minSpeed then
            shipSpeed = minSpeed
        end
        self:changeToMovingState()
    elseif shipSpeed == 0 then
        self:changeToIdleState()
    end


    -- self:setRotation(angle)
    -- gfx.sprite.update()
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
        if collisionType == gfx.sprite.kCollisionTypeOverlap then
            if collisionTag == TAGS.Enemy then

            end
            if collisionTag == TAGS.Prop then

            end
            if collisionTag == TAGS.Planet then
                showBtn = true

                if collisionObject.planetName == "Lima" then
                    location = "Lima"

                    currentPlanetX = collisionObject.fields.xPos + 32
                    currentPlanetY = collisionObject.fields.yPos + 32
                    if pd.buttonJustReleased(pd.kButtonA) then
                        spacemusic:stop()
                        stopSpawner()
                        shipSpeed = 0
                        hudShow   = false
                        paused    = true
                        gfx.sprite.removeAll()
                        landing = true
                        ShipLand()
                        levelTimer = pd.timer.performAfterDelay(3500, function()
                            levelNum = 1

                            manager:enter(LoadingScene())
                        end)
                    end
                elseif collisionObject.planetName == "Garliel" then
                    location = "Garliel"
                    currentPlanetX = collisionObject.fields.xPos + 32
                    currentPlanetY = collisionObject.fields.yPos + 32
                    if pd.buttonJustPressed(pd.kButtonA) then
                        spacemusic:stop()
                        stopSpawner()
                        shipSpeed = 0
                        hudShow   = false
                        gfx.sprite.removeAll()
                        landing = true
                        ShipLand()
                        levelTimer = pd.timer.performAfterDelay(3500, function()
                            levelNum = 1
                            gfx.sprite.removeAll()

                            manager:enter(LoadingScene())
                        end)
                    end
                elseif collisionObject.planetName == "Laven" then
                    location = "Laven"
                    currentPlanetX = collisionObject.fields.xPos + 32
                    currentPlanetY = collisionObject.fields.yPos + 32
                    if pd.buttonJustPressed(pd.kButtonA) then
                        spacemusic:stop()
                        stopSpawner()
                        shipSpeed = 0
                        hudShow   = false
                        gfx.sprite.removeAll()
                        landing = true
                        ShipLand()
                        levelTimer = pd.timer.performAfterDelay(3500, function()
                            levelNum = 1
                            gfx.sprite.removeAll()

                            manager:enter(LoadingScene())
                        end)
                    end
                elseif collisionObject.planetName == "Mushroo" then
                    location = "Mushroo"
                    currentPlanetX = collisionObject.fields.xPos + 32
                    currentPlanetY = collisionObject.fields.yPos + 32
                    if pd.buttonJustPressed(pd.kButtonA) then
                        spacemusic:stop()
                        stopSpawner()
                        shipSpeed = 0
                        hudShow   = false
                        gfx.sprite.removeAll()
                        landing = true
                        ShipLand()
                        levelTimer = pd.timer.performAfterDelay(3500, function()
                            levelNum = 1
                            gfx.sprite.removeAll()

                            manager:enter(LoadingScene())
                        end)
                    end
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

class('InteractBtn').extends(AnimatedSprite)

function InteractBtn:init(x, y)
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

function InteractBtn:update()
    self:updateAnimation()
    if showBtn == true then
        self:moveTo(newX + 190, newY + 75)
    elseif showBtn == false then
        self:moveTo(-100, -100)
    end
end

class('LimaTitle').extends(AnimatedSprite)

function LimaTitle:init(x, y)
    titleImageTable = gfx.imagetable.new("assets/images/limaText-table-100-32")
    LimaTitle.super.init(self, titleImageTable)

    self:addState("hide", 1, 1, { tickStep = 1 })
    self:addState("show", 1, 8, { tickStep = 2 })
    self.currentState = "show"
    self:playAnimation()

    self:setCenter(0, 0)
    self:add()
    self:setZIndex(Z_INDEXES.Player)
    self:moveTo(-500, -500)
end

function LimaTitle:update()
    self:updateAnimation()
    if limaText == true then
        self:moveTo(newX + 300, newY + 20)
    elseif limaText == false then
        self:moveTo(-500, -500)
    end
end

class('LavenTitle').extends(AnimatedSprite)

function LavenTitle:init(x, y)
    titleImageTable = gfx.imagetable.new("assets/images/lavenText-table-120-32")
    LavenTitle.super.init(self, titleImageTable)

    self:addState("hide", 1, 1, { tickStep = 1 })
    self:addState("show", 1, 10, { tickStep = 2 })
    self.currentState = "show"
    self:playAnimation()

    self:setCenter(0, 0)
    self:add()
    self:setZIndex(Z_INDEXES.Player)
    self:moveTo(-500, -500)
end

function LavenTitle:update()
    self:updateAnimation()
    if lavenText == true then
        self:moveTo(newX + 280, newY + 20)
    elseif lavenText == false then
        self:moveTo(-500, -500)
    end
end

class('GarlielTitle').extends(AnimatedSprite)

function GarlielTitle:init(x, y)
    titleImageTable = gfx.imagetable.new("assets/images/garlielText-table-150-32")
    GarlielTitle.super.init(self, titleImageTable)

    self:addState("hide", 1, 1, { tickStep = 1 })
    self:addState("show", 1, 14, { tickStep = 2 })
    self.currentState = "show"
    self:playAnimation()

    self:setCenter(0, 0)
    self:add()
    self:setZIndex(Z_INDEXES.Player)
    self:moveTo(-500, -500)
end

function GarlielTitle:update()
    self:updateAnimation()
    if garlielText == true then
        self:moveTo(newX + 250, newY + 20)
    elseif garlielText == false then
        self:moveTo(-500, -500)
    end
end

class('MushrooTitle').extends(AnimatedSprite)

function MushrooTitle:init(x, y)
    titleImageTable = gfx.imagetable.new("assets/images/mushrooText-table-175-32")
    MushrooTitle.super.init(self, titleImageTable)

    self:addState("hide", 1, 1, { tickStep = 1 })
    self:addState("show", 1, 14, { tickStep = 2 })
    self.currentState = "show"
    self:playAnimation()

    self:setCenter(0, 0)
    self:add()
    self:setZIndex(Z_INDEXES.Player)
    self:moveTo(-500, -500)
end

function MushrooTitle:update()
    self:updateAnimation()
    if mushrooText == true then
        self:moveTo(newX + 225, newY + 20)
    elseif mushrooText == false then
        self:moveTo(-500, -500)
    end
end

class('HUD').extends(AnimatedSprite)

function HUD:init()
    hudImageTable = gfx.imagetable.new("assets/images/thrust-table-70-35")


    HUD.super.init(self, hudImageTable)

    self:addState("off", 1, 1)
    self:addState("one", 2, 2)
    self:addState("two", 3, 3)
    self:addState("three", 4, 4)

    self.currentState = "off"

    self:setCenter(0, 0)
    self:add()
    self:setZIndex(Z_INDEXES.Player)

    self:playAnimation()
end

function HUD:update()
    self:moveTo(newX + 315, newY + 190)

    if shipSpeed == 0 then
        self:changeState("off")
    elseif shipSpeed == 2 then
        self:changeState("one")
    elseif shipSpeed == 4 then
        self:changeState("two")
    elseif shipSpeed == 6 then
        self:changeState("three")
    end
end

class('ThrustParticles').extends(AnimatedSprite)

function ThrustParticles:init()
    thrustImageTable = gfx.imagetable.new("assets/images/Particles-table-64-64")


    ThrustParticles.super.init(self, thrustImageTable)

    self:addState("off", 1, 1)
    self:addState("on", 2, 32, { tickStep = shipSpeed })
    self.currentState = "off"

    self:setCenter(0.5, 0.5)
    self:add()
    self:setZIndex(Z_INDEXES.Player)

    self:playAnimation()
end

function ThrustParticles:update()
    self:moveTo(newX + thrustX, newY + thrustY)
    self:updateAnimation()
    self:setRotation(thrustFlip)
    if shipSpeed > 0 then
        self:changeState("on")
    else
        self:changeState("off")
    end
end
