local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Building').extends(AnimatedSprite)

function Building:init(x, y, entity)
    self.fields = entity.fields

    self.buildingType = self.fields.buildingtype
    buildingImageTable = gfx.imagetable.new("assets/images/building-table-96-72")


    Building.super.init(self, buildingImageTable)


    self:addState("shop", 1, 4, { tickStep = 4 })
    self:addState("hut", 5, 5)
    if self.buildingType == "Shop" then
        self.currentState = "shop"
        self:setTag(TAGS.Shop)

        self:setCollideRect(7, 55, 73, 5)
    elseif self.buildingType == "Hut" then
        self.currentState = "hut"
        self:setTag(TAGS.Building)

        self:setCollideRect(16, 55, 57, 5)
    end
    self:setZIndex(10)
    self:setCenter(0.5, 0.5)
    self:moveTo(x, y)
    self:add()
    self:playAnimation()
    newX = 0
    newY = 0    
    textboxActive = false
    if self.buildingType ~= "Shop" then
    doorWay(self.x, self.y)
    end
    doorWayName = "Interior_1"
end

function Building:collisionResponse(other)
    return "overlap"
end

function Building:update()
    cosmoSortOrder(self)
    self:updateAnimation()
    if self.buildingType == "Shop" then
        shopSightLine = pd.geometry.distanceToPoint(self.x - 208, self.y - 92, newX, newY)
        if shopSightLine <= 32 then
            if textboxActive == false then
                showIntBtn = true

                if pd.buttonJustReleased(pd.kButtonA) then
                    if textboxActive == true then
                        return
                    else
                        ShopText()
                    end
                end
            else
                showIntBtn = false
            end
        else
            showIntBtn = false
        end
    end
end

function ShopText()
    showIntBtn = false
    gfx.setBackgroundColor(gfx.kColorWhite)

    textboxActive = true

    hudShow = false
    pdDialogue.say("Hello and welcome to Lima! Our shop will be open soon!",
        {
            width = 360,
            height = 60,
            x = -cameraX + 20,
            y = -cameraY + 160,
            padding = 10,
            nineSlice = textbg,
            onClose = function()
                textboxTimer = pd.timer.performAfterDelay(1000, function()
                    textboxActive = false
                    hudShow = true
                end)
            end
        })


    -- function dialogue:onClose()
    --     textboxTimer = pd.timer.performAfterDelay(1000, function()
    --         textboxActive = false
    --     end)
    --     playdate.inputHandlers.pop()
    -- end
end

class('doorWay').extends(AnimatedSprite)

function doorWay:init(x, y)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
    self:setTag(TAGS.Door)

    self:setCollideRect(-16, 16, 16, 16)

end

function doorWay:collisionResponse(other)
    return "overlap"
end
