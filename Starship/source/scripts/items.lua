local pd <const> = playdate
local gfx <const> = pd.graphics

class('Items').extends(AnimatedSprite)

function Items:init(x, y, entity)
    self.fields = entity.fields

    if self.fields.pickedUp then
        return
    end

    self.itemName = self.fields.item


    if self.itemName == "MeatyChunks" then
        itemChance = 30
        imagetable = gfx.imagetable.new("assets/images/meatstalk-table-32-32")
        self:setCollideRect(6, 8, 17, 17)
        self.itemPName = "Meaty Chunks"
        self.enemyName = "Meaty"
    elseif self.itemName == "Berries" then
        itemChance = 20
        imagetable = gfx.imagetable.new("assets/images/bush-table-32-32")
        self:setCollideRect(6, 11, 20, 10)
        self.itemPName = "Berries"
        self.enemyName = "Bush"
    elseif self.itemName == "Tomas" then
        itemChance = 20
        imagetable = gfx.imagetable.new("assets/images/tomas-table-32-32")
        self:setCollideRect(4, 4, 26, 26)
        self.itemPName = "Tomas"
        self.enemyName = "Timid Toma"
    elseif self.itemName == "Brusselfly" then
        itemChance = 20
        imagetable = gfx.imagetable.new("assets/images/brusselfly-table-32-32")
        self:setCollideRect(6, 11, 20, 10)
        self.itemPName = "Brussels"
        self.enemyName = "Brusselfly"
    elseif self.itemName == "CoolShroom" then
        itemChance = 20
        imagetable = gfx.imagetable.new("assets/images/shrooma-table-32-32")
        self:setCollideRect(8, 8, 16, 16)
        self.itemPName = "Shroomas"
        self.enemyName = "Cool Shroom"
    elseif self.itemName == "Nuts" then
        itemChance = 20
        imagetable = gfx.imagetable.new("assets/images/legume-table-32-32")
        self:setCollideRect(9, 5, 13, 20)
        self.itemPName = "Nuts"
        self.enemyName = "Loony Legume"
    elseif self.itemName == "Nanners" then
        itemChance = 20
        imagetable = gfx.imagetable.new("assets/images/banana-table-32-32")
        self:setCollideRect(10, 5, 11, 20)
        self.itemPName = "Nanners"
        self.enemyName = "Banana Bro"
    elseif self.itemName == "BigChop" then
        itemChance = 20
        imagetable = gfx.imagetable.new("assets/images/bigchop-table-32-32")
        self:setCollideRect(10, 5, 11, 20)
        self.itemPName = "Big Chop"
        self.enemyName = "Big Chop"
    else
        imagetable = gfx.imagetable.new("images/interactUp-table-16-16")
    end
    self.chance = math.random(0, 100)

    if itemChance == nil then
        itemChance = 50
    end
    if self.chance <= itemChance then
        self.fields.Hidden = true
    end
    Items.super.init(self, imagetable)
    self:addState("idle", 1, 4, { tickStep = math.random(8, 12) })
    self.currentState = "idle"

    self:setImage(image)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self:playAnimation()


    self:setZIndex(self.y)
    self:setTag(TAGS.Pickup)


    self.enemySpeedX = 0
    self.enemySpeedY = 0

    self:enemywaitCounter()


    hudItemTable = {}
end

function Items:collisionResponse(other)
    local tag = other:getTag()
    if tag == TAGS.Pickup or tag == TAGS.Hazard or tag == TAGS.Prop or tag == TAGS.Laser or tag == TAGS.Door then
        return gfx.sprite.kCollisionTypeOverlap
    end
    return gfx.sprite.kCollisionTypeSlide
end

function Items:enemywaitCounter()
    local randomTime = math.random(100, 1000)

    enemyWait = pd.timer.performAfterDelay(randomTime, function()
        self.enemySpeedX = 0
        self.enemySpeedY = 0
        self:enemywalkCounter()
    end)
end

function Items:enemywalkCounter()
    local randomTime = math.random(100, 1000)


    enemyWalk = pd.timer.performAfterDelay(randomTime, function()
        self.enemySpeedX = math.random(-1, 1)
        self.enemySpeedY = math.random(-1, 1)
        self:enemywaitCounter()
    end)
end

function Items:update()
    self:setZIndex(self.y)

    if paused == false then
        self:updateAnimation()
        self:handleMovementAndCollisions()

        enemySightLine = pd.geometry.distanceToPoint(self.x, self.y, cosmoX, cosmoY)

        if enemySightLine <= 72 then
            enemySpeed = 1
            if cosmoX >= self.x and cosmoY >= self.y then
                self.x += enemySpeed
                self.y += enemySpeed
            elseif cosmoX >= self.x and cosmoY <= self.y then
                self.x += enemySpeed
                self.y -= enemySpeed
            elseif cosmoX <= self.x and cosmoY >= self.y then
                self.x -= enemySpeed
                self.y += enemySpeed

                self:setImageFlip(gfx.kImageFlippedX)
            elseif cosmoX <= self.x and cosmoY <= self.y then
                self.x -= enemySpeed
                self.y -= enemySpeed
                self:setImageFlip(gfx.kImageFlippedX)
            end
        else
            if self.touchingWall == true or self.touchingCeiling == true or self.touchingGround == true then
                self.x -= self.enemySpeedX / 4
                self.y -= self.enemySpeedY / 4
            else
                self.x += self.enemySpeedX / 4
                self.y += self.enemySpeedY / 4
            end
        end
        self:moveTo(self.x, self.y)
    end
end

function Items:handleMovementAndCollisions()
    local _, _, collisions, length = self:moveWithCollisions(self.x + self.enemySpeedX, self.y + self.enemySpeedY)

    self.touchingGround = false
    self.touchingCeiling = false
    self.touchingWall = false

    for i = 1, length do
        local collision = collisions[i]
        local collisionType = collision.type
        local collisionObject = collision.other
        local collisionTag = collisionObject:getTag()

        if collisionType == gfx.sprite.kCollisionTypeSlide then
            if collision.normal.y == -1 then
                self.touchingGround = true
            elseif collision.normal.y == 1 then
                self.touchingCeiling = true
            end

            if collision.normal.x ~= 0 then
                self.touchingWall = true
            end
        end
    end
end

function Items:pickUp()
    limamusic:stop()
    lavenmusic:stop()
    paused = true
    BattleFadeImage()
    BattleTimer()
    enemyName = self.enemyName
    enemyItem = self.itemPName
    self.fields.pickedUp = true

    self:remove()
end

function Items:checkQuantity()
    for i in pairs(items) do
        itemName = items[i]["name"]
        totalItems = items[i]["quantity"]
    end
end

function invItemsQty()
    if recipelistInv:getSelectedRow() == 1 or recipelistInv:getSelectedRow() == #recipes then
        invItems = ""
    elseif recipelistInv:getSelectedRow() == 2 then
        invItems = items[1].quantity ..
            "\n" ..
            items[10].quantity .. "\n" .. items[27].quantity .. "\n" .. items[30].quantity .. "\n" .. items[40].quantity
    elseif recipelistInv:getSelectedRow() == 3 then
        invItems = items[2].quantity .. "\n" .. items[13].quantity .. "\n" .. items[42].quantity
    elseif recipelistInv:getSelectedRow() == 4 then
        invItems = items[3].quantity .. "\n" .. items[42].quantity
    elseif recipelistInv:getSelectedRow() == 5 then
        invItems = items[1].quantity ..
            "\n" ..
            items[10].quantity .. "\n" .. items[30].quantity .. "\n" .. items[26].quantity .. "\n" .. items[42].quantity
    elseif recipelistInv:getSelectedRow() == 6 then
        invItems = items[9].quantity ..
            "\n" ..
            items[10].quantity .. "\n" .. items[30].quantity .. "\n" .. items[26].quantity .. "\n" .. items[40].quantity
    elseif recipelistInv:getSelectedRow() == 7 then
        invItems = items[1].quantity ..
            "\n" ..
            items[10].quantity .. "\n" .. items[8].quantity .. "\n" .. items[26].quantity .. "\n" .. items[31].quantity
    elseif recipelistInv:getSelectedRow() == 8 then
        invItems = items[30].quantity ..
            "\n" .. items[31].quantity .. "\n" .. items[10].quantity .. "\n" .. items[26].quantity
    elseif recipelistInv:getSelectedRow() == 9 then
        invItems = items[27].quantity .. "\n" .. items[30].quantity .. "\n" .. items[29].quantity
    elseif recipelistInv:getSelectedRow() == 10 then
        invItems = items[8].quantity .. "\n" .. items[31].quantity .. "\n" .. items[42].quantity
    elseif recipelistInv:getSelectedRow() == 11 then
        invItems = items[1].quantity ..
            "\n" .. items[9].quantity .. "\n" .. items[8].quantity .. "\n" .. items[42].quantity
    elseif recipelistInv:getSelectedRow() == 12 then
        invItems = items[10].quantity .. "\n" .. items[29].quantity .. "\n" .. items[42].quantity
    elseif recipelistInv:getSelectedRow() == 13 then
        invItems = items[1].quantity ..
            "\n" ..
            items[8].quantity .. "\n" .. items[27].quantity .. "\n" .. items[28].quantity .. "\n" .. items[42].quantity
    elseif recipelistInv:getSelectedRow() == 14 then
        invItems = items[6].quantity .. "\n" .. items[26].quantity .. "\n" .. items[41].quantity
    elseif recipelistInv:getSelectedRow() == 15 then
        invItems = items[26].quantity .. "\n" .. items[41].quantity
    elseif recipelistInv:getSelectedRow() == 16 then
        invItems = items[11].quantity .. "\n" .. items[29].quantity .. "\n" .. items[41].quantity
    elseif recipelistInv:getSelectedRow() == 17 then
        invItems = items[12].quantity .. "\n" .. items[42].quantity
    elseif recipelistInv:getSelectedRow() == 18 then
        invItems = items[1].quantity ..
            "\n" ..
            items[15].quantity .. "\n" .. items[6].quantity .. "\n" .. items[11].quantity .. "\n" .. items[40].quantity
    elseif recipelistInv:getSelectedRow() == 19 then
        invItems = items[9].quantity .. "\n" .. items[31].quantity .. "\n" .. items[42].quantity
    end
end

function Items:addItem(enemyItem, itemQty)
    self.itemPName = enemyItem
    print(enemyItem, itemQty)
    for i in pairs(items) do
        if items[i]["quantity"] <= 0 then
            items[i]["quantity"] = 0
        end
    end
    if self.itemPName == "Meaty Chunks" then
        for i in pairs(items) do
            if items[i]["ID"] == "MEATY CHUNKS" then
                items[i]["found"] = true
                items[i]["name"] = "Meaty Chunks"
                items[i]["description"] = "Nice Chunks of meat, probably beef."
                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Flyin Fish" then
        for i in pairs(items) do
            if items[i]["ID"] == "FLYIN FISH" then
                items[i]["found"] = true
                items[i]["name"] = "Flyin Fish"
                items[i]["description"] = "Fresh from the sea.. er .. air.."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Big Chop" then
        for i in pairs(items) do
            if items[i]["ID"] == "BIG CHOP" then
                items[i]["found"] = true
                items[i]["name"] = "Big Chop"
                items[i]["description"] = "Nice hunk of meat."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Lemmies" then
        for i in pairs(items) do
            if items[i]["ID"] == "LEMMIES" then
                items[i]["found"] = true
                items[i]["name"] = "Lemmies"
                items[i]["description"] = "Small and sour."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Berries" then
        for i in pairs(items) do
            if items[i]["ID"] == "BERRIES" then
                items[i]["found"] = true
                items[i]["name"] = "Berries"
                items[i]["description"] = "Sweet and Juicy"

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Tomas" then
        for i in pairs(items) do
            if items[i]["ID"] == "TOMAS" then
                items[i]["found"] = true
                items[i]["name"] = "Tomas"
                items[i]["description"] = "Round, juicy and full of flavor."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Brussels" then
        for i in pairs(items) do
            if items[i]["ID"] == "BRUSSELS" then
                items[i]["found"] = true
                items[i]["name"] = "Brussels"
                items[i]["description"] = "Delicious once roasted."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Shroomas" then
        for i in pairs(items) do
            if items[i]["ID"] == "SHROOMAS" then
                items[i]["found"] = true
                items[i]["name"] = "Shroomas"
                items[i]["description"] = "Velvety and robust flavor."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Nanners" then
        for i in pairs(items) do
            if items[i]["ID"] == "NANNERS" then
                items[i]["found"] = true
                items[i]["name"] = "Nanners"
                items[i]["description"] = "Sweet, ripe and ready."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Taters" then
        for i in pairs(items) do
            if items[i]["ID"] == "TATERS" then
                items[i]["found"] = true
                items[i]["name"] = "Taters"
                items[i]["description"] = "Boil'em, mash'em, stick'em in a stew."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Garlic" then
        for i in pairs(items) do
            if items[i]["ID"] == "GARLIC" then
                items[i]["found"] = true
                items[i]["name"] = "Garlic"
                items[i]["description"] = "Garliel's finest product."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Nuts" then
        for i in pairs(items) do
            if items[i]["ID"] == "NUTS" then
                items[i]["found"] = true
                items[i]["name"] = "Nuts"
                items[i]["description"] = "Crunchy and full of flavor."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Doughball" then
        for i in pairs(items) do
            if items[i]["ID"] == "DOUGHBALL" then
                items[i]["found"] = true
                items[i]["name"] = "Doughball"
                items[i]["description"] = "The perfect puff, ready for baking."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Noodles" then
        for i in pairs(items) do
            if items[i]["ID"] == "NOODLES" then
                items[i]["found"] = true
                items[i]["name"] = "Noodles"
                items[i]["description"] = "Strands of dough ready for sauce or broth."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Eggies" then
        for i in pairs(items) do
            if items[i]["ID"] == "EGGIES" then
                items[i]["found"] = true
                items[i]["name"] = "Eggies"
                items[i]["description"] = "Boiled or fried, these are rich and full of flavor."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Crema" then
        for i in pairs(items) do
            if items[i]["ID"] == "CREMA" then
                items[i]["found"] = true
                items[i]["name"] = "Crema"
                items[i]["description"] = "Adds a rich and creamy texture to any meal."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Cheddah" then
        for i in pairs(items) do
            if items[i]["ID"] == "CHEDDAH" then
                items[i]["found"] = true
                items[i]["name"] = "Cheddah"
                items[i]["description"] = "The perfect addition to any meal."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Mozzerell" then
        for i in pairs(items) do
            if items[i]["ID"] == "MOZZERELL" then
                items[i]["found"] = true
                items[i]["name"] = "Mozzerell"
                items[i]["description"] = "Perfect for pizza or pasta."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Spicy" then
        for i in pairs(items) do
            if items[i]["ID"] == "SPICY" then
                items[i]["found"] = true
                items[i]["name"] = "Spicy"
                items[i]["description"] = "Complex flavors with hints of heat."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Sweet" then
        for i in pairs(items) do
            if items[i]["ID"] == "SWEET" then
                items[i]["found"] = true
                items[i]["name"] = "Sweet"
                items[i]["description"] = "Makes any dessert perfect."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Savory" then
        for i in pairs(items) do
            if items[i]["ID"] == "SAVORY" then
                items[i]["found"] = true
                items[i]["name"] = "Savory"
                items[i]["description"] = "Homestyle flavors to warm any heart."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    elseif self.itemPName == "Tangy" then
        for i in pairs(items) do
            if items[i]["ID"] == "TANGY" then
                items[i]["found"] = true
                items[i]["name"] = "Tangy"
                items[i]["description"] = "As if lemmies weren't sour enough."

                items[i]["quantity"] = items[i]["quantity"] + itemQty
            end
        end
    end
end

--inventory

items = {
    {
        ["itemID"] = 1,
        ["categoryID"] = 1,
        ["category"] = "Meat",
        ["found"] = false,
        ["name"] = "Meaty Chunks",
        ["ID"] = "MEATY CHUNKS",
        ["description"] = "Nice chunks of meat, probably beef.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 2,
        ["categoryID"] = 1,
        ["category"] = "Meat",
        ["found"] = false,
        ["name"] = "Flyin Fish",
        ["ID"] = "FLYIN FISH",
        ["description"] = "Fresh from the sea.. er .. air..",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 3,
        ["categoryID"] = 1,
        ["category"] = "Meat",
        ["found"] = false,
        ["name"] = "Big Chop",
        ["ID"] = "BIG CHOP",
        ["description"] = "Nice hunk of meat.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 4,
        ["categoryID"] = 1,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 5,
        ["categoryID"] = 1,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },

    {
        ["itemID"] = 6,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Berries",
        ["ID"] = "BERRIES",
        ["description"] = "Sweet and juicy.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 7,
        ["categoryID"] = 1,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 8,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Shroomas",
        ["ID"] = "SHROOMAS",
        ["description"] = "Velvety and robust flavor.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 9,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Brussels",
        ["ID"] = "BRUSSELS",
        ["description"] = "Delicious once roasted.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 10,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Tomas",
        ["ID"] = "TOMAS",
        ["description"] = "Round, juicy and full of flavor.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 11,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Nanners",
        ["ID"] = "NANNERS",
        ["description"] = "Sweet, ripe and ready.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 12,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Taters",
        ["ID"] = "TATERS",
        ["description"] = "Boil'em, mash'em, stick'em in a stew.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 13,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Lemmies",
        ["ID"] = "LEMMIES",
        ["description"] = "Small and sour.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 14,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Garlic",
        ["ID"] = "GARLIC",
        ["description"] = "Garliel's finest product.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 15,
        ["categoryID"] = 2,
        ["category"] = "Fruits and Vegetables",
        ["found"] = false,
        ["name"] = "Nuts",
        ["ID"] = "NUTS",
        ["description"] = "Crunchy and full of flavor.",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 16,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 17,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 18,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 19,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 20,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 21,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 22,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 23,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 24,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 25,
        ["categoryID"] = 2,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 26,
        ["categoryID"] = 3,
        ["category"] = "Bread and Dairy",
        ["found"] = true,
        ["name"] = "Doughball",
        ["ID"] = "DOUGHBALL",
        ["description"] = "The perfect puff, ready for baking.",
        ["quantity"] = 0,
        ["price"] = 10,
        ["levelReq"] = 0,
        ["shopItem"] = true
    },
    {
        ["itemID"] = 27,
        ["categoryID"] = 3,
        ["category"] = "Bread and Dairy",
        ["found"] = true,
        ["name"] = "Noodles",
        ["ID"] = "NOODLES",
        ["description"] = "Strands of dough ready for sauce or broth.",
        ["quantity"] = 0,
        ["price"] = 10,
        ["levelReq"] = 0,
        ["shopItem"] = true

    },
    {
        ["itemID"] = 28,
        ["categoryID"] = 3,
        ["category"] = "Bread and Dairy",
        ["found"] = true,
        ["name"] = "Eggies",
        ["ID"] = "EGGIES",
        ["description"] = "Boiled or fried, these are rich and full of flavor.",
        ["quantity"] = 0,
        ["price"] = 5,
        ["levelReq"] = 5,
        ["shopItem"] = true
    },
    {
        ["itemID"] = 29,
        ["categoryID"] = 3,
        ["category"] = "Bread and Dairy",
        ["found"] = true,
        ["name"] = "Crema",
        ["ID"] = "CREMA",
        ["description"] = "Adds a rich and creamy texture to any meal.",
        ["quantity"] = 0,
        ["price"] = 10,
        ["levelReq"] = 5,
        ["shopItem"] = true
    },
    {
        ["itemID"] = 30,
        ["categoryID"] = 3,
        ["category"] = "Bread and Dairy",
        ["found"] = true,
        ["name"] = "Cheddah",
        ["ID"] = "CHEDDAH",
        ["description"] = "The perfect addition to any meal.",
        ["quantity"] = 0,
        ["price"] = 10,
        ["levelReq"] = 5,
        ["shopItem"] = true

    },
    {
        ["itemID"] = 31,
        ["categoryID"] = 3,
        ["category"] = "Bread and Dairy",
        ["found"] = true,
        ["name"] = "Mozzerell",
        ["ID"] = "MOZZERELL",
        ["description"] = "Perfect for pizza or pasta.",
        ["quantity"] = 0,
        ["price"] = 10,
        ["levelReq"] = 5,
        ["shopItem"] = true
    },
    {
        ["itemID"] = 32,
        ["categoryID"] = 3,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 33,
        ["categoryID"] = 3,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 34,
        ["categoryID"] = 3,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 35,
        ["categoryID"] = 3,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 36,
        ["categoryID"] = 3,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 37,
        ["categoryID"] = 3,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 38,
        ["categoryID"] = 3,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 39,
        ["categoryID"] = 3,
        ["category"] = "",
        ["found"] = false,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = 0,
        ["price"] = 0,
        ["levelReq"] = 0
    },
    {
        ["itemID"] = 40,
        ["categoryID"] = 4,
        ["category"] = "Flavors",
        ["found"] = true,
        ["name"] = "Spicy",
        ["ID"] = "SPICY",
        ["description"] = "Complex flavors with hints of heat.",
        ["quantity"] = 0,
        ["price"] = 2,
        ["levelReq"] = 5,
        ["shopItem"] = true
    },
    {
        ["itemID"] = 41,
        ["categoryID"] = 4,
        ["category"] = "Flavors",
        ["found"] = true,
        ["name"] = "Sweet",
        ["ID"] = "SWEET",
        ["description"] = "Makes any dessert perfect.",
        ["quantity"] = 0,
        ["price"] = 2,
        ["levelReq"] = 0,
        ["shopItem"] = true
    },
    {
        ["itemID"] = 42,
        ["categoryID"] = 4,
        ["category"] = "Flavors",
        ["found"] = true,
        ["name"] = "Savory",
        ["ID"] = "SAVORY",
        ["description"] = "Homestyle flavors to warm any heart.",
        ["quantity"] = 0,
        ["price"] = 2,
        ["levelReq"] = 0,
        ["shopItem"] = true
    },
    {
        ["itemID"] = 43,
        ["categoryID"] = 4,
        ["category"] = "Flavors",
        ["found"] = true,
        ["name"] = "Tangy",
        ["ID"] = "TANGY",
        ["description"] = "As if lemmies weren't sour enough.",
        ["quantity"] = 0,
        ["price"] = 2,
        ["levelReq"] = 10,
        ["shopItem"] = true
    },

}



--- Check if a row matches the specified key constraints.
-- @param row The row to check
-- @param key_constraints The key constraints to apply
-- @return A boolean result
function filter_row(row, key_constraints)
    -- Loop through all constraints
    for k, v in pairs(key_constraints) do
        if v and not row[k] then
            -- The row is missing the key entirely,
            -- definitely not a match
            return false
        end

        -- Wrap the key and constraint values in arrays,
        -- if they're not arrays already (so we can loop through them)
        local actual_values = type(row[k]) == "table" and row[k] or { row[k] }
        local required_values = type(v) == "table" and v or { v }

        -- Loop through the values we *need* to find
        for i = 1, #required_values do
            local found
            -- Loop through the values actually present
            for j = 1, #actual_values do
                if actual_values[j] == required_values[i] then
                    -- This object has the required value somewhere in the key,
                    -- no need to look any farther
                    found = true
                    break
                end
            end

            if not found then
                return false
            end
        end
    end

    return true
end

--- Filter an array, returning entries matching `key_values`.
-- @param input The array to process
-- @param key_values A table of keys mapped to their viable values
-- @return An array of matches
function filter(input, key_values)
    local result = {}

    for i = 1, #input do
        local row = input[i]
        if filter_row(row, key_values) then
            result[#result + 1] = row
        end
    end

    return result
end
