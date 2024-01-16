local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Ship').extends(AnimatedSprite)

function Ship:init(x, y, entity)
    self.fields = entity.fields

    busImageTable = gfx.imagetable.new("assets/images/bus-table-96-96")

    Ship.super.init(self, busImageTable)
    self:addState("idle", 1, 4, {tickStep = math.random(4,6)})
    self.currentState = "idle"
    self:setZIndex(10)
    self:moveTo(x, y)
    self:setCenter(0.5,0.5)
    self:add()
    self:setCollideRect(7, 50, 70,  20)
    self:playAnimation()
    self:setTag(TAGS.Ship)
    cosmoX = 0
    cosmoY = 0
end

function Ship:collisionResponse(other)
    return "overlap"
end

function Ship:update()
    self:updateAnimation()
  
    shipLine = pd.geometry.distanceToPoint(self.x, self.y, cosmoX, cosmoY)


    if shipLine <= 64 then
        showIntBtn = true
        
        if pd.buttonJustReleased(pd.kButtonA) then
            limamusic:stop()
            lavenmusic:stop()
            previouslevel = location

            hudShow       = false
            paused        = true
            levelNum      = 5
            gfx.sprite.removeAll()

            manager:enter(LoadingScene())
        end
    elseif shipLine > 64 then
        showIntBtn = false
    end
    cosmoSortOrder(self)
end




