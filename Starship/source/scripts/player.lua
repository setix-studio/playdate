local pd <const> = playdate
local gfx <const> = playdate.graphics
local ldtk <const> = LDtk


class('Player').extends(AnimatedSprite)

function Player:init(x, y, gameManager)
    self.gameManager = gameManager


    -- State Machine
    local playerImageTable = gfx.imagetable.new("assets/images/starship-table-48-48")
    Player.super.init(self, playerImageTable)

    self:addState("idle", 1, 1, { tickStep = 1 })
    self:addState("moving", 1, 4, { tickStep = shipSpeed })
    self.currentState = "idle"
    self:playAnimation()

    self:moveTo(x, y)
    self:setCenter(1, 1)
    self:setCollideRect(0, 0, self:getSize())
    self:setTag(TAGS.Player)
    self:setZIndex(Z_INDEXES.Player)
    InteractBtn()
    LimaTitle()
    LavenTitle()
    GarlielTitle()
    MushrooTitle()
    shipSpeed = 0
    minSpeed = -6
    maxSpeed = 6

    if newX == nil then
        newX = 0
    end

    if newY == nil then
        newY = 0
    end
    returnX = newX
    returnY = newY
    engine = pd.sound.fileplayer.new('assets/sounds/engine')
end

function Player:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Enemy or tag == TAGS.Prop or tag == TAGS.Planet then
        return gfx.sprite.kCollisionTypeOverlap
    else
        return gfx.sprite.kCollisionTypeSlide
    end
end

if limaText == true then
    print("show Lima")
end
function Player:update()
    if paused == false then
        self:handleMovementAndCollisions()
        self:updateAnimation()
        self:setCollideRect(0, 0, self:getSize())


        local x = self.x + shipSpeed * math.cos(math.rad(angle))
        local y = self.y + shipSpeed * math.sin(math.rad(angle))
        self:moveTo(x, y)

        if playdate.buttonJustReleased(playdate.kButtonLeft) then
            spacemusic:stop()
            engine:stop()
            shipSpeed = 0
            paused = true


            manager:push(PauseScene())
        end
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
        gfx.setDrawOffset(cameraX, cameraY)
        playdate.graphics.sprite.addDirtyRect(newX, newY, 400, 240)
    end

    -- if self.x <= 200 then
    --     self.x = 2000
    -- elseif self.x >= 2000 then
    --     self.x = 100
    -- elseif self.y <= 100 then
    --     self.y = 1500
    -- elseif self.y >= 1500 then
    --     self.y = 100
    -- end

    angle = pd.getCrankPosition()

    local x = self.x + shipSpeed * math.cos(math.rad(angle))
    local y = self.y + shipSpeed * math.sin(math.rad(angle))
    angle = angle



    if playdate.buttonJustReleased(playdate.kButtonUp) then
        shipSpeed = shipSpeed + 1
       
        if shipSpeed >= maxSpeed then
            shipSpeed = maxSpeed
        end
        self:changeToMovingState()
    elseif pd.buttonJustReleased('down') then
        shipSpeed = shipSpeed - 1
       

        if shipSpeed <= minSpeed then
            shipSpeed = minSpeed
        end
        self:changeToMovingState()
    elseif shipSpeed == 0 then
        self:changeToIdleState()
    end
    self:setRotation(angle)
    gfx.sprite.update()
    self:setCenter(0.5, 0.5)
    self:setCollideRect(10, 10, 28, 28)
    local _, _, collisions, length = self:moveWithCollisions(self.x, self.y)
    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingW = false
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
                        levelNum = 1
                        engine:stop()
                        spacemusic:stop()
                        stopSpawner()
                        manager:push(LoadingScene())
                    end
                elseif collisionObject.planetName == "Garliel" then
                    location = "Garliel"
                    currentPlanetX = collisionObject.fields.xPos + 32
                    currentPlanetY = collisionObject.fields.yPos + 32
                    if pd.buttonJustPressed(pd.kButtonA) then
                        levelNum = 1
                        spacemusic:stop()
                        stopSpawner()
                        engine:stop()
                        manager:push(LoadingScene())
                    end
                elseif collisionObject.planetName == "Laven" then
                    location = "Laven"
                    currentPlanetX = collisionObject.fields.xPos + 32
                    currentPlanetY = collisionObject.fields.yPos + 32
                    if pd.buttonJustPressed(pd.kButtonA) then
                        levelNum = 2
                        spacemusic:stop()
                        stopSpawner()
                        engine:stop()
                        manager:push(LoadingScene())
                    end
                elseif collisionObject.planetName == "Mushroo" then
                    location = "Mushroo"
                    currentPlanetX = collisionObject.fields.xPos + 32
                    currentPlanetY = collisionObject.fields.yPos + 32
                    if pd.buttonJustPressed(pd.kButtonA) then
                        levelNum = 1
                        spacemusic:stop()
                        stopSpawner()
                        engine:stop()
                        manager:push(LoadingScene())
                    end
                end
            end
        end
    end
end

function Player:changeToIdleState()
    engine:stop()
    self:changeState("idle")
end

function Player:changeToMovingState()
    engine:play(0)
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
        self:moveTo(newX + 12, newY + 180)
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
        self:moveTo(newX + 12, newY + 180)
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
        self:moveTo(newX + 12, newY + 180)
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
        self:moveTo(newX + 12, newY + 180)
    elseif mushrooText == false then
        self:moveTo(-500, -500)
    end
end
