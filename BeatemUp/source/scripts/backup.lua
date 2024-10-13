local pd <const> = playdate
local gfx <const> = playdate.graphics

local gridview = pd.ui.gridview.new(128, 32)
options = { "Lima", "Laven" }

gridview:setNumberOfRows(#options)
gridview:setCellPadding(2, 2, 2, 2)

gridview.backgroundImage = gfx.nineSlice.new("assets/images/gridBackground", 7, 7, 18, 18)
gridview:setContentInset(5, 5, 5, 5)

local gridviewSprite = gfx.sprite.new()
gridviewSprite:setCenter(0, 0)
gridviewSprite:moveTo(100, 70)
gridviewSprite:add()

class('PauseScene').extends(PauseRoom)


function PauseScene:init()
    gfx.setDrawOffset(0, 0)
end

function PauseScene:update()
    gfx.setBackgroundColor(playdate.graphics.kColorWhite)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorBlack)

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font2)


    gridview:drawInRect(12, 12, 142, 220)

    if pd.buttonJustPressed(pd.kButtonUp) then
        gridview:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        gridview:selectNextRow(true)
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        if gridview:getSelectedRow() == 1 then
            levelNum = 1
            manager:push(LoadingScene())
        elseif gridview:getSelectedRow() == 2 then
            levelNum = 2
            manager:push(LoadingScene())
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
    if playdate.buttonJustReleased(playdate.kButtonB) then
        spacemusic:play(0)
        gfx.setBackgroundColor(gfx.kColorBlack)

        paused = false
        newX = returnX
        newY = returnY
        manager:pop()
    end
end

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

local pd <const> = playdate
local gfx <const> = playdate.graphics

local gridview = pd.ui.gridview.new(128, 32)
options = { "Lima", "Laven" }

gridview:setNumberOfRows(#options)
gridview:setCellPadding(2, 2, 2, 2)

gridview.backgroundImage = gfx.nineSlice.new("assets/images/gridBackground", 7, 7, 18, 18)
gridview:setContentInset(5, 5, 5, 5)

local gridviewSprite = gfx.sprite.new()
gridviewSprite:setCenter(0, 0)
gridviewSprite:moveTo(100, 70)
gridviewSprite:add()

class('PauseScene').extends(PauseRoom)


function PauseScene:init()
    gfx.setDrawOffset(0, 0)
end

function PauseScene:update()
    gfx.setBackgroundColor(playdate.graphics.kColorWhite)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorBlack)

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font2)


    gridview:drawInRect(12, 12, 142, 220)

    if pd.buttonJustPressed(pd.kButtonUp) then
        gridview:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        gridview:selectNextRow(true)
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        if gridview:getSelection() == options["Lima"] then
            levelNum = 1
            manager:push(LoadingScene())
        elseif gridview:getSelectedRow() == 2 then
            levelNum = 2
            manager:push(LoadingScene())
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
    if playdate.buttonJustReleased(playdate.kButtonB) then
        spacemusic:play(0)
        gfx.setBackgroundColor(gfx.kColorBlack)

        paused = false
        newX = returnX
        newY = returnY
        manager:pop()
    end
end

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
