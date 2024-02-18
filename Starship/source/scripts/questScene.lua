local pd <const> = playdate
local gfx <const> = playdate.graphics

local questlist = pd.ui.gridview.new(128, 32)

-- ["ID"] = 1,
-- ["intro"] = false,
-- ["inProgress"] = false,
-- ["complete"] = false,
-- ["title"] = "Gather Berries",
-- ["owner"] = "Junlop",
-- ["description"] = "Junlop is looking to make a Berry Tart, but is out of berries. Help him gather 30 berries.",
-- ["quantity"] = 30,
-- ["reward"] = "Berry Tart"


questlist:setCellPadding(2, 2, 2, 2)

questlist.backgroundImage = gfx.nineSlice.new("assets/images/menuBackground", 7, 7, 18, 18)
questlist:setContentInset(5, 5, 5, 5)

local gridviewSprite = gfx.sprite.new()
gridviewSprite:setCenter(0, 0)
gridviewSprite:moveTo(100, 70)
gridviewSprite:add()
class('questScene').extends(PauseRoom)


function questScene:init()
    gfx.setDrawOffset(0, 0)
    formCount = 0 
    for i,v in ipairs(quests) do 
        if v.inProgress == true then 
            formCount = formCount + 1 
        end 
    end 

questlist:setNumberOfRows(formCount)
questlist:setScrollPosition(0,0)
end

function questScene:update()
   
   
    gfx.setBackgroundColor(gfx.kColorWhite)

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
    gfx.setColor(gfx.kColorBlack)
    
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(font2)
    
    questlist:drawInRect(12, 12, 380, 220)

    if pd.buttonJustPressed(pd.kButtonUp) then
        questlist:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        questlist:selectNextRow(true)
    end
    if pd.buttonJustPressed(pd.kButtonA) then
        -- if questlist:getSelectedRow() == 1 then
        --     levelNum = 1
        --     manager:push(LoadingScene())
        -- elseif questlist:getSelectedRow() == 2 then
        --     levelNum = 2
        --     manager:push(LoadingScene())
        -- end
    end


    local crankTicks = pd.getCrankTicks(2)
    if crankTicks == 1 then
        questlist:selectNextRow(true)
    elseif crankTicks == -1 then
        questlist:selectPreviousRow(true)
    end

    if questlist.needsDisplay then
        local gridviewImage = gfx.image.new(142, 100)
        gfx.pushContext(gridviewImage)
        questlist:drawInRect(0, 0, 142, 100)
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

function questlist:drawCell(section, row, column, selected, x, y, width, height)
    local fontHeight = gfx.getSystemFont():getHeight()
    if selected then
        gfx.fillRoundRect(x, y, width, height, 4)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    else
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
    
    function activeQuest(first, second)
        return first.inProgress and not second.inProgress
      end
      
      table.sort(quests, activeQuest)

      
        gfx.drawTextInRect(quests[row]["title"], x - 10,
            y + (height / 2 - fontHeight / 2) + 8, width, height, nil, nil,
            kTextAlignment.right)
 
    if selected then
        gfx.setImageDrawMode(gfx.kDrawModeFillBlack)

        gfx.drawTextInRect(quests[row]["description"], 160,
            170, 220, 70, nil, nil,
            kTextAlignment.left)
    end
end 


