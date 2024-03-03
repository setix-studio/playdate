local pd <const> = playdate
local gfx <const> = playdate.graphics


local gridview = pd.ui.gridview.new(128, 32)


class('HomeScene').extends(Room)

function HomeScene:init()
    gfx.sprite.removeAll()
    HomeSceneImage()
end

function HomeScene:update()
    gfx.setBackgroundColor(playdate.graphics.kColorWhite)
    gfx.setColor(gfx.kColorWhite)

  
    gfx.setFont(font2)

    gridview:drawInRect(125, 136, 150, 87)
end
options = { "New Game" }
class('HomeSceneImage').extends(AnimatedSprite)

function HomeSceneImage:init(x, y)
  

    local homeImageTable = gfx.imagetable.new("assets/images/home-table-400-240")
    HomeSceneImage.super.init(self, homeImageTable)
    self:addState("idle", 1, 1, { tickStep = 8 })
    self.currentState = "idle"
    self:setZIndex(0)

    self:moveTo(0, 0)
    self:setCenter(0, 0)
    self:add()
    self:playAnimation()
    self:setTag(TAGS.Ship)
    if saveData == false then
        options = { "New Game" }
        gridview:setNumberOfRows(#options)
    else
        options = { "Continue", "Clear Save"}
        gridview:setNumberOfRows(#options)
        
    end
    
end



gridview:setCellPadding(2, 2, 2, 2)

--gridview.backgroundImage = gfx.nineSlice.new("assets/images/gridBackground", 6, 7, 18, 18)
gridview:setContentInset(5, 5, 5, 5)

local gridviewSprite = gfx.sprite.new()
gridviewSprite:setCenter(0, 0)
gridviewSprite:moveTo(100, 70)
gridviewSprite:add()

function gridview:drawCell(section, row, column, selected, x, y, width, height)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    if selected then
        
                gfx.setDitherPattern(.5, gfx.image.kDitherTypeBayer8x8)
                gfx.setLineWidth(2)
                gfx.drawLine(x + 20, y + height - 5, x + width - 20, y + height - 5)
                gfx.setDitherPattern(1, gfx.image.kDitherTypeBayer8x8)
                gfx.setLineWidth(1)
       
        gfx.setFont(font2)
       
    else
        gfx.setFont(font1)
    end
    local fontHeight = gfx.getSystemFont():getHeight()
    gfx.drawTextInRect(options[row], x, y + (height / 2 - fontHeight / 2) + 5, width, height, nil, nil,
        kTextAlignment.center)
end

function HomeSceneImage:update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        gridview:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        gridview:selectNextRow(true)
    end


    if pd.buttonJustReleased(pd.kButtonA) then
        if saveData == false then
            
            if gridview:getSelectedRow() == 1 then
                manager:enter(LoadingScene())
            end
        else
            if gridview:getSelectedRow() == 1 then
                manager:enter(LoadingScene())
            elseif gridview:getSelectedRow() == 2 then
                saveData = false
                options = { "New Game" }
        gridview:selectNextRow(true)

        gridview:setNumberOfRows(#options)

                pd.datastore.delete(data)
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
    self:updateAnimation()
    gfx.sprite.update()
    pd.timer.updateTimers()
end
