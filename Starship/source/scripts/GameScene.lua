local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk
TAGS = {
    Pickup = 1,
    Player = 5,
    Chef = 5,
    Prop = 6,
    Enemy = 3,
    Planet = 21,
    Collision = 5,
    Textbox = 10,
    Ship = 7
}

Z_INDEXES = {
    BG = -100,
    Prop = 5,
    Enemy = 5,
    Pickup = 50,
    Player = 15,
    Steam = 800,
    Planet = 10,
    Ship = 10,
    Textbox = 900
}






class('GameScene').extends(Room)

playdate.ui.crankIndicator:start()

function GameScene:init()
    startSpawner()
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
    angle = 0
    paused = false


    spacemusic:setVolume(0.5)
    spacemusic:play(0)
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
    if levelNum == 0 then
        HUD()
    end
    if pd.isCrankDocked() then
        pd.ui.crankIndicator:update()
    end
end

function HUD()
    gfx.setColor(gfx.kColorWhite)



    gfx.fillRect(-1 + newX, 219 + newY, 400, 20)
    gfx.setColor(gfx.kColorBlack)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)

    gfx.fillRect(0 + newX, 220 + newY, 400, 20)
    gfx.setColor(gfx.kColorWhite)
    gfx.setFont(font2)
    gfx.drawText("Thrust: " .. shipSpeed, 12 + newX, 222 + newY)
    gfx.drawTextAligned(newX .. ", " .. newY, 380 + newX, 222 + newY, kTextAlignment.right)
    gfx.drawTextAligned(tostring(location), 200 + newX, 222 + newY, kTextAlignment.center)
end

function playdate.gameWillPause()
    if levelNum == 0 then
        local img = gfx.getDisplayImage()
        gfx.lockFocus(img)
        local bgRect = playdate.geometry.rect.new(20, 20, 160, 200)
        local textRect = playdate.geometry.rect.new(30, 30, 140, 180)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(bgRect, 10)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRoundRect(bgRect, 10)

        -- this is the important bit here.
        -- You can of course create this string however you like,
        -- including adding a score or level or whathaveyou.
        local text = "Planets\
Laven:" .. lavenX .. ", " .. lavenY .. "\
Lima:" .. limaX .. ", " .. limaY .. "\
Garliel:" .. garlielX .. ", " .. garlielY .. "\
Mushroo:" .. mushrooX .. ", " .. mushrooY

        -- this line actually draws the text. You only need the first two parameters.
        -- See https://sdk.play.date/1.11.1/Inside%20Playdate.html#f-graphics.drawTextInRect for more details.
        gfx.drawTextInRect(text, textRect, 0, "...", kTextAlignment.left)

        gfx.unlockFocus()
        playdate.setMenuImage(img, 0)
    end
end
