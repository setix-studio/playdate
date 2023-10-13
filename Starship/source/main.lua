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
import "scripts/libraries/LDtk"

--scripts

import "scripts/items"


import "scripts/PauseScene"

import "scripts/HomeScene"
import "scripts/loading"
import "scripts/intro"

import "scripts/player"
import "scripts/Lima"
import "scripts/laven"
import "scripts/gameScene"
import "scripts/enemy"
import "scripts/enemySpawner"
import "scripts/chef"
-- import "scripts/saveLoadData"
import "scripts/planet"
import "scripts/spike"
import "scripts/spikeball"
import "scripts/camera"
import "scripts/door"
import "scripts/movingplatform"
import "scripts/pdDialogue"
import "scripts/underscore"
import "scripts/parallax"
import "scripts/ship"
import "scripts/gameOverScene"

import "scripts/sceneManager"

__ = Underscore:new() -- double underscore
local pd <const> = playdate
local gfx <const> = playdate.graphics
font1 = gfx.font.new("font/russo")
font2 = gfx.font.new("font/redhat-bold")

manager = Manager()
manager:hook()
manager:enter(IntroScene())


--audio
spacemusic = pd.sound.fileplayer.new('assets/sounds/space1')
limamusic = pd.sound.fileplayer.new('assets/sounds/lima')
lavenmusic = pd.sound.fileplayer.new('assets/sounds/laven')


pdDialogue.setup({
    font = font1,

    onClose = function()
        directionText = "✛"
    end
})
-- loadGameData()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()

    pdDialogue.update()
    --playdate.drawFPS(0, 0) -- FPS widget

    manager:emit('update')
end
