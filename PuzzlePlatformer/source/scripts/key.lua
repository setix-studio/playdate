local gfx <const> = playdate.graphics

class('Key').extends(gfx.sprite)

function Key:init(x, y, entity)
    self.fields = entity.fields
    if self.fields.pickedUp then
        return
    end

    self.keyName = self.fields.key
    local KeyImage <const> = gfx.image.new("images/spikeball")
    assert(KeyImage)
    self:setImage(KeyImage)
    self:setZIndex(Z_INDEXES.Pickup)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:setTag(TAGS.Pickup)
    self:setCollideRect(0, 0, self:getSize())
end

function Key:pickUp(player, door)
    if self.keyName then
        player.hasKey = true
        door.remove()
    end
    self.fields.pickedUp = true
    self:remove()
end