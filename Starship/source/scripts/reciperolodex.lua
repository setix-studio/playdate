local pd <const> = playdate
local gfx <const> = playdate.graphics

local rolodex = pd.ui.gridview.new(160, 52)





rolodex:setCellPadding(2, 2, 2, 2)

rolodex.backgroundImage = gfx.nineSlice.new("assets/images/textBackground", 6, 6, 18, 18)
rolodex:setContentInset(2, 2, 2, 2)



local rolodexSprite = gfx.sprite.new()
rolodexSprite:setCenter(0, 0)
rolodexSprite:moveTo(100, 70)
rolodexSprite:add()


class('rolodexScene').extends(PauseRoom)


function rolodexScene:init()
    gfx.setDrawOffset(0, 0)
    rolodexCards = recipes
    rolodex:setNumberOfRows(#recipes)
    recipelistInv = rolodex
    rolodex:setSelectedRow(1)
    rolodex:setScrollPosition(0, 0)
    removeRecipes = false
    showImage = true
    Recipes(256, 16)
    bgShow = true
    rolodexBackground()
end

function rolodexScene:update()
    gfx.setColor(gfx.kColorBlack)

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(fontHud)

    gfx.drawTextInRect(invItems, 208, 144, 192, 96, nil, nil, kTextAlignment.left)
    gfx.drawTextInRect(reqItems, 224, 144, 192, 96, nil, nil, kTextAlignment.left)
    gfx.drawTextInRect(itemDesc, 192, 92, 192, 48, nil, nil, kTextAlignment.center)

    rolodex:drawInRect(16, 16, 160, 208)

    if pd.buttonJustPressed(pd.kButtonUp) then
        rolodex:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        rolodex:selectNextRow(true)
    end



    local crankTicks = pd.getCrankTicks(2)
    if crankTicks == 1 then
        rolodex:selectNextRow(true)
    elseif crankTicks == -1 then
        rolodex:selectPreviousRow(true)
    end

    -- if rolodex.needsDisplay then
    --     local rolodexImage = gfx.image.new(142, 100)
    --     gfx.pushContext(rolodexImage)
    --     rolodex:drawInRect(0, 0, 142, 100)
    --     gfx.popContext()
    --     rolodexSprite:setImage(rolodexImage)
    -- end
    if playdate.buttonJustPressed(playdate.kButtonB) then
        limamusic:setVolume(0.5)
        lavenmusic:setVolume(0.5)
        spacemusic:setVolume(0.5)
        textboxActive = false
        hudShow = true
        bgShow = false
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        showImage = false
        removeRecipes = true

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

function rolodex:drawCell(section, row, column, selected, x, y, width, height)
    local fontHeight = gfx.getSystemFont():getHeight()
    if selected then
        gfx.setFont(fonthud)
        reqItems = rolodexCards[row]["requiredItems"]
                    itemDesc = rolodexCards[row]["description"]
                    if rolodexCards[row]["found"] == true then
                        invItemsQty()
                    else
                        invItems = "? / "
                    end
        imageIndex = rolodexCards[row]["index"]
        
    else
    
        gfx.setFont(fonthud)
    end
    gfx.drawLine(x, y + height, x + width, y + height)

    

    gfx.drawTextInRect(rolodexCards[row]["name"], x,
        y + (height / 2 - fontHeight / 2), width, height, nil, nil,
        kTextAlignment.center)
end

class('rolodexBackground').extends(gfx.sprite)
function rolodexBackground:init()
    shopBGImage = gfx.image.new("assets/images/shopBG")
    self:setImage(shopBGImage)

    self:setZIndex(800)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

function rolodexBackground:update()
    if bgShow == true then
        self:moveTo(0, 0)
    else
        self:remove()
    end
end
