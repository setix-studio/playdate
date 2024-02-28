local pd <const> = playdate
local gfx <const> = playdate.graphics



local ldtk <const> = LDtk

class('Lima').extends(Room)

function Lima:enter()
    gfx.setBackgroundColor(gfx.kColorWhite)

    if returnX == nil then
        self.spawnX = 9 * 16
    else
        self.spawnX = returnX
    end
    if returnY == nil then
        self.spawnY = 9 * 16
    else
        self.spawnY = returnY
    end
    hudShow = true
    showBanner = true
    doorEnter = false
    levelX = levelWidth
    gfx.setDrawOffset(0, 0)
    limamusic:play(0)
    limamusic:setVolume(0.5)
    print(returnX, returnY)
    enterCamp = true
    bannerTimer = true
    areaName = "Hanger"

    doorWayName = "Level_2"
    paused = false
    self.levelName = levelName
    if levelName == nil then
        levelName = "Level_1"
    else
        levelName = returnRoom
    end
    if returnRoomNumber == nil then
        returnRoomNumber = 1
    else
        returnRoomNumber = roomNumber
    end
    location = "Lima"
    -- level room numbers - iterates through all rooms in a level
    for i = 20, 1, -1 do
        if levelName == "Level_" .. i then
            roomNumber = i
        end
    end


    textY = 0
    self:goToLevel("Level_" .. returnRoomNumber)
    self.cosmo = Cosmo(self.spawnX, self.spawnY, self)
    cosmoHUD()
end

function Lima:resetCosmo()
    self.cosmo:moveTo(self.spawnX, self.spawnY)
end

function Lima:update()
    cosmoHUD()

    if doorEnter == true then
        self:goToLevel(doorWayName)
        self.cosmo = Cosmo(16 * 10, 16 * 9, self)
        hudShow = false
        activeArea = ""

        doorEnter = false
    end
end

function Lima:enterRoom(direction)
    local level = ldtk.get_neighbours(self.levelName, direction)[1]
    self:goToLevel(level)
    self.cosmo:add()
    CosmoInteractBtn()
    hudShow = true

    enterCamp = true

    textY = 0
    bMenu()
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
            local roomNumbers = {
                Level_1 = 1,
                Level_2 = 2,
                Level_3 = 3,
                Level_4 = 4,
                Level_5 = 5,
                Level_6 = 6,
                Level_7 = 7,
                Level_8 = 8,
                Level_9 = 9,
                Level_10 = 10,
                Level_11 = 11,
                Level_12 = 12,
                Level_13 = 13,
                Interior_1 = 21
            }

            local roomNumber = roomNumbers[levelName]

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
            areaName = "Hanger"
        elseif levelName == "Level_2" then
            roomNumber = 2
            areaName = "Truffle Town"
        elseif levelName == "Level_3" then
            roomNumber = 3
            areaName = "Berry Bluffs"
        elseif levelName == "Level_4" then
            roomNumber = 4
            areaName = "Berry Bluffs"
        elseif levelName == "Level_5" then
            roomNumber = 5
            areaName = "Berry Bluffs"
        elseif levelName == "Level_6" then
            roomNumber = 6
            areaName = "Berry Bluffs"
        elseif levelName == "Level_7" then
            roomNumber = 7
            areaName = "Berry Bluffs"
        elseif levelName == "Level_8" then
            roomNumber = 8
            areaName = "Berry Bluffs"
        elseif levelName == "Level_9" then
            roomNumber = 9
            areaName = "Berry Bluffs"
        elseif levelName == "Level_10" then
            roomNumber = 10
            areaName = "Berry Bluffs"
        elseif levelName == "Level_11" then
            roomNumber = 11
            areaName = "Campfire"
        elseif levelName == "Level_12" then
            roomNumber = 12
            areaName = "Berry Bluffs"
        elseif levelName == "Level_13" then
            roomNumber = 13
            areaName = "Berry Bluffs"
        elseif levelName == "Interior_1" then
            roomNumber = 21
        end
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
        elseif entityName == "NPC" then
            NPC(entityX, entityY, entity)
        elseif entityName == "Campfire" then
            Campfire(entityX, entityY, entity)
        elseif entityName == "Blockade" then
            Blockade(entityX, entityY, entity)
        end
    end
end

function playdate.gameWillPause()
    local img = gfx.getDisplayImage()
    if location == nil then
        location = "Space"
    else
        location = location
    end
    gfx.lockFocus(img)
    --if location == "Lima" then
    --     local bgRect = playdate.geometry.rect.new(10, 10, 180, 220)
    --     local bgRectBorder = playdate.geometry.rect.new(15, 15, 170, 210)
    --     local limaRoom1 = playdate.geometry.rect.new(62, 74, 48, 32)
    --     local limaRoom2 = playdate.geometry.rect.new(109, 74, 32, 48)
    --     local limaRoom3 = playdate.geometry.rect.new(62, 121, 48, 32)
    --     local limaRoom4 = playdate.geometry.rect.new(109, 121, 32, 24)
    --     local limaRoom5 = playdate.geometry.rect.new(109, 144, 24, 32)
    --     local limaRoom6 = playdate.geometry.rect.new(110, 121, 24, 32)
    --     local limaRoom7 = playdate.geometry.rect.new(110, 121, 24, 32)
    --     gfx.setColor(gfx.kColorBlack)
    --     gfx.fillRoundRect(bgRect, 5)
    --     gfx.setLineWidth(1)
    --     gfx.setColor(gfx.kColorWhite)
    --     gfx.drawRoundRect(bgRectBorder, 5)

    --     gfx.setFont(fontHud)
    --     gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    --     gfx.drawTextAligned(string.upper(location), 101, 50, kTextAlignment.center)


    --     gfx.drawRect(limaRoom1)
    --     gfx.drawRect(limaRoom2)
    --     gfx.drawRect(limaRoom3)
    --     gfx.drawRect(limaRoom4)
    --     gfx.drawRect(limaRoom5)
    --     gfx.drawRect(limaRoom6)
    --     gfx.drawRect(limaRoom7)

    --     if roomNumber == 1 then
    --         gfx.fillRect(limaRoom1)
    --     elseif roomNumber == 2 then
    --         gfx.fillRect(limaRoom2)
    --     elseif roomNumber == 3 then
    --         gfx.fillRect(limaRoom3)
    --     elseif roomNumber == 4 then
    --         gfx.fillRect(limaRoom4)
    --     elseif roomNumber == 5 then
    --         gfx.fillRect(limaRoom5)
    --     elseif roomNumber == 6 then
    --         gfx.fillRect(limaRoom6)
    --     elseif roomNumber == 7 then
    --         gfx.fillRect(limaRoom7)
    --     end
    -- end

    gfx.unlockFocus()
    playdate.setMenuImage(img, 0)
end
