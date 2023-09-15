local gfx <const> = playdate.graphics

class('Door').extends(gfx.sprite)

function Door:init(x, y, entity)
    self.fields = entity.fields
    if self.fields.unlocked then
        return
    end

    self.doorName = self.fields.door
    local doorImage <const> = gfx.image.new("images/door")
    assert(doorImage)
    self:setImage(doorImage)
    self:setZIndex(Z_INDEXES.Door)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:setTag(TAGS.Door)
    self:setCollideRect(0, 0, self:getSize())

    _G.doorType = self.fields.KeyType
end


