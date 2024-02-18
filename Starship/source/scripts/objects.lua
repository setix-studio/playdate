local pd <const> = playdate
local gfx <const> = pd.graphics

class('Objects').extends(AnimatedSprite)

function Objects:init(x, y, entity)
    self.fields = entity.fields

    self.objectName = self.fields.object

    if self.objectName == "Tree" then
        imagetable = gfx.imagetable.new("assets/images/tree-table-48-48")
    else
        imagetable = gfx.imagetable.new("assets/images/tree-table-48-48")
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
    self:setCollideRect(18, 37, 11, 5)
end

function Objects:update()
    self:updateAnimation()
    -- cosmoSortOrder(self)
end
