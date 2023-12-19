local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk

class('Lima').extends(Room)

function Lima:enter()
    gfx.setBackgroundColor(gfx.kColorWhite)
    gfx.setColor(gfx.kColorWhite)

 
    if cosmoX == nil then
        self.spawnX = 44 * 16
    else
        self.spawnX = cosmoX
    end
    if cosmoY == nil then
        self.spawnY = 14 * 16
    else
        self.spawnY = cosmoY
    end
    hudShow = true
    cosmoHUD()

    levelX = levelWidth
    gfx.setDrawOffset(0, 0)
    limamusic:play(0)
    limamusic:setVolume(0.5)

    paused = false
    self.levelName = levelName
    if returnRoomNumber == nil then
        roomNumber = 1
    else
        roomNumber = returnRoomNumber
    end

    -- level room numbers - iterates through all rooms in a level
    for i = 20, 1, -1 do
        if levelName == "Level_" .. i then
            roomNumber = i
        end
    end


    self:goToLevel("Level_" .. roomNumber)
    self.cosmo = Cosmo(self.spawnX, self.spawnY, self)
    last_frame_time = 0
end

function Lima:resetCosmo()
    self.cosmo:moveTo(self.spawnX, self.spawnY)
end

function Lima:update()
    cosmoHUD()
end

function Lima:enterRoom(direction)
    local level = ldtk.get_neighbours(self.levelName, direction)[1]
    self:goToLevel(level)
    self.cosmo:add()
    CosmoInteractBtn()
    bMenu()
    hudShow = true

    cosmoHUD()
    local spawnX, spawnY
    spawnX, spawnY = cosmoX, cosmoY

    if direction == "north" then
        spawnX, spawnY = self.cosmo.x, levelHeight - 24
    elseif direction == "south" then
        spawnX, spawnY = self.cosmo.x, 24
    elseif direction == "east" then
        spawnX, spawnY = 24, self.cosmo.y
    elseif direction == "west" then
        spawnX, spawnY = levelWidth - 24, self.cosmo.y
    end
    self.cosmo:moveTo(spawnX, spawnY)
    self.spawnX = spawnX
    self.spawnY = spawnY
end

function Lima:goToLevel(levelName)
    if not levelName then return end

    self.levelName = levelName

    gfx.sprite.removeAll()



    _G.isMoving = false
    for layerName, layer in pairs(ldtk.get_layers(levelName)) do
        if layer.tiles then
            local tilemap = ldtk.create_tilemap(levelName, layerName)
            if levelName == "Level_1" then
                roomNumber = 1
            elseif levelName == "Level_2" then
                roomNumber = 2
            elseif levelName == "Level_3" then
                roomNumber = 3
            elseif levelName == "Level_4" then
                roomNumber = 4
            elseif levelName == "Level_5" then
                roomNumber = 5
            end
            local layerSprite = gfx.sprite.new()
            layerSprite:setTilemap(tilemap)
            layerSprite:moveTo(0, 0)
            layerSprite:setCenter(0, 0)
            layerSprite:setZIndex(layer.zIndex)
            layerSprite:add()
            levelWidth = layerSprite.width
            levelHeight = layerSprite.height

            local emptyTiles = ldtk.get_empty_tileIDs(levelName, "Solid", layerName)
            if emptyTiles then
                gfx.sprite.addWallSprites(tilemap, emptyTiles)
            end
        end
    end

    for _, entity in ipairs(ldtk.get_entities(levelName)) do
        if levelName == "Level_1" then
            roomNumber = 1
        elseif levelName == "Level_2" then
            roomNumber = 2
        elseif levelName == "Level_3" then
            roomNumber = 3
        elseif levelName == "Level_4" then
            roomNumber = 4
        elseif levelName == "Level_5" then
            roomNumber = 5
        end
        print(levelName)
        print(roomNumber)
        local entityX, entityY = entity.position.x, entity.position.y
        self.fields = entity.fields
        local entityName = entity.name
        if entityName == "Items" then
            Items(entityX, entityY, entity)
        elseif entityName == "Building" then
            Building(entityX, entityY, entity)
        elseif entityName == "Objects" then
            Objects(entityX, entityY, entity)
        elseif entityName == "Ship" then
            Ship(entityX, entityY, entity)
        end
    end
end
