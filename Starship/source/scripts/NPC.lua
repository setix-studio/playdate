local pd <const> = playdate
local gfx <const> = playdate.graphics


class('NPC').extends(AnimatedSprite)

function NPC:init(x, y, entity)
    self.fields = entity.fields
    npcImageTable = gfx.imagetable.new("assets/images/npc-table-32-32")
    self.QuestID = self.fields.QuestID
    NPC.super.init(self, npcImageTable)
    self:addState("idle", 1, 1)
    self.currentState = "idle"
    self:setZIndex(10)



    questTurnin = false
    self:setCenter(0.5, 0.5)
    self:moveTo(x, y)
    self:add()
    self:setCollideRect(12, 21, 7, 10)
    self:playAnimation()
    self:setTag(TAGS.NPC)
    cosmoX = 0
    cosmoY = 0

    queststartSFX = pd.sound.fileplayer.new('assets/sounds/queststart')

    for i in pairs(quests) do
        quests[i]["introCopy"] = quests[i]["introCopy"]
        quests[i]["inProgressCopy"] = quests[i]["inProgressCopy"]
    end
end

function NPC:collisionResponse(other)
    return "overlap"
end

function NPC:update()
    self:updateAnimation()
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
    cosmoSortOrder(self)
end

function NPCText(self)
    showIntBtn = false
    gfx.setBackgroundColor(gfx.kColorWhite)

    textboxActive = true

    hudShow = false

    for i in pairs(quests) do
        if self.QuestID == quests[i]["ID"] then
            if quests[i]["intro"] == false then
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
    for j in pairs(items) do
        if quests[i]["gatherItem"] == items[j]["name"] then
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

    if quests[i]["complete"] == true then
        if quests[i]["rewardReceived"] == false then
            if quests[i]["recipeReceived"] == false then
                Recipes:addRecipe(quests[i]["reward"])
                quests[i]["recipeReceived"] = true
            end
            Items:addItem(quests[i]["reward"], quests[i]["rewardQty"])
            quests[i]["rewardReceived"] = true
        end
    end
end