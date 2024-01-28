local pd <const> = playdate
local gfx <const> = playdate.graphics

local shopgrid = pd.ui.gridview.new(128, 32)



shopgrid:setNumberOfSections(1)
shopgrid:setNumberOfRowsInSection(1, #filter(items, { shopItem = true }))
shopgrid:setSectionHeaderHeight(10)
shopgrid:setCellPadding(2, 2, 2, 2)

shopgrid.backgroundImage = gfx.nineSlice.new("assets/images/menuBackground", 7, 7, 18, 18)
shopgrid:setContentInset(5, 5, 5, 5)

function shopgrid:drawSectionHeader(section, x, y, width, height)
    if section == 1 then
        categoryTitle = "Item Shop"
   
    end
    gfx.drawText(categoryTitle, x + 10, y)
end

local shopgridSprite = gfx.sprite.new()
shopgridSprite:setCenter(0, 0)
shopgridSprite:moveTo(100, 70)
shopgridSprite:add()


class('ShopScene').extends(PauseRoom)


function ShopScene:init()
    gfx.setDrawOffset(0, 0)

    for i in pairs(items) do
        if items[i]["found"] == true then
            items[i]["name"] = items[i]["name"]
            items[i]["price"] = items[i]["price"]
            items[i]["description"] = items[i]["description"]
        elseif items[i]["found"] == false then
            items[i]["name"] = "??????"
            items[i]["price"] = "??"
            items[i]["description"] = "??????"
        end
    end

    itemsShop = filter(items, { shopItem = true})
    itemsDairy = filter(items, { categoryID = 3 })
    itemsFlavor = filter(items, { categoryID = 4 })
end

function ShopScene:update()
    gfx.setBackgroundColor(gfx.kColorWhite)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorBlack)

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font2)

    shopgrid:drawInRect(12, 12, 380, 220)

    if pd.buttonJustPressed(pd.kButtonUp) then
        shopgrid:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        shopgrid:selectNextRow(true)
    end

    for i = 40, 1, -1 do
        if shopgrid:getSelectedRow() == i then
            print(itemsShop[i]["name"])
            if pd.buttonJustPressed(pd.kButtonA) then
                if credits >= itemsShop[i]["price"] then
                    credits = credits - itemsShop[i]["price"]
                    Items:addItem(itemsShop[i]["name"], 1)
                end
            end
        end
    end

    local crankTicks = pd.getCrankTicks(2)
    if crankTicks == 1 then
        shopgrid:selectNextRow(true)
    elseif crankTicks == -1 then
        shopgrid:selectPreviousRow(true)
    end

    if shopgrid.needsDisplay then
        local shopgridImage = gfx.image.new(142, 100)
        gfx.pushContext(shopgridImage)
        shopgrid:drawInRect(0, 0, 142, 100)
        gfx.popContext()
        shopgridSprite:setImage(shopgridImage)
    end
    if playdate.buttonJustPressed(playdate.kButtonB) then
        limamusic:setVolume(0.5)
        lavenmusic:setVolume(0.5)
        spacemusic:setVolume(0.5)
        textboxActive = false
        hudShow = true
        shopMenuShow = false

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

function shopgrid:drawCell(section, row, column, selected, x, y, width, height)
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

        gfx.drawTextInRect(itemsShop[row]["name"] .. " ....  $" .. tostring(itemsShop[row]["price"]), x - 10,
            y + (height / 2 - fontHeight / 2) + 8, width, height, nil, nil,
            kTextAlignment.right)

    if selected then
        gfx.setImageDrawMode(gfx.kDrawModeFillBlack)


                gfx.drawTextInRect(itemsShop[row]["description"], 160,
                    170, 220, 70, nil, nil,
                    kTextAlignment.left)
       
        
    end
end
