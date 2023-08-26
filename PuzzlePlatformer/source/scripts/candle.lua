local gfx <const> = playdate.graphics


class('Candle').extends(AnimatedSprite)

function Candle:init(x, y)
    local candleImageTable = gfx.imagetable.new("images/candle-table-16-16")
    Candle.super.init(self, candleImageTable)
    self:addState("idle", 1, 4, {tickStep = math.random(4,6)})
    self.currentState = "idle"
    self:setZIndex(Z_INDEXES.Prop)
    self:setImage(candleImage)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
    self:playAnimation()
    self:setTag(TAGS.Prop)
   
end