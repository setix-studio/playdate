-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"


-- Libraries
import "scripts/libraries/AnimatedSprite"

--scripts
import "scripts/player"
import "scripts/gameScene"
import "scripts/sky"
import "scripts/cloud"

local pd <const> = playdate
local gfx <const> = playdate.graphics


GameScene()

function playdate.update()
	gfx.sprite.update()
    pd.timer.updateTimers()
	playdate.drawFPS(0,0) -- FPS widget
end