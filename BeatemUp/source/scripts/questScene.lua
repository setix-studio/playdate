local pd <const> = playdate
local gfx <const> = playdate.graphics

local questList = pd.ui.gridview.new(160, 32)

questList:setCellPadding(2, 2, 2, 2)

questList.backgroundImage = gfx.nineSlice.new("assets/images/textBackground", 6, 6, 18, 18)
questList:setContentInset(2, 2, 2, 2)



local questSprite = gfx.sprite.new()
questSprite:setCenter(0, 0)
questSprite:moveTo(100, 70)
questSprite:add()


class('questScene').extends(PauseRoom)


function questScene:init()
    gfx.setDrawOffset(0, 0)
    
    bgShow = true
    questBackground()
    questList:setSelectedRow(1)
    questList:setScrollPosition(0, 0)

    
end

function activeQuest(first, second)
    return first.inProgress and not second.inProgress
end

function questScene:update()
    
    gfx.setColor(gfx.kColorBlack)

    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    gfx.setFont(fontHud)

    activeQuests = filter(quests, { inProgress = true })
    questList:setNumberOfRows(#quests)
    -- table.sort(quests, activeQuest)

    gfx.drawTextInRect(questDescription, 192, 92, 192, 92, nil, nil, kTextAlignment.center)


    questList:drawInRect(16, 16, 160, 208)

    if pd.buttonJustPressed(pd.kButtonUp) then
        questList:selectPreviousRow(true)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        questList:selectNextRow(true)
    end


    local crankTicks = pd.getCrankTicks(2)
    if crankTicks == 1 then
        questList:selectNextRow(true)
    elseif crankTicks == -1 then
        questList:selectPreviousRow(true)
    end

    -- if quest.needsDisplay then
    --     local questImage = gfx.image.new(142, 100)
    --     gfx.pushContext(questImage)
    --     questList:drawInRect(0, 0, 142, 100)
    --     gfx.popContext()
    --     questSprite:setImage(questImage)
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

function questList:drawCell(section, row, column, selected, x, y, width, height)
    local fontHeight = gfx.getSystemFont():getHeight()
    
    if selected then
        gfx.setFont(fonthud)

        selectedX = 0
        selectedAlignment = kTextAlignment.center
       
    
        for _, quest in ipairs(quests) do
            if  quests[row]["found"] == true then
              
                questDescription = quests[row]["description"]
            else  
                questDescription = "?????"
              
            end
    
        end
        
    else
        selectedAlignment = kTextAlignment.left
        selectedX = 10
    end
    for _, quest in ipairs(quests) do
        if  quests[row]["found"] == true then
           
            
            questTitle = quests[row]["title"]
           
        else  
      
           questTitle = "?????"
        end

    end
    gfx.drawLine(x, y + height, x + width - 5, y + height)
    if quests[row]["complete"] == true then
        gfx.drawLine(x + 5, y + height / 2, x + width - 10, y + height / 2)
    end

    gfx.drawTextInRect(questTitle, x + selectedX,
        y + (height / 2 - fontHeight / 2), width, height, nil, nil,
        selectedAlignment)
end

class('questBackground').extends(gfx.sprite)
function questBackground:init()
    shopBGImage = gfx.image.new("assets/images/shopBG")
    self:setImage(shopBGImage)

    self:setZIndex(920)
    self:setCenter(0, 0)
    self:moveTo(0, 0)
    self:add()
end

function questBackground:update()
    if bgShow == true then
        self:moveTo(0, 0)
    else
        self:remove()
    end
end
