local pd <const> = playdate
local gfx <const> = playdate.graphics

local gridview = pd.ui.gridview.new(128, 32)


class('HomeScene').extends(Room)

function HomeScene:init()
    -- HomeSceneImage()
    -- music:setVolume(0.8)
    -- music:play(0)
end

function HomeScene:update()
    gfx.setBackgroundColor(playdate.graphics.kColorWhite)
    gfx.setColor(gfx.kColorBlack)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font2)
    gfx.drawTextAligned("by setix studio", 383, 169, kTextAlignment.right)
end

function HomeScene:BButtonDown()
    gfx.sprite.removeAll()
    manager:pop()
end

class('HomeSceneImage').extends(gfx.sprite)
function HomeSceneImage:init(x, y)
    homeImage = gfx.image.new("assets/images/mainhomescene")


    self:setImage(homeImage)

    self:setCenter(0, 0)
    self:add()
end

demo = false
if demo == false then
    homelist = { "All Levels", "Junk Yard", "Construction Site", "Neighborhood", "Crypt", "Reset High Score" }
else
    homelist = { "Junk Yard", "Construction Site", "Neighborhood", "Reset High Score" }
end
gridview:setNumberOfRows(#homelist)
gridview:setCellPadding(2, 2, 2, 2)

gridview.backgroundImage = gfx.nineSlice.new("assets/images/gridBackground", 7, 7, 18, 18)
gridview:setContentInset(5, 5, 5, 5)

local gridviewSprite = gfx.sprite.new()
gridviewSprite:setCenter(0, 0)
gridviewSprite:moveTo(100, 70)
gridviewSprite:add()

function gridview:drawCell(section, row, column, selected, x, y, width, height)
    if selected then
        gfx.fillRoundRect(x, y, width, height, 4)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    else
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
    local fontHeight = gfx.getSystemFont():getHeight()
    gfx.drawTextInRect(options[row], x, y + (height / 2 - fontHeight / 2) + 2, width, height, nil, nil,
        kTextAlignment.center)
end

function HomeSceneImage:update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        gridview:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        gridview:selectNextRow(true)
    end

    if demo == false then
        if pd.buttonJustPressed(pd.kButtonA) then
            if gridview:getSelectedRow() == 1 then
                levelNum = math.random(0, 39)
                manager:push(LoadingScene())
            elseif gridview:getSelectedRow() == 2 then
                levelNum = math.random(0, 9)
                manager:push(LoadingScene())
            elseif gridview:getSelectedRow() == 3 then
                levelNum = math.random(10, 19)
                manager:push(LoadingScene())
            elseif gridview:getSelectedRow() == 4 then
                levelNum = math.random(20, 29)
                manager:push(LoadingScene())
            elseif gridview:getSelectedRow() == 5 then
                levelNum = math.random(30, 39)
                manager:push(LoadingScene())
            elseif gridview:getSelectedRow() == 6 then
                HIGH_SCORE = 0
            end
        end
    else
        if pd.buttonJustPressed(pd.kButtonA) then
            if gridview:getSelectedRow() == 1 then
                levelNum = math.random(0, 1)
                manager:push(LoadingScene())
            elseif gridview:getSelectedRow() == 2 then
                levelNum = math.random(12, 13)
                manager:push(LoadingScene())
            elseif gridview:getSelectedRow() == 3 then
                levelNum = math.random(25, 26)
                manager:push(LoadingScene())
            elseif gridview:getSelectedRow() == 4 then
                HIGH_SCORE = 0
            end
        end
    end


    local crankTicks = pd.getCrankTicks(2)
    if crankTicks == 1 then
        gridview:selectNextRow(true)
    elseif crankTicks == -1 then
        gridview:selectPreviousRow(true)
    end

    if gridview.needsDisplay then
        local gridviewImage = gfx.image.new(200, 100)
        gfx.pushContext(gridviewImage)
        gridview:drawInRect(0, 0, 200, 100)
        gfx.popContext()
        gridviewSprite:setImage(gridviewImage)
    end

    gfx.sprite.update()
    pd.timer.updateTimers()
end
