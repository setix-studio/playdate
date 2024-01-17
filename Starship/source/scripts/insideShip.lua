local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk

class('InteriorShip').extends(Room)

function InteriorShip:enter()
    gfx.setBackgroundColor(gfx.kColorWhite)
    gfx.setColor(gfx.kColorWhite)

    self.spawnX = 16 * 20

    self.spawnY = 16 * 11

    hudShow = false
    for row in pairs(recipes) do
        if recipes[row]["found"] == true then
            recipes[row]["name"] = recipes[row]["name"]
            recipes[row]["description"] = recipes[row]["description"]
            recipes[row]["requiredItems"] = recipes[row]["requiredItems"]
        elseif recipes[row]["found"] == false then
            recipes[row]["name"] = "??????"
            recipes[row]["description"] = "??????"
            recipes[row]["requiredItems"] = "??????"
        end
    end
    recipeMain = filter(recipes, { categoryID = 1 })
    levelX = levelWidth
    gfx.setDrawOffset(0, 0)
    shipmusic:play(0)
    shipmusic:setVolume(0.5)

    paused = false
    self.levelName = levelName
    self:goToLevel("Level_0")
    self.cosmo = Cosmo(self.spawnX, self.spawnY, self)
    saveMenu = pd.ui.gridview.new(90, 20)
    kitchenMainMenu = pd.ui.gridview.new(190, 20)
    recipeMenu = pd.ui.gridview.new(128, 32)
    activeArea = ""
    showMenu = false
    kitchenMenuShow = false
    recipeMenu = false
    shipDoor()

    returnX = nil
    returnY = nil
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


    gfx.popContext()
end

function InteriorShip:update()
    bedSightLine = pd.geometry.distanceToPoint(270, 160, cosmoX, cosmoY)

    kitchenSightLine = pd.geometry.distanceToPoint(320, 160, cosmoX, cosmoY)

    cockpitSightLine = pd.geometry.distanceToPoint(360, 175, cosmoX, cosmoY)

    if bedSightLine <= 16 then
        if showMenu == false then
            showIntBtn = true
            activeArea = "bed"
        else
            showIntBtn = false
        end
    elseif kitchenSightLine <= 16 then
        if showMenu == false then
            showIntBtn = true
            activeArea = "kitchen"
        else
            showIntBtn = false
        end
    elseif cockpitSightLine <= 24 and pd.isCrankDocked() == false then
        if showMenu == false then
            showIntBtn = true
            activeArea = "cockpit"
        else
            showIntBtn = false
        end
    else
        activeArea = ""

        showIntBtn = false
    end




    if activeArea == "cockpit" and pd.isCrankDocked() == false then
        if pd.buttonJustPressed(pd.kButtonA) then
            hudShow = false
            paused  = true
            gfx.sprite.removeAll()
            shipmusic:stop()

            ShipTakeoff()
            levelTimer = pd.timer.performAfterDelay(3000, function()
                levelNum = 0

                manager:enter(LoadingScene())
            end)
        end
    end
    if activeArea == "kitchen" then
        if showMenu == true then
        

            kitchenMainMenu:drawInRect(20, 20, 202, 90)
            kitchenMainMenu:setNumberOfRows(#recipes)

            kitchenMainMenu:setCellPadding(2, 2, 2, 2)

            kitchenMainMenu.backgroundImage = gfx.nineSlice.new("assets/images/textBackground", 6, 6, 18, 18)
            kitchenMainMenu:setContentInset(2, 2, 2, 2)


            function kitchenMainMenu:drawCell(section, row, column, selected, x, y, width, height)
                if selected then
                    gfx.setColor(gfx.kColorBlack)
                    gfx.setFont(font2)
                   
                    gfx.setColor(gfx.kColorWhite)

                    gfx.drawTextInRect(recipes[row]["description"], 20, 120, 200, 60, nil, nil, kTextAlignment.center)
                   
                 
                    gfx.drawTextInRect(recipes[row]["requiredItems"], 40, 180, 160, 90, nil, nil, kTextAlignment.center)
                else
                gfx.setFont(font1)

                    
                end



                local fontHeight = gfx.getSystemFont():getHeight()
               

                kitchenlist = gfx.drawTextInRect(recipes[row]["name"] .. " ... " .. recipes[row]["quantity"], x,
                    y + (height / 2 - fontHeight / 2) + 3,
                    width,
                    height, nil, nil,
                    kTextAlignment.center)
            end

            if pd.buttonJustPressed(pd.kButtonUp) then
                kitchenMainMenu:selectPreviousRow(true)
            elseif pd.buttonJustPressed(pd.kButtonDown) then
                kitchenMainMenu:selectNextRow(true)
            end


            if pd.buttonJustPressed(pd.kButtonB) and recipeMenu == true then
                recipeMenu = false
            end

            if kitchenMainMenu:getSelectedRow() == 1 and recipeMenu == false then
                if pd.buttonJustPressed(pd.kButtonA) then
                    recipeMenu = true
                end
            elseif kitchenMainMenu:getSelectedRow() == 2 and recipeMenu == false then
                if pd.buttonJustPressed(pd.kButtonA) then

                end
            end
            if kitchenMainMenu:getSelectedRow() == 1 and recipeMenu == true then
                if pd.buttonJustPressed(pd.kButtonA) then
                    recipeMenu = true
                end
            elseif kitchenMainMenu:getSelectedRow() == 2 and recipeMenu == true then
                if pd.buttonJustPressed(pd.kButtonA) then

                end
            elseif kitchenMainMenu:getSelectedRow() == 3 and recipeMenu == false then
                if pd.buttonJustPressed(pd.kButtonA) then
                    Recipes:addInventory("Berry Tart")
                    print("hey")
                end
            end




            local crankTicks = pd.getCrankTicks(2)
            if crankTicks == 1 then
                kitchenMainMenu:selectNextColumn(true)
            elseif crankTicks == -1 then
                kitchenMainMenu:selectPreviousColumn(true)
            end
        end
    end


    if activeArea == "bed" then
        if showMenu == true then
            saveoptions = { "Save" }
            saveMenu:drawInRect(20, 190, 102, 30)

            saveMenu:setNumberOfRows(#saveoptions)
            saveMenu:setCellPadding(2, 2, 2, 2)

            saveMenu.backgroundImage = gfx.nineSlice.new("assets/images/textBackground", 6, 6, 18, 18)
            saveMenu:setContentInset(2, 2, 2, 2)


            function saveMenu:drawCell(section, row, column, selected, x, y, width, height)
                if selected then
                    gfx.setColor(gfx.kColorBlack)

                    gfx.fillRoundRect(x, y, width, height, 2)
                    gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
                    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
                else
                    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
                end


                local fontHeight = gfx.getSystemFont():getHeight()
                gfx.drawTextInRect(saveoptions[row], x, y + (height / 2 - fontHeight / 2) + 3, width, height, nil, nil,
                    kTextAlignment.center)
            end

            if pd.buttonJustPressed(pd.kButtonUp) then
                saveMenu:selectPreviousRow(true)
            elseif pd.buttonJustPressed(pd.kButtonDown) then
                saveMenu:selectNextRow(true)
            end




            if saveMenu:getSelectedRow() == 1 then
                if pd.buttonJustPressed(pd.kButtonA) and showMenu == true then
                    saveData = true


                    shiptextbox:add()

                    saveGameData()

                    shiptextbox.text = "Game Saved."
                    playerHP = playerMaxHP
                    shiptextclose = pd.timer.performAfterDelay(2000, function()
                        showMenu = false
                        shiptextbox.text = ""

                        shiptextbox:remove()

                        paused = false
                    end)
                end
            end



            local crankTicks = pd.getCrankTicks(2)
            if crankTicks == 1 then
                saveMenu:selectNextColumn(true)
            elseif crankTicks == -1 then
                saveMenu:selectPreviousColumn(true)
            end
        end
    end
    if pd.buttonJustPressed(pd.kButtonA) and showMenu == false and activeArea ~= "cockpit" then
        showMenu = true
        paused = true
    end
    -- if pd.buttonJustPressed(pd.kButtonB) and showMenu == false then
    --     if previouslevel == "Lima" then
    --         levelNum = 1
    --     elseif previouslevel == "Laven" then
    --         levelNum = 2
    --     elseif previouslevel == "Garliel" then
    --         levelNum = 3
    --     elseif previouslevel == "Mushroo" then
    --         levelNum = 4
    --     end
    --     gfx.sprite.removeAll()
    --     shipmusic:stop()

    --     manager:enter(LoadingScene())
    -- end
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
        gfx.sprite.removeAll()
        manager:enter(LoadingScene())
    end
end

function InteriorShip:enterRoom(direction)
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

function InteriorShip:goToLevel(levelName)
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

class('shipDoor').extends(AnimatedSprite)

function shipDoor:init()
    stepImageTable = gfx.imagetable.new("assets/images/steps-table-16-16")

    shipDoor.super.init(self, stepImageTable)
    self:addState("closed", 1, 1)
    self:addState("open", 2, 2)
    self.currentState = "open"
    self:setZIndex(0)




    self:setCenter(0, 0)
    self:moveTo(16 * 21, 16 * 12)
    self:add()
    self:playAnimation()

    self:setCollideRect(0, 0, 16, 16)
end

function shipDoor:collisionResponse(other)
    if pd.isCrankDocked() == false then
        return "slide"
    else

    end


    return "overlap"
end

function shipDoor:update()
    self:updateAnimation()

    if pd.isCrankDocked() == false then
        self:setTag(TAGS.DoorOpen)

        self:changeState("closed")
    else
        self:setTag(TAGS.Door)

        self:changeState("open")
    end
end
