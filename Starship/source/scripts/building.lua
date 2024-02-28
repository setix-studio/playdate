local pd <const> = playdate
local gfx <const> = playdate.graphics


class('Building').extends(AnimatedSprite)

function Building:init(x, y, entity)
    self.fields = entity.fields

    self.buildingType = self.fields.buildingtype
    buildingImageTable = gfx.imagetable.new("assets/images/building-table-128-92")


    Building.super.init(self, buildingImageTable)


    self:addState("shop", 1, 4, { tickStep = 9 })
    self:addState("hut", 5,5)
    if self.buildingType == "Shop" then
        self.currentState = "shop"
        self:setTag(TAGS.Shop)

        self:setCollideRect(14, 64, 62, 16)
    elseif self.buildingType == "Hut" then
        self.currentState = "hut"
        self:setTag(TAGS.Building)

        self:setCollideRect(14, 64, 74, 16)
    end
    self:setZIndex(self.y + 10)
   
    self:setCenter(0.5, 0.5)
    self:moveTo(x, y)
    self:add()
    self:playAnimation()
    newX = 0
    newY = 0    
    textboxActive = false
    if self.buildingType ~= "Shop" then --Code to enter buidlings
    doorWay(self.x, self.y)
    end
    doorWayName = "Interior_1"
end

function Building:collisionResponse(other)
    return "overlap"
end

function Building:update()
    -- cosmoSortOrder(self)
    self:updateAnimation()
    self:setZIndex(self.y + 10)
    if intDoor == true then
        limamusic:stop()
            lavenmusic:stop()
            previouslevel = location

            hudShow       = false
            paused        = true
            levelNum      = 6
            returnX = cosmoX
            returnY = cosmoY + 16
            gfx.sprite.removeAll()

            manager:enter(LoadingScene())

            intDoor = false
    end
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
    shopMenuShow = false
    if quests[1].complete == false then
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
    else
        pdDialogue.say("Welcome Cosmo! How can I help ya?",
        {
            width = 360,
            height = 60,
            x = -cameraX + 20,
            y = -cameraY + 160,
            padding = 10,
            nineSlice = textbg,
            onClose = function()
                textboxTimer = pd.timer.performAfterDelay(1000, function()
                    textboxActive = true
                    hudShow = false
                    shopMenuShow = true
                    limamusic:setVolume(0.2)
                    lavenmusic:setVolume(0.2)
                    paused = true
    gfx.setDrawOffset(0, 0)
    shopImageShow = true
  
                    manager:push(ShopScene())
                end)
            end
        })
    end
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
    self:setTag(TAGS.intDoor)

    self:setCollideRect(-40, 28, 16, 12)

end

function doorWay:collisionResponse(other)
    return "overlap"
end
