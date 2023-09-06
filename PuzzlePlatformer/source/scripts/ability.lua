local pd <const> = playdate
local gfx <const> = pd.graphics

class('Ability').extends(AnimatedSprite)

function Ability:init(x, y, entity)
    self.fields = entity.fields
    if self.fields.pickedUp then
        return
    end

    self.abilityName = self.fields.ability
   
    if self.abilityName == "DoubleJump" then
        imagetable = gfx.imagetable.new("images/DoubleJump-table-16-16")
    elseif self.abilityName =="Dash" then
        imagetable = gfx.imagetable.new("images/Dash-table-16-16")
    elseif self.abilityName =="CeilingCling" then
        imagetable = gfx.imagetable.new("images/Key-table-16-16")
    elseif self.abilityName =="Key" then
        imagetable = gfx.imagetable.new("images/Key-table-16-16")
    else
        imagetable = gfx.imagetable.new("images/interactUp-table-16-16")
    end
    Ability.super.init(self, imagetable)
    self:addState("idle", 1, 4, {tickStep = 4})
    self.currentState = "idle"

    self:setImage(image)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
    
    self:playAnimation()


    self:setZIndex(Z_INDEXES.Pickup)
    self:setTag(TAGS.Pickup)
    self:setCollideRect(0, 0, self:getSize())
    self:interactable()

end 


function Ability:update()
    self:updateAnimation()
    
    
    
end

function Ability:interactable()
    if self.abilityName == "TextBox" then
        
        self:setCenter(0, 0)
        self:moveTo(self.x, self.y-15)
        self:setCollideRect(0, 20, 12, 12)
        self:add()
    end 
end

function Ability:pickUp(player)
    if self.abilityName == "DoubleJump" then
        player.doubleJumpAbility = true
        pdDialogue.say("GOT DOUBLE JUMP! NOW YOU CAN GET THE KEY!", { width = self.fields.Width, height = self.fields.Height, x = 0, y = 160, padding = 10 })
        self:remove()
    elseif self.abilityName == "Dash" then
        player.dashAbility = true
        pdDialogue.say("GOT DASH! NOW YOU MOVE FAST FOR SHORT SPRINTS!", { width = self.fields.Width, height = self.fields.Height, x = 0, y = 160, padding = 10 })
        self:remove()
    elseif self.abilityName == "CeilingCling" then
        player.ceilingCling = true
        pdDialogue.say("GOT Ceiling Cling! NOW YOU can hang upside down!", { width = self.fields.Width, height = self.fields.Height, x = 0, y = 160, padding = 10 })
        self:remove()
    elseif self.abilityName == "Key" then
        player.hasKey = true
        HUD:incrementKeys()
        self:remove()
    self.fields.pickedUp = true
    self:remove()
    end
    if self.abilityName == "TextBox" then
        

            if  pd.buttonIsPressed(pd.kButtonUp) then
        
            pdDialogue.say(self.fields.Copy, { width = self.fields.Width - 20, height = self.fields.Height - 20, x = 10, y = 170, padding = 10  })
          
        end

      
    end
end
