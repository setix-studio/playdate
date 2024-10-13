local pd <const> = playdate
local gfx <const> = playdate.graphics

local ldtk <const> = LDtk


class('CampfireScene').extends(Room)

function CampfireScene:enter()
    self.spawnX = 12 * 16

    self.spawnY = 8 * 16

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
    campmusic:play(0)
    campmusic:setVolume(0.5)
    enterCamp = false
    paused = false
    self.levelName = levelName
    self:goToLevel("Level_1")
    self.cosmo = Cosmo(self.spawnX, self.spawnY, self)
    saveMenu = pd.ui.gridview.new(90, 27)

    activeArea = ""
    showCampMenu = false
    kitchenMenuShow = false
    recipeMenu = false
    shipDoor()
    removeRecipes = false
    showImage = false
infoText = ""
infoX = -16
infoY = -16
    recipelistInv = kitchenMainMenu
    fromPop = true
end

shiptextbox = gfx.sprite.new()

shiptextbox:setCenter(0, 0)
shiptextbox:setZIndex(900)
gfx.setFont(font2)
shiptextbox:setSize(400, 40)
shiptextbox:moveTo(0, 0)
shiptextbox.text = ""       -- this is blank for now; we can set it at any point
shiptextbox.currentChar = 1 -- we'll use these for the animation
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
    gfx.fillRect(0, 1, 400, 90)

    -- draw the box				

    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 90)




    -- draw the text!
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)


    gfx.drawTextInRect(self.currentText, 10, 10, 250, 160, kTextAlignment.center)
    gfx.setImageDrawMode(gfx.kDrawModeXOR)


    gfx.popContext()
end

function CampfireScene:update()
    if showCampMenu == true then
        saveoptions = { "Make Trail Mix", "Save and Rest", "Leave Camp" }
        saveMenu:drawInRect(16, 128, 105, 100)
        paused = true
        saveMenu:setNumberOfRows(#saveoptions)
        saveMenu:setCellPadding(2, 2, 2, 2)

        saveMenu.backgroundImage = gfx.nineSlice.new("assets/images/textBackground", 6, 6, 18, 18)
        saveMenu:setContentInset(2, 2, 2, 2)
        gfx.setImageDrawMode(gfx.kDrawModeNXOR)
        gfx.setColor(gfx.kColorWhite)
        invItems = items[1].quantity ..
            "\n" ..
            items[15].quantity .. "\n" .. items[6].quantity .. "\n" .. items[11].quantity .. "\n" .. items[40].quantity
        gfx.drawTextInRect(invItems, 266, 144, 192, 96, nil, nil, kTextAlignment.left)
        gfx.drawTextInRect(reqItems, 282, 144, 192, 96, nil, nil, kTextAlignment.left)
        gfx.drawTextAligned(infoText, infoX, infoY, kTextAlignment.left)
        gfx.drawTextAligned("$" .. credits, 384, 16, kTextAlignment.right)

        gfx.setImageDrawMode(gfx.kDrawModeXOR)
        function saveMenu:drawCell(section, row, column, selected, x, y, width, height)
            if selected then
                gfx.setColor(gfx.kColorBlack)
                gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)


                gfx.setLineWidth(2)
                gfx.drawLine(x + 10, y + height - 3, x + width - 10, y + height - 3)
                gfx.setDitherPattern(1, gfx.image.kDitherTypeBayer8x8)
                gfx.setLineWidth(1)
                gfx.setColor(gfx.kColorWhite)
                reqItems = recipes[18]["requiredItems"]
            end


            gfx.setFont(fontHud)


            local fontHeight = gfx.getSystemFont():getHeight()
            gfx.drawTextInRect(saveoptions[row], x, y + (height / 2 - fontHeight / 2) + 3, width, height, nil, nil,
                kTextAlignment.center)
        end

        if pd.buttonJustPressed(pd.kButtonUp) then
            saveMenu:selectPreviousRow(true)
        elseif pd.buttonJustPressed(pd.kButtonDown) then
            saveMenu:selectNextRow(true)
        end

        gfx.setColor(gfx.kColorWhite)

        

        if saveMenu:getSelectedRow() == 1 then
            if pd.buttonJustReleased(pd.kButtonA) and showCampMenu == true then
                stockedIng = false
                if items[1].quantity > 5 and
                    items[15].quantity > 5 and
                    items[6].quantity > 5 and
                    items[11].quantity > 5 and
                    items[40].quantity > 1 then
                    stockedIng = true
                end
                print(stockedIng)

                if stockedIng == true then
                    Recipes:addInventory("Trail Mix")
                    infoText = "+1 Trail Mix"
                    infoX = 16
                    infoY = 16
                        textboxTimer = pd.timer.performAfterDelay(1000, function()
                            textboxActive = false
                            infoText = ""
                            stockedIng = false
                            infoX = -16
                    infoY = -16
                        end)

                   
                elseif stockedIng == false then
        infoText = "Not Enough Ingredients."
        infoX = 16
        infoY = 16

                    shiptextclose = pd.timer.performAfterDelay(2000, function()
                        shiptextbox.currentText = ""
                        stockedIng = false
                        infoText = ""
                        infoX = -16
                    infoY = -16
                        paused = false
                    end)
                end
                shiptextbox:add()
            end
        elseif saveMenu:getSelectedRow() == 2 then
            if pd.buttonJustReleased(pd.kButtonA) and showCampMenu == true then
                saveData = true

                infoText = "Game Saved."
                infoX = 16
                infoY = 16


                saveGameData()
                

                playerHP      = playerMaxHP
                returnRoom    = levelName
                roomNumber    = returnRoomNumber
                shiptextclose = pd.timer.performAfterDelay(2000, function()
                    showCampMenu = false
                    shiptextbox.currentText = ""
                    infoText = ""
                    shiptextbox:remove()
                    infoX = -16
                    infoY = -16
                    paused = false
                    campmusic:stop()

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
                end)
            end
        elseif saveMenu:getSelectedRow() == 3 then
            if pd.buttonJustReleased(pd.kButtonA) and showCampMenu == true then
                returnRoom       = levelName
                roomNumber       = returnRoomNumber

                showCampMenu     = false
                shiptextbox.text = ""

                shiptextbox:remove()

                paused = false
                campmusic:stop()

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



        local crankTicks = pd.getCrankTicks(2)
        if crankTicks == 1 then
            saveMenu:selectNextColumn(true)
        elseif crankTicks == -1 then
            saveMenu:selectPreviousColumn(true)
        end




        if pd.buttonJustPressed(pd.kButtonB) and showCampMenu == true then
            showCampMenu = false
            paused = false
        end
    end
end

function CampfireScene:enterRoom(direction)
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

function CampfireScene:goToLevel(levelName)
    if not levelName then return end

    self.levelName = levelName

    gfx.sprite.removeAll()

    cosmoX = returnX
    cosmoY = returnY

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
        elseif entityName == "Log" then
            Log(entityX, entityY, entity)
        end
    end
end
