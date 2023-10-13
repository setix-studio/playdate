local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk

class('LavenSceneImage').extends(gfx.sprite)
function LavenSceneImage:init(x, y)
    homeImage = gfx.image.new("assets/images/laven-2")
    self.speed = 0.25
    self.x = 0
    self.y = 0
    self:setImage(homeImage)
    self:setZIndex(-900)
    self:setCenter(0, 0)
    self:add()
end

function LavenSceneImage:update()
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

class('LavenBackImage').extends(gfx.sprite)
function LavenBackImage:init(x, y)
    homeImage = gfx.image.new("assets/images/laven-1")
    self.speed = 0.125
    self.x = 0
    self.y = 0
    self:setImage(homeImage)
    self:setZIndex(-920)
    self:setCenter(0, 0)
    self:add()
end

function LavenBackImage:update()
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

class('Laven').extends(Room)

function Laven:init()
    gfx.setBackgroundColor(gfx.kColorWhite)

    print("On Laven")
    levelNum = 2
    self:goToLevel("Level_" .. levelNum)
    LavenSceneImage()
    LavenBackImage()
    Sidekick()
    ChefInteractBtn()

    self.spawnX = 17 * 16
    self.spawnY = 7 * 16
    gfx.setDrawOffset(0, 0)
    lavenmusic:play(0)
    _G.paused = false
    self.chef = Chef(self.spawnX, self.spawnY, self)


    --fluid = Fluid.new(50, 100, 200, 240 - 180)
end

function Laven:resetChef()
    self.chef:moveTo(self.spawnX, self.spawnY)
end

function Laven:update()
    -- gfx.setColor(gfx.kColorWhite)
    -- fluid:fill()
    -- gfx.setColor(gfx.kColorBlack)
    -- gfx.setDitherPattern(0.5)
    -- fluid:fill()


    -- fluid:update()
end

function Laven:enterRoom(direction)
    local level = ldtk.get_neighbours(self.levelName, direction)[1]
    self:goToLevel(level)
    self.chef:add()
    Sidekick()
    ChefInteractBtn()
    LavenBackImage()
    LavenSceneImage()

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

function Laven:goToLevel(levelName)
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
