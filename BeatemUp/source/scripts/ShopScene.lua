local pd <const> = playdate
local gfx <const> = playdate.graphics

local shopgrid = pd.ui.gridview.new(128, 32)




shopgrid:setNumberOfRows(#filter(items, { shopItem = true }))
shopgrid:setCellPadding(2, 2, 2, 2)

shopgrid.backgroundImage = gfx.nineSlice.new("assets/images/textBackground", 6, 6, 18, 18)
shopgrid:setContentInset(2, 2, 2, 2)



local shopgridSprite = gfx.sprite.new()
shopgridSprite:setCenter(0, 0)
shopgridSprite:moveTo(100, 70)
shopgridSprite:add()


class('ShopScene').extends(PauseRoom)


function ShopScene:init()
    gfx.setDrawOffset(0, 0)
    itemsShop = filter(items, { shopItem = true })
    itemsDairy = filter(items, { categoryID = 3 })
    itemsFlavor = filter(items, { categoryID = 4 })
    shopImage()
    shopBackground()
purchaseSFX = pd.sound.fileplayer.new('assets/sounds/purchase')
shopgrid:setSelectedRow(1)
shopgrid:setScrollPosition(0,0)

end

function ShopScene:update()
    gfx.setColor(gfx.kColorBlack)
    gfx.setFont(font1)
    gfx.drawTextInRect(itemDesc, 208, 160, 160, 48, nil, nil, kTextAlignment.center)
    gfx.drawTextAligned("$" .. credits, 384, 16, kTextAlignment.right)

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font2)



    shopgrid:drawInRect(16, 16, 160, 208)

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
purchaseSFX:play(1)

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
        shopImageShow = false
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
        gfx.drawLine(x + 20, y +height - 5, x + width, y+height - 5)
        itemDesc = itemsShop[row]["description"]
        gfx.setFont(font2)
        imageIndex = itemsShop[row]["itemID"]
    else
        gfx.setFont(font1)
    end

    function ownedItem(first, second)
        return first.found and not second.found
    end

    gfx.drawTextInRect(itemsShop[row]["name"] .. " $" .. tostring(itemsShop[row]["price"]), x + 10,
        y + (height / 2 - fontHeight / 2) + 8, width, height, nil, nil,
        kTextAlignment.center)
end

class('shopImage').extends(gfx.sprite)
function shopImage:init()
    imageIndex = 1
    itemImage = gfx.image.new("assets/images/shopItem" .. imageIndex)
    self:setImage(itemImage)

    self:setCenter(0, 0)
    self:moveTo(224, 32)
    self:add()
    self:setZIndex(800)
end

function shopImage:update()
    if shopImageShow == true then
        itemImage = gfx.image.new("assets/images/shopItem" .. imageIndex)
        self:setImage(itemImage)
    else
        itemImage = gfx.image.new("assets/images/shopItem1")
        self:setImage(recipeImage)
        self:remove()
    end
end

class('shopBackground').extends(gfx.sprite)
function shopBackground:init()
    shopBGImage = gfx.image.new("assets/images/shopBG")
    self:setImage(shopBGImage)

    self:setZIndex(300)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

function shopBackground:update()
    if shopImageShow == true then
        self:moveTo(0, 0)
    else
        self:remove()

    end
end
