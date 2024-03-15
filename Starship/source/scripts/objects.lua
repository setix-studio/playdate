local pd <const> = playdate
local gfx <const> = pd.graphics

class('Objects').extends(AnimatedSprite)

function Objects:init(x, y, entity)
    self.fields = entity.fields

    self.objectName = self.fields.object

    if self.objectName == "Tree" then
       if location == "Lima" then
        imagetable = gfx.imagetable.new("assets/images/tree-table-48-48")
        self:setCollideRect(18, 37, 11, 5)
       elseif location == "Laven" then
        imagetable = gfx.imagetable.new("assets/images/laventree-table-48-48")
        self:setCollideRect(18, 37, 11, 5)
       end
    elseif self.objectName == "StaticBush" then
        imagetable = gfx.imagetable.new("assets/images/bush-table-32-32")
        self:setCollideRect(1, 15, 30, 5)
    end

    Objects.super.init(self, imagetable)
    self:addState("idle", 1, 1, { tickStep = math.random(6, 8) })
    self.currentState = "idle"

    self:setImage(image)
    self:setCenter(0.5, 0.5)
    self:moveTo(x, y)
    self:add()

    self:playAnimation()


    self:setZIndex(self.y)
    self:setTag(TAGS.Object)
    
end

function Objects:update()
    self:updateAnimation()
    -- cosmoSortOrder(self)
end
