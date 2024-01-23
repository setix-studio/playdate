local pd <const> = playdate
local gfx <const> = playdate.graphics

local gridview = pd.ui.gridview.new(128, 32)



gridview:setNumberOfSections(4)
gridview:setNumberOfRowsInSection(1, #filter(items, { category = "Meat" }))
gridview:setNumberOfRowsInSection(2, #filter(items, { category = "Fruits and Vegetables" }))
gridview:setNumberOfRowsInSection(3, #filter(items, { category = "Bread and Dairy" }))
gridview:setNumberOfRowsInSection(4, #filter(items, { category = "Flavors" }))
gridview:setSectionHeaderHeight(10)
gridview:setCellPadding(2, 2, 2, 2)

gridview.backgroundImage = gfx.nineSlice.new("assets/images/menuBackground", 7, 7, 18, 18)
gridview:setContentInset(5, 5, 5, 5)

function gridview:drawSectionHeader(section, x, y, width, height)
    if section == 1 then
        categoryTitle = "Meat"
    elseif section == 2 then
        categoryTitle = "Fruits and Vegetables"
    elseif section == 3 then
        categoryTitle = "Bread and Dairy"
    elseif section == 4 then
        categoryTitle = "Flavors"
    end
    gfx.drawText(categoryTitle, x + 10, y)
end

local gridviewSprite = gfx.sprite.new()
gridviewSprite:setCenter(0, 0)
gridviewSprite:moveTo(100, 70)
gridviewSprite:add()
class('PauseScene').extends(PauseRoom)


function PauseScene:init()
    gfx.setDrawOffset(0, 0)
    
    for i in pairs(items) do
        if items[i]["found"] == true then
            items[i]["name"] = items[i]["name"]
            items[i]["description"] = items[i]["description"]
        elseif items[i]["found"] == false then
            items[i]["name"] = "??????"
            items[i]["description"] = "??????"
        end
    end

    itemsMeat = filter(items, { categoryID = 1 })
    itemsFV = filter(items, { categoryID = 2 })
    itemsDairy = filter(items, { categoryID = 3 })
    itemsFlavor = filter(items, { categoryID = 4 })

end

function PauseScene:update()
    gfx.setBackgroundColor(gfx.kColorWhite)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorBlack)

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font2)

    gridview:drawInRect(12, 12, 380, 220)

    if pd.buttonJustPressed(pd.kButtonUp) then
        gridview:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        gridview:selectNextRow(true)
    end
    if pd.buttonJustPressed(pd.kButtonA) then
        -- if gridview:getSelectedRow() == 1 then
        --     levelNum = 1
        --     manager:push(LoadingScene())
        -- elseif gridview:getSelectedRow() == 2 then
        --     levelNum = 2
        --     manager:push(LoadingScene())
        -- end
    end


    local crankTicks = pd.getCrankTicks(2)
    if crankTicks == 1 then
        gridview:selectNextRow(true)
    elseif crankTicks == -1 then
        gridview:selectPreviousRow(true)
    end

    if gridview.needsDisplay then
        local gridviewImage = gfx.image.new(142, 100)
        gfx.pushContext(gridviewImage)
        gridview:drawInRect(0, 0, 142, 100)
        gfx.popContext()
        gridviewSprite:setImage(gridviewImage)
    end
    if playdate.buttonJustPressed(playdate.kButtonB) then
        -- if location == "Lima" then
        --     limamusic:play(0)
        -- elseif location == "Laven" then
        --     lavenmusic:play(0)
        -- else
        --     spacemusic:play(0)
        -- end
        if levelNum == 0 then
            gfx.setBackgroundColor(playdate.graphics.kColorBlack)
        end

        limamusic:setVolume(0.5)
        lavenmusic:setVolume(0.5)
        spacemusic:setVolume(0.5)


        gfx.setImageDrawMode(gfx.kDrawModeCopy)


        paused = false

        if returnX == nil then
            returnX = 0
        end
        if returnY == nil then
            returnY = 0
        end
        newX = returnX
        newY = returnY
        manager:pop()
    end
end

function gridview:drawCell(section, row, column, selected, x, y, width, height)
    local fontHeight = gfx.getSystemFont():getHeight()
    if selected then
        gfx.fillRoundRect(x, y, width, height, 4)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    else
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end

    function ownedItem(first, second)
        return first.found and not second.found
    end

    table.sort(items, ownedItem)
  

    -- gfx.drawTextInRect(filter(items, { categoryID = section })[row]["name"] .. " ....  " .. tostring(filter(items, { categoryID = section })[row]["quantity"]), x - 10,
    --     y + (height / 2 - fontHeight / 2) + 8, width, height, nil, nil,
    --     kTextAlignment.right)
    if section == 1 then
        
        gfx.drawTextInRect(itemsMeat[row]["name"] .. " ....  " .. tostring(itemsMeat[row]["quantity"]), x - 10,
        y + (height / 2 - fontHeight / 2) + 8, width, height, nil, nil,
        kTextAlignment.right)
  
    elseif section == 2 then 
        gfx.drawTextInRect(itemsFV[row]["name"] .. " ....  " .. tostring(itemsFV[row]["quantity"]), x - 10,
        y + (height / 2 - fontHeight / 2) + 8, width, height, nil, nil,
        kTextAlignment.right)
    elseif section == 3 then 
        gfx.drawTextInRect(itemsDairy[row]["name"] .. " ....  " .. tostring(itemsDairy[row]["quantity"]), x - 10,
        y + (height / 2 - fontHeight / 2) + 8, width, height, nil, nil,
        kTextAlignment.right)
    elseif section == 4 then 
        gfx.drawTextInRect(itemsFlavor[row]["name"] .. " ....  " .. tostring(itemsFlavor[row]["quantity"]), x - 10,
        y + (height / 2 - fontHeight / 2) + 8, width, height, nil, nil,
        kTextAlignment.right)
    end
   
    if selected then
        gfx.setImageDrawMode(gfx.kDrawModeFillBlack)
        
        if section == 1 then
        gfx.drawTextInRect(itemsMeat[row]["description"], 160,
            170, 220, 70, nil, nil,
            kTextAlignment.left)
        elseif section == 2 then
            gfx.drawTextInRect(itemsFV[row]["description"], 160,
                170, 220, 70, nil, nil,
                kTextAlignment.left)
        elseif section == 3 then
                    gfx.drawTextInRect(itemsDairy[row]["description"], 160,
                        170, 220, 70, nil, nil,
                        kTextAlignment.left)
        elseif section == 4 then
                            gfx.drawTextInRect(itemsFlavor[row]["description"], 160,
                                170, 220, 70, nil, nil,
                                kTextAlignment.left)
        end
    end
end
