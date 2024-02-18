local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk

class('InteriorBuildings').extends(Room)

function InteriorBuildings:enter()
    self.spawnX = 16 * 9

    self.spawnY = 16 * 9
print("inside")
    hudShow = false
    
    levelX = levelWidth
    gfx.setDrawOffset(0, 0)
    shipmusic:play(0)
    shipmusic:setVolume(0.5)

    paused = false
    self.levelName = levelName
    self:goToLevel("Level_0")
    self.cosmo = Cosmo(self.spawnX, self.spawnY, self)
    intDoorway()
 
end

shiptextbox = gfx.sprite.new()

shiptextbox:setCenter(0, 0)
shiptextbox:setZIndex(900)
gfx.setFont(font2)
shiptextbox:setSize(100, 40)
shiptextbox:moveTo(0, 136)
shiptextbox.text = "Game Saved." -- this is blank for now; we can set it at any point
shiptextbox.currentChar = 1      -- we'll use these for the animation
shiptextbox.currentText = ""
shiptextbox.typing = true


-- this function will calculate the string to be used.
-- it won't actually draw it; the following draw() function will.
function shiptextbox:update()
    self.currentChar = self.currentChar + 1
    if self.currentChar > #self.text then
        self.currentChar = #self.text
    end

    if self.typing and self.currentChar <= #self.text then
        shiptextbox.currentText = string.sub(self.text, 1, self.currentChar)
        self:markDirty() -- this tells the sprite that it needs to redraw
    end

    -- end typing
    if self.currentChar == #self.text then
        self.currentChar = 1
        self.typing = false
    end
end

-- this function defines how this sprite is drawn
function shiptextbox:draw()
    -- pushing context means, limit all the drawing config to JUST this block
    -- that way, the colors we set etc. won't be stuck
    gfx.pushContext()
    -- border

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 102, 90)

    -- draw the box				

    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 1, 100, 86)




    -- draw the text!
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)


    gfx.drawTextInRect(self.currentText, 10, 10, 250, 160)
    gfx.setImageDrawMode(gfx.kDrawModeXOR)


    gfx.popContext()
end

function InteriorBuildings:update()
   
    if pd.buttonJustPressed(pd.kButtonB) and showMenu == true then
        showMenu = false
        paused = false
    end

    if doorEnter == true then
        shipmusic:stop()

        if previouslevel == "Lima" then
            levelNum = 1
        elseif previouslevel == "Laven" then
            levelNum = 2
        elseif previouslevel == "Garliel" then
            levelNum = 3
        elseif previouslevel == "Mushroo" then
            levelNum = 4
        end
        cosmoX = returnX
        cosmoY = returnY
        gfx.sprite.removeAll()
        manager:enter(LoadingScene())
    end
end

function InteriorBuildings:enterRoom(direction)
    local level = ldtk.get_neighbours(self.levelName, direction)[1]
    self:goToLevel(level)
    self.cosmo:add()
    CosmoInteractBtn()

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

function InteriorBuildings:goToLevel(levelName)
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
        local entityX, entityY = entity.position.x, entity.position.y
        self.fields = entity.fields
        local entityName = entity.name
        if entityName == "Items" then
            Items(entityX, entityY, entity)
        end
    end
end

class('intDoorway').extends(AnimatedSprite)

function intDoorway:init()
    stepImageTable = gfx.imagetable.new("assets/images/steps-table-16-16")

    shipDoor.super.init(self, stepImageTable)
    self:addState("closed", 1, 1)
    self:addState("open", 2, 2)
    self.currentState = "closed"
    self:setZIndex(0)


    self:setTag(TAGS.Door)

    self:setCenter(0, 0)
    self:moveTo(16 * 9, 16 * 10)
    self:add()
    self:playAnimation()

    self:setCollideRect(0, 0, 16, 16)
end

function intDoorway:collisionResponse(other)
   
    return "overlap"
end

function intDoorway:update()
    self:updateAnimation()

end
