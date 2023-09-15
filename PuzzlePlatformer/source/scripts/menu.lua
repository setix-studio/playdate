local pd <const> = playdate
local gfx <const> = pd.graphics

class('Menu').extends(gfx.sprite)

function Menu:init()
    menuImage = gfx.image.new("images/menu")
    self:setImage(menuImage)

    pd.setMenuImage(menuImage)
    
    doubleJumpImage = gfx.imagetable.new("images/DoubleJump-table-16-16")
    dashImage = gfx.imagetable.new("images/Dash-table-16-16")
    ceilingClingImage = gfx.imagetable.new("images/CeilingCling-table-16-16")

    
    self.currentState = "idle"
    self:setImage(image)
    self:setCenter(0, 0)
   
    self:add()

end

function Menu:update()
    if  doubleJumpAbility == true then
        self:add(doubleJumpImage)
    end
end