local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk

TAGS = {
    Pickup = 1,
    Player = 2,
    Hazard = 3,
    Prop = 4,
    Door = 5,
    Platform = 6,
    Textbox = 7,
    Laser = 8,
    Spikes = 9,
    Camera = 10
}

Z_INDEXES = {
    Prop = 18,
    Hazard = 20,
    Pickup = 50,
    Door = 65,
    Platform = 90,
    Player = 100,
    Textbox = 900
}

ldtk.load("levels/world.ldtk")



class('GameScene').extends()

function GameScene:init()
    self:goToLevel("Level_0")
    self.spawnX = 6 * 16
    self.spawnY = 9 * 16
    _G.currentKeys = 0
    _G.keyTotal = _G.currentKeys
    _G.paused = false
    self.player = Player(self.spawnX, self.spawnY, self)
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
        if entityName == "Ability" then
            Ability(entityX, entityY, entity)
            _G.keyTotal = _G.keyTotal
        elseif entityName == "Spike" then
            Spike(entityX, entityY, entity)
        elseif entityName == "Spikeball" then
            Spikeball(entityX, entityY, entity)
        elseif entityName == "Candle" then
            Candle(entityX, entityY, entity)
        elseif entityName == "Camera" then
            Camera(entityX, entityY, entity)
        elseif entityName == "Door" then
            Door(entityX, entityY, entity)
        elseif entityName == "MovingPlatform" then
            Movingplatform(entityX, entityY, entity)
        end
    end
end
