-- CoreLibs
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"


-- Libraries
import "scripts/libraries/AnimatedSprite"
import "scripts/libraries/LDtk"

-- Game
import "scripts/player"
import "scripts/gameScene"
import "scripts/ability"
import "scripts/spike"
import "scripts/spikeball"
import "scripts/candle"
import "scripts/camera"
import "scripts/door"
import "scripts/movingplatform"
import "scripts/pdDialogue"
-- import "scripts/hud"

local pd <const> = playdate
local gfx <const> = playdate.graphics
 font1 = gfx.font.new("assets/fonts/Krull")
 font2 = gfx.font.new("assets/fonts/AmaticSC-Regular")
 font3 = gfx.font.new("assets/fonts/TulpenOne-Regular")
GameScene()
pdDialogue.setup({
    font=font1,
    
    onClose = function()
        directionText = "✛"
    end
})
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    pdDialogue.update()
    

end

