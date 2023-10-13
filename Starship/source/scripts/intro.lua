local pd <const> = playdate
local gfx <const> = playdate.graphics


class('IntroScene').extends(Room)

function IntroScene:init()
    gfx.sprite.removeAll()

    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)
    IntroSceneImage()
    sfxLogo = pd.sound.fileplayer.new('assets/sounds/setixstudio')

    logoTimer = pd.timer.performAfterDelay(2000, function()
        sfxLogo:play(1)
        ShipTakeoff()
    end)




    shipTimer = pd.timer.performAfterDelay(4000, function()
        manager:enter(LoadingScene())
    end)
end

function IntroScene:update()
    gfx.setBackgroundColor(playdate.graphics.kColorBlack)
end

class('IntroSceneImage').extends(gfx.sprite)
function IntroSceneImage:init(x, y)
    gfx.setImageDrawMode(gfx.kDrawModeNXOR)
    local loadingImage = gfx.image.new("assets/images/setixstudio")

    self:setImage(loadingImage)
    self.speed = 3
    self.y = -160
    self:moveTo(self.x, self.y)
    self:setCenter(0, 0)
    self:add()
end

function IntroSceneImage:update()
    self.y += self.speed
    if self.y >= 0 then
        self.y = 0
    end


    self:moveTo(self.x, self.y)
end
