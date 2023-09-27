local pd <const> = playdate
local gfx <const> = playdate.graphics


class('IntroScene').extends(Room)

function IntroScene:init()
    IntroSceneImage()
    music:stop()
    sfxLogo = pd.sound.fileplayer.new('assets/sounds/setixstudio')

    logoTimer = pd.timer.performAfterDelay(1700, function()
        sfxLogo:play(1)
    end)

    spawnTimer = pd.timer.performAfterDelay(4000, function()
        manager:push(HomeScene())
    end)
end

function IntroScene:update()

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
