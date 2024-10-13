local pd <const> = playdate
local gfx <const> = playdate.graphics


class('NPC').extends(AnimatedSprite)

function NPC:init(x, y, entity)
    self.fields = entity.fields
    npcImageTable = gfx.imagetable.new("assets/images/npc-table-32-48")
    self.QuestID = self.fields.QuestID
    self.NPCImage = self.fields.NPCImage
    NPC.super.init(self, npcImageTable)
    self:addState("idle", self.NPCImage + 2, self.NPCImage + 2)
    self:addState("questturnin", self.NPCImage + 1, self.NPCImage + 1)
    self:addState("quest", self.NPCImage, self.NPCImage)
    if self.QuestID == 8 then
        if quests[7]["complete"] == false then
        --nothing
        elseif quests[7]["complete"] == true then
            for i in pairs(quests) do
                for j in pairs(items) do
                    if self.QuestID == quests[i]["ID"] then
                        
                        
                        if items[j]["quantity"] >= quests[i]["quantity"] then
                            self.currentState = "questturnin"
                        elseif quests[i]["intro"] == false then
                            self.currentState = "quest"
                        elseif quests[i]["complete"] == true then
                            self.currentState = "idle"
                        
                    end
                end
            end
            end
        self:setZIndex(self.y + 2)  
        self:playAnimation()
        self:setTag(TAGS.NPC)
        self:add()
        self:moveTo(x, y)
        self:setCenter(0.5, 0.5)
    self:setCollideRect(12, 21, 7, 10)

        end
    elseif self.QuestID == 9 then
        if quests[8]["complete"] == false then
        --nothing
        elseif quests[8]["complete"] == true then
            for i in pairs(quests) do
                for j in pairs(items) do
                    if self.QuestID == quests[i]["ID"] then
                        
                        
                        if items[j]["quantity"] >= quests[i]["quantity"] then
                            self.currentState = "questturnin"
                        elseif quests[i]["intro"] == false then
                            self.currentState = "quest"
                        elseif quests[i]["complete"] == true then
                            self.currentState = "idle"
                        
                    end
                end
            end
            end

        self:setZIndex(self.y + 2)  
        self:playAnimation()
        self:setTag(TAGS.NPC)
        self:add()
        self:moveTo(x, y)
        self:setCenter(0.5, 0.5)
    self:setCollideRect(12, 21, 7, 10)

        end
    elseif self.QuestID == 7 then
        if quests[4]["complete"] == false then
        --nothing
        elseif quests[4]["complete"] == true then
            for i in pairs(quests) do
                for j in pairs(items) do
                    if self.QuestID == quests[i]["ID"] then
                        
                        
                        if items[j]["quantity"] >= quests[i]["quantity"] then
                            self.currentState = "questturnin"
                        elseif quests[i]["intro"] == false then
                            self.currentState = "quest"
                        elseif quests[i]["complete"] == true then
                            self.currentState = "idle"
                        
                    end
                end
            end
            end
           
        self:setZIndex(self.y + 2)  
        self:playAnimation()
        self:setTag(TAGS.NPC)
        self:add()
        self:moveTo(x, y)
        self:setCenter(0.5, 0.5)
    self:setCollideRect(12, 21, 7, 10)

        end
    else
        for i in pairs(quests) do
            for j in pairs(items) do
                if self.QuestID == quests[i]["ID"] then
                    
                    
                    if items[j]["quantity"] >= quests[i]["quantity"] then
                        self.currentState = "questturnin"
                    elseif quests[i]["intro"] == false then
                        self.currentState = "quest"
                    elseif quests[i]["complete"] == true then
                        self.currentState = "idle"
                    
                end
            end
        end
        end
       

        self:setZIndex(self.y + 2)
        self:playAnimation()
        self:setTag(TAGS.NPC)
        self:add()
        self:moveTo(x, y)
        self:setCenter(0.5, 0.5)
    self:setCollideRect(12, 21, 7, 10)
    end
    
  
    questTurnin = false
  
    cosmoX = 0
    cosmoY = 0
   
    
    queststartSFX = pd.sound.fileplayer.new('assets/sounds/queststart')
end

function NPC:collisionResponse(other)
    return "overlap"
end

function NPC:update()
    self:updateAnimation()

      self:setZIndex(self.y + 2)
      
      
    npcLine = pd.geometry.distanceToPoint(self.x, self.y, cosmoX, cosmoY)

    if npcLine <= 32 then
        if textboxActive == false then
           
            showIntBtn = true

            if pd.buttonJustReleased(pd.kButtonA) then
                if textboxActive == true then
                    return
                else
                    NPCText(self)
                end
            end
        elseif npcLine >= 33 then
            showIntBtn = false
        end
    else
        showIntBtn = false
    end
end

function NPCText(self)
    showIntBtn = false
    gfx.setBackgroundColor(gfx.kColorWhite)

    textboxActive = true

    hudShow = false

    for i in pairs(quests) do
     
        if self.QuestID == quests[i]["ID"] then
            if quests[i]["intro"] == false then
                self:changeState("idle")
                questStart(self, i)
                
            elseif quests[i]["inProgress"] == true and quests[i]["complete"] == false then

               
                questInProgress(self, i)
            elseif quests[i]["complete"] == true then
                pdDialogue.say(quests[i]["completeCopy"],
                    {
                        width = 360,
                        height = 60,
                        x = -cameraX + 20,
                        y = -cameraY + 160,
                        padding = 10,
                        nineSlice = textbg,
                        onClose = function()
                            textboxTimer = pd.timer.performAfterDelay(1000, function()
                                textboxActive = false
                                hudShow = true
                                print("Quest Complete")
                            end)
                        end
                    })
            end
        end
    end
end




function questStart(self, i)
    quests[i]["found"] = true
    quests[i]["intro"] = true
    quests[i]["inProgress"] = true
  
    
      
    pdDialogue.say(quests[i]["introCopy"],
        {
            width = 360,
            height = 60,
            x = -cameraX + 20,
            y = -cameraY + 160,
            padding = 10,
            nineSlice = textbg,
            onClose = function()
                textboxTimer = pd.timer.performAfterDelay(1000, function()
                    textboxActive = false
                    hudShow = true
                    queststartSFX:play(1)
                    print("Quest Started")
                end)
            end
        })
end

function questInProgress(self, i)
    
    if quests[i]["type"] == "gather" then
        
        for j in pairs(items) do
            if quests[i]["gatherItemID"] == items[j]["itemID"] then
                if items[j]["quantity"] >= quests[i]["quantity"] then
                    pdDialogue.say(quests[i]["turninCopy"],
                        {
                            width = 360,
                            height = 60,
                            x = -cameraX + 20,
                            y = -cameraY + 160,
                            padding = 10,
                            nineSlice = textbg,
                            onClose = function()
                                textboxTimer = pd.timer.performAfterDelay(1000, function()
                                    textboxActive = false
                                    hudShow = true
                                end)
                            end
                        })
                    items[j]["quantity"] = items[j]["quantity"] - quests[i]["quantity"]
                    print("Quest Complete")
                    quests[i]["complete"] = true
                    quests[i]["inProgress"] = false
                else
                    pdDialogue.say(quests[i]["inProgressCopy"],
                        {
                            width = 360,
                            height = 60,
                            x = -cameraX + 20,
                            y = -cameraY + 160,
                            padding = 10,
                            nineSlice = textbg,
                            onClose = function()
                                textboxTimer = pd.timer.performAfterDelay(1000, function()
                                    textboxActive = false
                                    hudShow = true
                                    print("Quest In Progress")
                                end)
                            end
                        })
                end
            end
        end
    elseif quests[i]["type"] == "craft" then
       
        for j in pairs(recipes) do

            
            if quests[i]["gatherItem"] == recipes[j]["name"] then
                if recipes[j]["quantity"] >= quests[i]["quantity"] then
                    pdDialogue.say(quests[i]["turninCopy"],
                        {
                            width = 360,
                            height = 60,
                            x = -cameraX + 20,
                            y = -cameraY + 160,
                            padding = 10,
                            nineSlice = textbg,
                            onClose = function()
                                textboxTimer = pd.timer.performAfterDelay(1000, function()
                                    textboxActive = false
                                    hudShow = true
                                end)
                            end
                        })
                    recipes[j]["quantity"] = recipes[j]["quantity"] - quests[i]["quantity"]
                    print("Quest Complete")
                    quests[i]["complete"] = true
                    quests[i]["inProgress"] = false
                else
                    pdDialogue.say(quests[i]["inProgressCopy"],
                        {
                            width = 360,
                            height = 60,
                            x = -cameraX + 20,
                            y = -cameraY + 160,
                            padding = 10,
                            nineSlice = textbg,
                            onClose = function()
                                textboxTimer = pd.timer.performAfterDelay(1000, function()
                                    textboxActive = false
                                    hudShow = true
                                    print("Quest In Progress")
                                end)
                            end
                        })
                end
            end
        end
        
    end
    if quests[i]["complete"] == true then
        if quests[i]["rewardReceived"] == false then
            if quests[i]["recipeReceived"] == false then
                Recipes:addRecipe(quests[i]["reward"])
                quests[i]["recipeReceived"] = true
                self:changeState("idle")
            end
            if quests[i]["type"] == "gather" then
                Items:addItem(quests[i]["reward"], quests[i]["rewardQty"])
            elseif quests[i]["type"] == "craft" then
                credits = credits + quests[i]["rewardCredits"]
            end
            quests[i]["rewardReceived"] = true
            self:changeState("idle")
        
        end
    end


    
    
end
