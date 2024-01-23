local pd <const> = playdate
local gfx <const> = pd.graphics

class('Recipes').extends(gfx.sprite)

function Recipes:init(x, y)
    imageIndex = 1
    recipeImage = gfx.image.new("assets/images/recipes" .. imageIndex)
    for i in pairs(recipes) do
        if recipes[i]["ID"] == "MEATBALL SPECIAL" then
            self.currentState = "meatball"

            self.itemPName = "Meatball Special"
        else
            self.currentState = "meatball"

            self.itemPName = "Unknown"
        end
    end



    self:setImage(recipeImage)

    self:setCenter(0, 0)
    self:moveTo(272, 16)
    self:add()
    self:setZIndex(Z_INDEXES.Pickup)
    for i in pairs(recipes) do
        if recipes[i]["found"] == true then
            recipes[i]["name"] = recipes[i]["name"]
            recipes[i]["description"] = recipes[i]["description"]
            recipes[i]["requiredItems"] = recipes[i]["requiredItems"]
        elseif recipes[i]["found"] == false then
            recipes[i]["name"] = "??????"
            recipes[i]["description"] = "??????"
            recipes[i]["requiredItems"] = "??????"
        end
    end
end

function Recipes:update()
    if showImage == true then
        recipeImage = gfx.image.new("assets/images/recipes" .. imageIndex)
        self:setImage(recipeImage)
    else
        recipeImage = gfx.image.new("assets/images/recipes1")
        self:setImage(recipeImage)
    end
end

function Recipes:checkQuantity()
    for i in pairs(recipes) do
        itemName = recipes[i]["name"]
        totalItems = recipes[i]["quantity"]
    end
end

function Recipes:addRecipe(recipeItem)
    self.itemPName = recipeItem


    if self.itemPName == "Meatball Special" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "MEATBALL SPECIAL" then
                recipes[i]["found"] = true
                recipes[i]["name"] = "Meatball Special"
                recipes[i]["description"] = "Just like grandma used to make. Pasta in rich toma sauce with meatballs."
            end
        end
    elseif self.itemPName == "Grilled Fish" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "GRILLED FISH" then
                recipes[i]["found"] = true
                recipes[i]["name"] = "Grilled Fish"
                recipes[i]["description"] = "Straight from the Air to the grill, lemmy fresh."
            end
        end
    elseif self.itemPName == "Berry Tart" then
        for i in pairs(recipes) do
            if recipes[i]["ID"] == "BERRY TART" then
                recipes[i]["found"] = true
                recipes[i]["name"] = "Berry Tart"
                recipes[i]["description"] = "Baked to berry perfection."
            end
        end
    end
end

--testing Recipes:addInventory("Meatball Special")
function Recipes:addInventory(recipeItem)
    if recipeItem == "Meatball Special" then --5 Meaty Chunks\n10 Tomas\n1 Noodles\n2 Mozzerell\n1 Spicy
        if recipes[1].index == 2 then
            if recipes[1].found == true then
                if items[1].quantity >= 5 then
                    if items[10].quantity >= 10 then
                        if items[27].quantity >= 1 then
                            if items[31].quantity >= 2 then
                                if items[40].quantity >= 1 then
                                    Items:addItem(items[1].name, -5)
                                    Items:addItem(items[10].name, -10)
                                    Items:addItem(items[27].name, -1)
                                    Items:addItem(items[31].name, -2)
                                    Items:addItem(items[40].name, -1)
                                    recipes[1].quantity = recipes[1].quantity + 1

                                    print("success")
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Grilled Fish" then --4 Flying Fish\n2 Lemmies\n1 Savory
        if recipes[2].index == 3 then
            if recipes[2].found == true then
                if items[2].quantity >= 4 then
                    if items[13].quantity >= 2 then
                        if items[42].quantity >= 1 then
                            Items:addItem(items[2].name, -4)
                            Items:addItem(items[13].name, -2)
                            Items:addItem(items[42].name, -1)
                            recipes[2].quantity = recipes[2].quantity + 1

                            print("success")
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Fried Chop" then --2 Big Chop\n1 Savory
        if recipes[3].index == 4 then
            if recipes[3].found == true then
                if items[3].quantity >= 2 then
                    if items[42].quantity >= 1 then
                        Items:addItem(items[3].name, -2)
                        Items:addItem(items[42].name, -1)
                        recipes[3].quantity = recipes[3].quantity + 1

                        print("success")
                    end
                end
            end
        end
    elseif recipeItem == "Meaty Sando" then --5 Meaty Chunks\n3 Tomas\n2 Cheddah\n2 Doughball\n1 Savory
        if recipes[4].index == 5 then
            if recipes[4].found == true then
                if items[1].quantity >= 5 then
                    if items[10].quantity >= 3 then
                        if items[30].quantity >= 2 then
                            if items[26].quantity >= 2 then
                                if items[42].quantity >= 1 then
                                    Items:addItem(items[1].name, -5)
                                    Items:addItem(items[10].name, -3)
                                    Items:addItem(items[30].name, -2)
                                    Items:addItem(items[26].name, -2)
                                    Items:addItem(items[42].name, -1)
                                    recipes[4].quantity = recipes[4].quantity + 1

                                    print("success")
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        print("fail")
    end
end

--recipes

recipes = {
    {
        ["categoryID"] = 1,
        ["index"] = 2,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "Meatball Special",
        ["ID"] = "MEATBALL SPECIAL",
        ["description"] = "Just like grandma used to make. Pasta in rich toma sauce with meatballs.",
        ["quantity"] = 0,
        ["requiredItems"] = "5 Meaty Chunks\n10 Tomas\n1 Noodles\n2 Mozzerell\n1 Spicy",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 3,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "Grilled Fish",
        ["ID"] = "GRILLED FISH",
        ["description"] = "Straight from the air to the grill, lemmy fresh.",
        ["quantity"] = 0,
        ["requiredItems"] = "4 Flying Fish\n2 Lemmies\n1 Savory",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 4,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "Fried Chop",
        ["ID"] = "FRIED CHOP",
        ["description"] = "Fried to pork-fection.",
        ["quantity"] = 0,
        ["requiredItems"] = "2 Big Chop\n1 Savory",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 5,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "Meaty Sando",
        ["ID"] = "MEATY SANDO",
        ["description"] = "Chunks of meat, tomas and cheddah in a savory sando.",
        ["quantity"] = 0,
        ["requiredItems"] = "5 Meaty Chunks\n3 Tomas\n2 Cheddah\n2 Doughball\n1 Savory",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 6,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "Veggie Sando",
        ["ID"] = "VEGGIE SANDO",
        ["description"] = "Brussels, tomas and cheddah in a spicy sando.",
        ["quantity"] = 0,
        ["requiredItems"] = "3 Brussels\n3 Tomas\n2 Cheddah\n2 Doughball\n1 Spicy",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 7,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "Meaty Pizza",
        ["ID"] = "MEATY PIZZA",
        ["description"] = "Chunks of meat, tomas, shrooma and mozzerell on a thin crust.",
        ["quantity"] = 0,
        ["requiredItems"] = "4 Meaty Chunks\n3 Tomas\n3 Shrooma\n4 Mozzerell\n2 Doughball",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 8,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "Cheesy Pizza",
        ["ID"] = "CHEESY PIZZA",
        ["description"] = "Cheddah, mozzerell and tomas on a thin crust.",
        ["quantity"] = 0,
        ["requiredItems"] = "4 Cheddah\n4 Mozzerell\n3 Tomas\n2 Doughball",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 9,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "Mac n Cheese",
        ["ID"] = "MAC N CHEESE",
        ["description"] = "Little noodles in a creamy, cheesy sauce",
        ["quantity"] = 0,
        ["requiredItems"] = "10 Noodles\n4 Cheddah\n2 Crema",
    },
    {
        ["categoryID"] = 2,
        ["index"] = 10,
        ["category"] = "Side Dish",
        ["found"] = true,
        ["name"] = "Mushroom Soup",
        ["ID"] = "MUSHROOM SOUP",
        ["description"] = "Savory mushrooms in a creamy soup",
        ["quantity"] = 0,
        ["requiredItems"] = "10 Shrooma\n5 Crema\n1 Savory",
    },
    {
        ["categoryID"] = 2,
        ["index"] = 11,
        ["category"] = "Side Dish",
        ["found"] = true,
        ["name"] = "Meaty Stew",
        ["ID"] = "MEATY STEW",
        ["description"] = "Savory stew to warm any tum",
        ["quantity"] = 0,
        ["requiredItems"] = "5 Meaty Chunks\n3 Brussels\n5 Shrooma\n1 Savory",
    },
    {
        ["categoryID"] = 2,
        ["index"] = 12,
        ["category"] = "Side Dish",
        ["found"] = true,
        ["name"] = "Toma Soup",
        ["ID"] = "TOMA SOUP",
        ["description"] = "Savory tomas in a creamy soup",
        ["quantity"] = 0,
        ["requiredItems"] = "10 Tomas\n5 Crema\n1 Savory",
    },
    {
        ["categoryID"] = 2,
        ["index"] = 13,
        ["category"] = "Side Dish",
        ["found"] = true,
        ["name"] = "Ramen",
        ["ID"] = "RAMEN",
        ["description"] = "Rich broth with noodles, meat, shrooma and topped with eggies",
        ["quantity"] = 0,
        ["requiredItems"] = "4 Meaty Chunks\n4 Shrooma\n10 Noodles\n2 Eggies\n1 Savory",
    },
    {
        ["categoryID"] = 3,
        ["index"] = 14,
        ["category"] = "Dessert",
        ["found"] = true,
        ["name"] = "Berry Tart",
        ["ID"] = "BERRY TART",
        ["description"] = "Baked to berry perfection",
        ["quantity"] = 0,
        ["requiredItems"] = "10 Berries\n2 Doughball\n1 Sweet",
    },
    {
        ["categoryID"] = 3,
        ["index"] = 15,
        ["category"] = "Dessert",
        ["found"] = true,
        ["name"] = "Cookies",
        ["ID"] = "COOKIES",
        ["description"] = "Warm and chewy",
        ["quantity"] = 0,
        ["requiredItems"] = "12 Doughball\n1 Sweet",
    },
    {
        ["categoryID"] = 3,
        ["index"] = 16,
        ["category"] = "Dessert",
        ["found"] = true,
        ["name"] = "Nanner Puddin",
        ["ID"] = "NANNER PUDDIN",
        ["description"] = "Chunks of nanners in a creamy pudding",
        ["quantity"] = 0,
        ["requiredItems"] = "10 Nanners\n4 Crema\n1 Sweet",
    },
    {
        ["categoryID"] = 4,
        ["index"] = 17,
        ["category"] = "Snacks",
        ["found"] = true,
        ["name"] = "Fries",
        ["ID"] = "FRIES",
        ["description"] = "Fried Taters with savory seasoning",
        ["quantity"] = 0,
        ["requiredItems"] = "10 Taters\n1 Savory",
    },
    {
        ["categoryID"] = 4,
        ["index"] = 18,
        ["category"] = "Snacks",
        ["found"] = true,
        ["name"] = "Trail Mix",
        ["ID"] = "TRAIL MIX",
        ["description"] = "Spicy mix of various snacks",
        ["quantity"] = 0,
        ["requiredItems"] = "5 Meaty Chunks\n5 Nuts\n5 Berries\n5 Nanners\n1 Spicy",
    },
    {
        ["categoryID"] = 4,
        ["index"] = 19,
        ["category"] = "Snacks",
        ["found"] = true,
        ["name"] = "Brussel Bites",
        ["ID"] = "BRUSSEL BITES",
        ["description"] = "Fried Brussels topped with mozzerell and savory seasoning",
        ["quantity"] = 0,
        ["requiredItems"] = "10 Brussels\n5 Mozzerrel\n1 Savory",
    },

}
