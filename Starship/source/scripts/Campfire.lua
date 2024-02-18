local pd <const> = playdate
local gfx <const> = playdate.graphics

class('Campfire').extends(AnimatedSprite)

function Campfire:init(x, y, entity)
    self.fields = entity.fields

    campfireImageTable = gfx.imagetable.new("assets/images/campfire-table-48-48")

    Campfire.super.init(self, campfireImageTable)
    self:addState("idle", 1, 4, { tickStep = 7 })
    self.currentState = "idle"
    self:moveTo(x + 24, y + 24)
    self:setCenter(0.5, 0.5)
    self:add()
    -- self:setCollideRect(7, 50, 70, 20)
    self:playAnimation()
    self:setZIndex(self.y + 16)
    cosmoX = 0
    cosmoY = 0
    CampfireSmoke(self.x, self.y)
    CampMask()
end

function Campfire:collisionResponse(other)
    return "overlap"
end

function Campfire:update()
    self:updateAnimation()
    self:setZIndex(self.y)
    campLine = pd.geometry.distanceToPoint(self.x, self.y, cosmoX, cosmoY)

    if enterCamp == true then
        if campLine <= 24 then
            showIntBtn = true

            if pd.buttonJustReleased(pd.kButtonA) then
                limamusic:stop()
                lavenmusic:stop()
                previouslevel = location
                returnRoom    = levelName
                returnRoomNumber = roomNumber
                hudShow       = false
                paused        = true
                levelNum      = 7
                gfx.sprite.removeAll()
                returnX = cosmoX
                returnY = cosmoY
                manager:enter(LoadingScene())
            end
        elseif campLine >= 25 then
            showIntBtn = false
        end
    else
        if pd.buttonJustReleased(pd.kButtonA) then
            showCampMenu = true
       
        end
    end
    -- cosmoSortOrder(self)
end

class('CampfireSmoke').extends(AnimatedSprite)

function CampfireSmoke:init(x, y)
    campfiresmokeImageTable = gfx.imagetable.new("assets/images/Smoke-table-64-96")

    CampfireSmoke.super.init(self, campfiresmokeImageTable)
    self:addState("idle", 1, 24, { tickStep = 6 })
    self.currentState = "idle"

    self:moveTo(x, y - 48)
    self:setCenter(0.5, 0.5)
    self:add()
    -- self:setCollideRect(7, 50, 70, 20)
    self:playAnimation()
    self:setZIndex(810)
    cosmoX = 0
    cosmoY = 0
end

function CampfireSmoke:update()
    self:updateAnimation()
end

class('Log').extends(gfx.sprite)
function Log:init(x, y, entity)
    self.fields = entity.fields
    local logImage = gfx.image.new("assets/images/camplog")

    self:moveTo(x, y)


    self:setImage(logImage)
    self:setZIndex(self.y)
    self:setCenter(0, 0)
    self:add()
end

function Log:update()

end

class('CampMask').extends(AnimatedSprite)

function CampMask:init()
    local maskImage = gfx.imagetable.new("assets/images/campmask-table-400-240")
    CampMask.super.init(self, maskImage)
    self:addState("idle", 1, 4, { tickStep = 9 })
    self.currentState = "idle"



    self:moveTo(0, 0)


    self:setZIndex(800)
    self:setCenter(0, 0)
    if enterCamp == false then
        self:playAnimation()
        self:add()
    end
end

function CampMask:update()
    self:updateAnimation()
end
