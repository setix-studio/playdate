local pd <const> = playdate
local gfx <const> = playdate.graphics


local shipgridview = pd.ui.gridview.new(128, 32)


class('ShipInteriorScene').extends(Room)

function ShipInteriorScene:init()
    gfx.sprite.removeAll()
    gfx.setDrawOffset(0, 0)
    returnRoomNumber = 1
    activeArea = "bed"
    ShipInteriorImageScene()
end

function ShipInteriorScene:update()
    if activeArea == "cockpit" then
        if pd.buttonJustPressed(pd.kButtonA) then
            if pd.isCrankDocked() == false then
                hudShow = false
                paused  = true
                gfx.sprite.removeAll()
                gfx.setDrawOffset(0, 0)

                ShipTakeoff()
                levelTimer = pd.timer.performAfterDelay(3000, function()
                    levelNum = 0

                    manager:enter(LoadingScene())
                end)
            end
        end
    end

    if activeArea == "bed" then
        if pd.buttonJustPressed(pd.kButtonA) and textboxActive == false then
            saveData = true
            saveGameData()

            gfx.setColor(gfx.kColorWhite)

            textboxActive = true


            pdDialogue.say("Game saved.",
                {
                    width = 360,
                    height = 60,
                    x = 20,
                    y = 160,
                    padding = 10,
                    nineSlice = textbg,
                    onClose = function()
                        textboxTimer = pd.timer.performAfterDelay(2000, function()
                            textboxActive = false
                        end)
                    end
                })
        end
    end

    if pd.buttonJustPressed(pd.kButtonB) then
        manager:enter(levelScene)
    end
end

class('ShipInteriorImageScene').extends(gfx.sprite)
function ShipInteriorImageScene:init()
    local shipIntImage = gfx.image.new("assets/images/shipIntImage")

    self:setImage(shipIntImage)
    self.x = 0
    self.y = 0
    self.speed = 400
    self:moveTo(self.x, self.y)

    self:setCenter(0, 0)
    self:add()
    self:setZIndex(0)
end

function ShipInteriorImageScene:update()
    if pd.buttonJustPressed(pd.kButtonRight) then
        self.x -= self.speed
    elseif pd.buttonJustPressed(pd.kButtonLeft) then
        self.x += self.speed
    end
    if self.x == 0 then
        activeArea = "bed"
    elseif self.x == -400 then
        activeArea = "kitchen"
    elseif self.x == -800 then
        activeArea = "cockpit"
    elseif self.x <= -800 then
        self.x = -800
    elseif self.x >= 0 then
        self.x = 0
    end

    areaX = self.x
    areaY = self.y
    self:moveTo(areaX, areaY)
    print(areaX .. ", " .. areaY)
end

class('ShipTakeoff').extends(AnimatedSprite)

function ShipTakeoff:init(x, y)
    local shipImageTable = gfx.imagetable.new("assets/images/shiptakeoff-table-400-240")
    Ship.super.init(self, shipImageTable)
    self:addState("idle", 1, 15, { tickStep = 12 })
    self.currentState = "idle"


    self:setZIndex(1000)

    self:moveTo(0, 0)

    self:setCenter(0, 0)
    self:add()
    self:playAnimation()
    self:setTag(TAGS.Ship)
end

function ShipTakeoff:update()
    self:updateAnimation()
    shipTimer = pd.timer.performAfterDelay(3000, function()
        self:remove()
    end)
end
