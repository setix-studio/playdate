-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"
import "CoreLibs/nineslice"
-- Libraries
import "scripts/libraries/AnimatedSprite"


--scripts
import "scripts/intro"
import "scripts/saveLoadData"
import "scripts/HomeScene"






import "scripts/sceneManager"


local pd <const> = playdate
local gfx <const> = playdate.graphics
font1 = gfx.font.new("font/Sasser-Slab")
font2 = gfx.font.new("font/Sasser-Slab-Bold")
loadGameData()
manager = Manager()
manager:hook()
manager:enter(IntroScene())


menuImage = gfx.image.new("assets/images/menu")
pd.setMenuImage(menuImage)
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    manager:emit('update')

    -- playdate.drawFPS(0, 220) -- FPS widget
end

