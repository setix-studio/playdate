local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk

class('LimaSceneImage').extends(gfx.sprite)
function LimaSceneImage:init(x, y)
    homeImage = gfx.image.new("assets/images/laven-2")
    self.speed = 0.25
    self.x = 0
    self.y = 0
    self:setImage(homeImage)
    self:setZIndex(-900)
    self:setCenter(0, 0)
    self:add()
end

function LimaSceneImage:update()
    if posX == true then
        self.x += self.speed
        self:moveTo(self.x, self.y)
    elseif negX == true then
        self.x -= self.speed
        self:moveTo(self.x, self.y)
    end

    if self.x > 10 then
        self.x = 10
    end
    if self.x < -10 then
        self.x = -10
    end
end

class('LimaBackImage').extends(gfx.sprite)
function LimaBackImage:init(x, y)
    homeImage = gfx.image.new("assets/images/laven-1")
    self.speed = 0.125
    self.x = 0
    self.y = 0
    self:setImage(homeImage)
    self:setZIndex(-920)
    self:setCenter(0, 0)
    self:add()
end

function LimaBackImage:update()
    if posX == true then
        self.x += self.speed
        self:moveTo(self.x, self.y)
    elseif negX == true then
        self.x -= self.speed
        self:moveTo(self.x, self.y)
    end

    if self.x > 10 then
        self.x = 10
    end
    if self.x < -10 then
        self.x = -10
    end
end

class('Lima').extends(Room)

function Lima:init()
    gfx.setBackgroundColor(gfx.kColorWhite)

    print("On Lima")
   
   
    if firstContact == nil then 
        firstContact = true
    end
if firstContact == true then
    levelNum = 1
    self.spawnX = 11 * 16
    self.spawnY = 7 * 16
    firstContact = false
else
            levelNum = 3
        self.spawnX = 11 * 16
        self.spawnY = 7 * 16
end
    gfx.setDrawOffset(0, 0)
    limamusic:play(0)
    _G.paused = false
    self:goToLevel("Level_" .. levelNum)
    LimaSceneImage()
    LimaBackImage()
    Sidekick()
    ChefInteractBtn()
    self.chef = Chef(self.spawnX, self.spawnY, self)

    --pdDialogue.say("Welcome to Lima!", { width = 400, height = 80, x = 0, y = 80, padding = 10 })

    --fluid = Fluid.new(50, 100, 200, 240 - 180)
end

function Lima:resetChef()
    self.chef:moveTo(self.spawnX, self.spawnY)
end

function Lima:update()
   
    -- gfx.setColor(gfx.kColorWhite)
    -- fluid:fill()
    -- gfx.setColor(gfx.kColorBlack)
    -- gfx.setDitherPattern(0.5)
    -- fluid:fill()

    -- fluid:update()
end

function Lima:enterRoom(direction)
    local level = ldtk.get_neighbours(self.levelName, direction)[1]
    self:goToLevel(level)
    self.chef:add()
    Sidekick()
    ChefInteractBtn()

    LimaSceneImage()
    LimaBackImage()

    local spawnX, spawnY
    if direction == "north" then
        spawnX, spawnY = self.chef.x, 220
    elseif direction == "south" then
        spawnX, spawnY = self.chef.x, 24
    elseif direction == "east" then
        spawnX, spawnY = 24, self.chef.y
    elseif direction == "west" then
        spawnX, spawnY = 380, self.chef.y
    end
    self.chef:moveTo(spawnX, spawnY)
    self.spawnX = spawnX
    self.spawnY = spawnY
    _G.currentKeys = _G.keyTotal
end

function Lima:goToLevel(levelName)
    if not levelName then return end

    self.levelName = levelName

    gfx.sprite.removeAll()


    _G.isMoving = false
    for layerName, layer in pairs(ldtk.get_layers(levelName)) do
        if layer.tiles then
            local tilemap = ldtk.create_tilemap(levelName, layerName)

            local layerSprite = gfx.sprite.new()
            layerSprite:setTilemap(tilemap)
            layerSprite:moveTo(0, 0)
            layerSprite:setCenter(0, 0)
            layerSprite:setZIndex(layer.zIndex)
            layerSprite:add()

            local emptyTiles = ldtk.get_empty_tileIDs(levelName, "Solid", layerName)
            if emptyTiles then
                gfx.sprite.addWallSprites(tilemap, emptyTiles)
            end
        end
    end

    for _, entity in ipairs(ldtk.get_entities(levelName)) do
        local entityX, entityY = entity.position.x, entity.position.y
        self.fields = entity.fields
        local entityName = entity.name
        if entityName == "Items" then
            Items(entityX, entityY, entity)
            _G.keyTotal = _G.keyTotal
        elseif entityName == "Spike" then
            Spike(entityX, entityY, entity)
        elseif entityName == "Spikeball" then
            Spikeball(entityX, entityY, entity)
        elseif entityName == "Ship" then
            Ship(entityX, entityY, entity)
        elseif entityName == "Camera" then
            Camera(entityX, entityY, entity)
        elseif entityName == "Door" then
            Door(entityX, entityY, entity)
        elseif entityName == "MovingPlatform" then
            Movingplatform(entityX, entityY, entity)
        end
    end
end
