local gfx <const> = playdate.graphics

local spikeImage <const> = gfx.image.new("images/spike")

class('Spike').extends(gfx.sprite)

function Spike:init(x, y, entity)
    self:setZIndex(Z_INDEXES.Hazard)
    self:setImage(spikeImage)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:setTag(TAGS.Spikes)
    self:setCollideRect(2, 9, 12, 7)
    self.fields = entity.fields
    self:setRotation(self.fields.Rotate)
    if self.fields.Rotate == 180 then
        self:moveTo(x + 16, y + 16)
        self:setCollideRect(2, 0, 12, 7)
    end
end