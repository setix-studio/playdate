local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Blockade').extends(AnimatedSprite)

function Blockade:init(x, y, entity)
    self.fields = entity.fields
    self.QuestReq = self.fields.QuestReq
    blockImageTable = gfx.imagetable.new("assets/images/blockade-table-32-32")

    Blockade.super.init(self, blockImageTable)
    self:addState("idle", 1, 4, { tickStep = math.random(4, 6) })
    self.currentState = "idle"
    self:setZIndex(10)
    self:moveTo(x, y)
    self:setCenter(0, 0)
    self:add()
    self:setCollideRect(0, 0, 32, 32)
    self:playAnimation()
    self:setZIndex(self.y)
    cosmoX = 0
    cosmoY = 0
    print(self.QuestReq)
end

function Blockade:collisionResponse(other)
    return "overlap"
end

function Blockade:update()
    self:updateAnimation()
    self:setZIndex(self.y)


    for i in pairs(quests) do
        if quests[i].ID == self.QuestReq then
            if quests[i]["complete"] == true then
                self:remove()
            end
        end
    end
    -- cosmoSortOrder(self)
end
