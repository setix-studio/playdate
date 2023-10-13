local pd <const> = playdate
local gfx <const> = playdate.graphics


class('IntroScene').extends(Room)

function IntroScene:init()
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)
    IntroSceneImage()
    
   
    sfxLogo = pd.sound.fileplayer.new('assets/sounds/setixstudio')

    logoTimer = pd.timer.performAfterDelay(2000, function()
        sfxLogo:play(1)
    end)

    slideAmount = 0

    spawnTimer = pd.timer.performAfterDelay(3500, function()


        
        manager:push(HomeScene())
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
