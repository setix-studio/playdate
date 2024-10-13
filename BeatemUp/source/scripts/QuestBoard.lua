local pd <const> = playdate
local gfx <const> = playdate.graphics


class('QuestBoard').extends(AnimatedSprite)

function QuestBoard:init(x, y, entity)
    self.fields = entity.fields

    QuestBoardImageTable = gfx.imagetable.new("assets/images/questboard-table-64-64.png")


    QuestBoard.super.init(self, QuestBoardImageTable)


    self:addState("shop", 1, 1)
    
    self:setZIndex(self.y + 10)
   
    self:setCenter(0.5, 0.5)
    self:moveTo(x, y)
    self:add()
    self:playAnimation()
    newX = 0
    newY = 0    
    self:setTag(TAGS.QuestBoard)
    self:setCollideRect(4, 30, 58, 16)
end

function QuestBoard:collisionResponse(other)
    return "overlap"
end

function QuestBoard:update()
    -- cosmoSortOrder(self)
    self:updateAnimation()
    self:setZIndex(self.y + 10)
   
        questboardSightLine = pd.geometry.distanceToPoint(self.x, self.y, cosmoX, cosmoY)
        if questboardSightLine <= 32 then
            
                showIntBtn = true
                
           if paused == false then
                if pd.buttonJustReleased(pd.kButtonA) then
                    limamusic:setVolume(0.2)
                    lavenmusic:setVolume(0.2)
                    paused = true
                    manager:push(questScene())
                end
            end
        else
            showIntBtn = false
        end
    
end


