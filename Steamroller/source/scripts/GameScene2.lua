local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk
TAGS = {
    Pickup = 1,
    Player = 2,
    Prop = 6,
    Enemy = 3,
    Collision = 4,
    Steam = 5,
    Textbox = 10
}

Z_INDEXES = {
    BG = -100,
    Prop = 5,
    Enemy = 5,
    Pickup = 50,
    Player = 10,
    Steam = 800,
    Collision = 200,
    Textbox = 900
}

ldtk.load("levels/world2.ldtk")


class('GameScene').extends(Room)

playdate.ui.crankIndicator:start()

function GameScene:init()
    gfx.setBackgroundColor(gfx.kColorWhite)
    remainingTime = 30

    self:goToLevel("Level_" .. levelNum)
    self.spawnX = 12 * 16
    self.spawnY = 4 * 16
    self.player = Player(self.spawnX, self.spawnY, self)
    score = currentScore
    angle = 0
    paused = false
    pd.resetElapsedTime()
    startSpawner()
    currentMilliseconds = playdate.getCurrentTimeMilliseconds()
    elapsedTime = playdate.getElapsedTime()
    levelTime = 30
    if levelNum >= 30 and levelNum <= 39 then
        gameloop = pd.sound.fileplayer.new('assets/sounds/crypt')
    else
        gameloop = pd.sound.fileplayer.new('assets/sounds/junkyard')
    end

    gameloop:setVolume(0.5)
    gameloop:play(0)
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
                layerSprite:setTag(TAGS.Collision)
            end
        end
    end

    for _, entity in ipairs(ldtk.get_entities(levelName)) do
        local entityX, entityY = entity.position.x, entity.position.y
        self.fields = entity.fields
        local entityName = entity.name
        if entityName == "Collision" then
            Collision(entityX, entityY, entity)
        elseif entityName == "Barrel" then
            Barrel(entityX, entityY, entity)
        end
    end
end

function GameScene:update()
    HUD()
    if pd.isCrankDocked() then
        pd.ui.crankIndicator:update()
    end
    currentMilliseconds = pd.getCurrentTimeMilliseconds()

    elapsedTime = pd.getElapsedTime()

    remainingTime = levelTime - elapsedTime
    if score < 0 then
        score = 0
    end

    if remainingTime <= 0 then
        remainingTime = 0

        if score >= HIGH_SCORE then
            HIGH_SCORE = score
        else
            HIGH_SCORE = HIGH_SCORE
        end
        saveGameData()
        music:stop()
        sfxBackup:stop()
        sfxDrive:stop()
        sfxMole:stop()
        sfxSquish:stop()
        gameloop:stop()
        manager:push(GameOverScene())


        stopSpawner()
    elseif remainingTime > 30 then
        remainingTime = 30
    end

    if enemyCounter >= 20 then
        stopSpawner()
    end
end

function HUD()
    gfx.setColor(gfx.kColorWhite)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font2)
    gfx.drawText("Score: " .. score, 12, 0)

    gfx.drawRoundRect(320, 3, 68, 10, 4)
    gfx.fillRoundRect(322, 5, remainingTime * 2, 6, 4)

    --gfx.drawText("Level: " .. levelNum, 170, 2, font1)

    --gfx.drawText("" .. math.floor(remainingTime), 370, 2, font1)
end
