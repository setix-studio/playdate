local pd <const>   = playdate
local gfx <const>  = playdate.graphics
local geo <const>  = pd.geometry
local ldtk <const> = LDtk







class('GameScene').extends(Room)

playdate.ui.crankIndicator:start()

function GameScene:enter()
    --startSpawner()
    gfx.setBackgroundColor(gfx.kColorBlack)
    self:goToLevel("Level_" .. levelNum)
    if currentPlanetX == nil then
        currentPlanetX = 75 * 16
    else
        currentPlanetX = currentPlanetX
    end
    if currentPlanetY == nil then
        currentPlanetY = 18 * 16
    else
        currentPlanetY = currentPlanetY
    end

    self.spawnX = currentPlanetX
    self.spawnY = currentPlanetY
    self.player = Player(self.spawnX, self.spawnY, self)
    shipX = self.player.x
    shipY = self.player.y
    angle = 0
    paused = false

    if shipSpeed == nil then
        shipSpeed = 0
    end
    landing = false
    spacemusic:setVolume(0.5)
    spacemusic:play(0)
    limaAngle = 0
    lavenAngle = 0
    mushrooAngle = 0
    garlielAngle = 0
    hudShow = true
    shipParticleX = 0
    shipParticleY = 0
    limasightRadius = 0
    lavensightRadius = 0
    garlielsightRadius = 0
    mushroosightRadius = 0
    SpaceImage()
    StarImage()
    LimaNavArrow()
    scene = GameScene()
end

function GameScene:resetPlayer()
    self.player:moveTo(self.spawnX, self.spawnY)
end

function GameScene:enterRoom(direction)
    local level = ldtk.get_neighbours(self.levelName, direction)[1]
    self:goToLevel(level)
    self.player:add()



    local spawnX, spawnY
    if direction == "north" then
        spawnX, spawnY = self.player.x, 220
    elseif direction == "south" then
        spawnX, spawnY = self.player.x, 24
    elseif direction == "east" then
        spawnX, spawnY = 24, self.player.y
    elseif direction == "west" then
        spawnX, spawnY = 380, self.player.y
    end
    self.player:moveTo(spawnX, spawnY)
    self.spawnX = spawnX
    self.spawnY = spawnY
    _G.currentKeys = _G.keyTotal
end

function GameScene:goToLevel(levelName)
    if not levelName then return end

    self.levelName = levelName

    gfx.sprite.removeAll()


    isMoving = false
    for layerName, layer in pairs(ldtk.get_layers(levelName)) do
        if layer.tiles then
            local tilemap = ldtk.create_tilemap(levelName, layerName)

            local layerSprite = gfx.sprite.new()
            layerSprite:setTilemap(tilemap)
            layerSprite:moveTo(0, 0)
            layerSprite:setCenter(0, 0)
            layerSprite:setZIndex(layer.zIndex)
            layerSprite:add()


            emptyTiles = ldtk.get_empty_tileIDs(levelName, "Solid", layerName)
            if emptyTiles then
                gfx.sprite.addWallSprites(tilemap, emptyTiles)
            end
        end
    end

    for _, entity in ipairs(ldtk.get_entities(levelName)) do
        local entityX, entityY = entity.position.x, entity.position.y
        self.fields = entity.fields
        local entityName = entity.name
        if entityName == "Collision" then
            Collision(entityX, entityY, entity)
        elseif entityName == "Planet" then
            Planet(entityX, entityY, entity)
        end
    end
end

function GameScene:update()
    if landing == false then
        gfx.setColor(gfx.kColorWhite)
        gfx.setFont(fontHud)
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.drawTextAligned(string.upper(location), 345 + newX, 214 + newY, kTextAlignment.center)
    end
    if pd.isCrankDocked() then
        pd.ui.crankIndicator:update()
    end
end

-- function HUD()
--     -- gfx.setColor(gfx.kColorWhite)

--     -- gfx.fillRect(-1 + newX, 209 + newY, 400, 40)
--     -- gfx.setColor(gfx.kColorBlack)

--     -- gfx.fillRect(0 + newX, 210 + newY, 400, 40)
--     -- gfx.setColor(gfx.kColorWhite)
--     -- gfx.setFont(font2)
--     -- gfx.setImageDrawMode(gfx.kDrawModeNXOR)
--     -- gfx.drawTextAligned("THRUST", 200 + newX, 218 + newY, kTextAlignment.center)
--     -- gfx.setLineWidth(1)
--     -- gfx.drawArc(newX + 200, newY + 120, 50, 0, 360)
--     -- gfx.drawText("-", newX + 130, newY + 220)
--     -- gfx.fillRect(newX + 200, newY + 228, 10 * shipSpeed, 4)
--     -- gfx.fillRect(newX + 140, newY + 233, 2, 2)
--     -- gfx.fillRect(newX + 199, newY + 233, 2, 2)
--     -- gfx.fillRect(newX + 258, newY + 233, 2, 2)
--     -- gfx.fillRect(newX + 140, newY + 235, 120, 1)
--     -- gfx.drawText("+", newX + 263, newY + 220)
--     -- gfx.drawTextAligned("THRUST", 200 + newX, 218 + newY, kTextAlignment.center)


--     -- gfx.setLineWidth(4)
--     --gfx.drawArc(newX + 200, newY + 120, limasightRadius, limaAngle + 85, limaAngle + 95)
--     -- gfx.drawArc(newX + 200, newY + 120, lavensightRadius, lavenAngle + 85, lavenAngle + 95)
--     -- gfx.drawArc(newX + 200, newY + 120, garlielsightRadius, garlielAngle + 85, garlielAngle + 95)
--     -- gfx.drawArc(newX + 200, newY + 120, mushroosightRadius, mushrooAngle + 85, mushrooAngle + 95)



--     --gfx.drawText(string.upper(location), 12 + newX, 222 + newY)
--     --gfx.drawTextAligned(newX .. ", " .. newY, 380 + newX, 222 + newY, kTextAlignment.right)
--     --gfx.drawTextAligned(tostring(location), 200 + newX, 222 + newY, kTextAlignment.center)

-- end



class('LimaNavArrow').extends(gfx.sprite)
function LimaNavArrow:init(x, y)
    local navImage = gfx.image.new("assets/images/navArrow")

    self:setImage(navImage)
    nearestPlanet = 0

    self.y = 0
    self.x = 0
    self:setRotation(nearestPlanet)
    self:setCenter(0.5, 0.5)
    self:add()
    self:setZIndex(100)
end

function LimaNavArrow:update()
    if limaText or lavenText or garlielText or mushrooText then
        self:setRotation(nearestPlanet)
        self:moveTo(newX + 200, newY + 120)
    else
        self:setRotation(0)
        self:moveTo(-200, -200)
    end
end

class('SpaceImage').extends(gfx.sprite)
function SpaceImage:init(x, y)
    local loadingImage = gfx.image.new("assets/images/SpaceBackground")

    self:setImage(loadingImage)
    self.counter = 0
    self.y = 0
    self.x = 0
    self:moveTo(newX, newY)
    self:setRotation(180)
    self:setCenter(0.5, 0.5)
    self:add()
    self:setZIndex(-900)
end

function SpaceImage:update()
    if shipSpeed > 0 and angle < 180 then
        self.counter -= 0.5
        if self.counter < -400 then
            self.counter = -400
        end
    elseif shipSpeed > 0 and angle > 180 then
        self.counter += 0.5
        if self.counter > 400 then
            self.counter = 400
        end
    end

    self:moveTo(newX + self.counter, newY + self.counter)
end

class('StarImage').extends(gfx.sprite)
function StarImage:init(x, y)
    local loadingImage = gfx.image.new("assets/images/StarBackground")

    self:setImage(loadingImage)
    self.counter = 0
    self.y = 0
    self.x = 0
    self:moveTo(newX, newY)

    self:setCenter(0.5, 0.5)
    self:add()
    self:setZIndex(-800)
end

function StarImage:update()
    if shipSpeed > 0 and angle < 180 then
        self.counter -= 0.25
        if self.counter < -400 then
            self.counter = -400
        end
    elseif shipSpeed > 0 and angle > 180 then
        self.counter += 0.25
        if self.counter > 400 then
            self.counter = 400
        end
    end

    self:moveTo(newX + self.counter, newY + self.counter)
end
