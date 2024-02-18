local pd <const> = playdate
local gfx <const> = playdate.graphics

local gridview = pd.ui.gridview.new(160, 16)



gridview:setNumberOfSections(4)
gridview:setNumberOfRowsInSection(1, #filter(items, { category = "Meat" }))
gridview:setNumberOfRowsInSection(2, #filter(items, { category = "Fruits and Vegetables" }))
gridview:setNumberOfRowsInSection(3, #filter(items, { category = "Bread and Dairy" }))
gridview:setNumberOfRowsInSection(4, #filter(items, { category = "Flavors" }))
gridview:setSectionHeaderHeight(12)
gridview:setSectionHeaderPadding(8, 0, 4, 4)
gridview:setCellPadding(2, 2, 2, 2)

gridview.backgroundImage = gfx.nineSlice.new("assets/images/textBackground", 6, 6, 18, 18)
gridview:setContentInset(2, 2, 2, 2)

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
    gfx.drawText(categoryTitle, x, y)
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
    gridview:setSelectedRow(1)
    gridview:setScrollPosition(0,0)
end

function PauseScene:update()
    gfx.setFont(fontHud)


    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorBlack)

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font1)
    gfx.drawTextInRect(itemDesc, 208, 160, 160, 48, nil, nil, kTextAlignment.center)
    gfx.setFont(fontHud)


    gridview:drawInRect(16, 16, 160, 208)

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

    -- if gridview.needsDisplay then
    --     local gridviewImage = gfx.image.new(142, 100)
    --     gfx.pushContext(gridviewImage)
    --     gridview:drawInRect(16, 16, 192, 80)
    --     gfx.popContext()
    --     gridviewSprite:setImage(gridviewImage)
    -- end
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
        gfx.setColor(gfx.kColorBlack)
        gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)

        gfx.setFont(fontHud)
        gfx.setLineWidth(2)
        gfx.drawLine(x + 16, y + height - 3, x + width - 32, y + height - 3)
        gfx.setDitherPattern(1, gfx.image.kDitherTypeBayer8x8)
        gfx.setLineWidth(1)
    else
    end

    function ownedItem(first, second)
        return first.found and not second.found
    end

    -- table.sort(items, ownedItem)

    if section == 1 then
        gfx.drawTextInRect(itemsMeat[row]["quantity"] .. " " .. tostring(itemsMeat[row]["name"]), x + 16,
            y + (height / 2 - fontHeight / 2) + 0, width, height, nil, nil,
            kTextAlignment.left)
    elseif section == 2 then
        gfx.drawTextInRect(itemsFV[row]["quantity"] .. " " .. tostring(itemsFV[row]["name"]), x + 16,
            y + (height / 2 - fontHeight / 2) + 0, width, height, nil, nil,
            kTextAlignment.left)
    elseif section == 3 then
        gfx.drawTextInRect(itemsDairy[row]["quantity"] .. " " .. tostring(itemsDairy[row]["name"]), x + 16,
            y + (height / 2 - fontHeight / 2) + 0, width, height, nil, nil,
            kTextAlignment.left)
    elseif section == 4 then
        gfx.drawTextInRect(itemsFlavor[row]["quantity"] .. " " .. tostring(itemsFlavor[row]["name"]), x + 16,
            y + (height / 2 - fontHeight / 2) + 0, width, height, nil, nil,
            kTextAlignment.left)
    end

    if selected then
        gfx.setImageDrawMode(gfx.kDrawModeFillBlack)

        if section == 1 then
            itemDesc = itemsMeat[row]["description"]
        elseif section == 2 then
            itemDesc = itemsFV[row]["description"]
        elseif section == 3 then
            itemDesc = itemsDairy[row]["description"]
        elseif section == 4 then
            itemDesc = itemsFlavor[row]["description"]
        end
    end
end
