local pd <const> = playdate
local gfx <const> = pd.graphics

class('Recipes').extends(gfx.sprite)

function Recipes:init(x, y)
    imageIndex = 1
    recipeImage = gfx.image.new("assets/images/recipes" .. imageIndex)



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
    if recipeItem == "Meatball Special" then --5 Meaty Chunks\n/ 10 Tomas\n/ 1 Noodles\n/ 2 Mozzerell\n/ 1 Spicy
        if recipes[2].index == 2 then
            if recipes[2].found == true then
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
                                    recipes[2].quantity = recipes[2].quantity + 1

                                    print("success")
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Grilled Fish" then --4 Flying Fish\n/ 2 Lemmies\n/ 1 Savory
        if recipes[3].index == 3 then
            if recipes[3].found == true then
                if items[2].quantity >= 4 then
                    if items[13].quantity >= 2 then
                        if items[42].quantity >= 1 then
                            Items:addItem(items[2].name, -4)
                            Items:addItem(items[13].name, -2)
                            Items:addItem(items[42].name, -1)
                            recipes[3].quantity = recipes[3].quantity + 1

                            print("success")
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Fried Chop" then --2 Big Chop\n/ 1 Savory
        if recipes[4].index == 4 then
            if recipes[4].found == true then
                if items[3].quantity >= 2 then
                    if items[42].quantity >= 1 then
                        Items:addItem(items[3].name, -2)
                        Items:addItem(items[42].name, -1)
                        recipes[4].quantity = recipes[4].quantity + 1

                        print("success")
                    end
                end
            end
        end
    elseif recipeItem == "Meaty Sando" then --5 Meaty Chunks\n/ 3 Tomas\n/ 2 Cheddah\n/ 2 Doughball\n/ 1 Savory
        if recipes[5].index == 5 then
            if recipes[5].found == true then
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
                                    recipes[5].quantity = recipes[5].quantity + 1

                                    print("success")
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Veggie Sando" then --3 Brussels\n/ 3 Tomas\n/ 2 Cheddah\n/ 2 Doughball\n/ 1 Spicy
        if recipes[6].index == 6 then
            if recipes[6].found == true then
                if items[9].quantity >= 3 then
                    if items[10].quantity >= 3 then
                        if items[30].quantity >= 2 then
                            if items[26].quantity >= 2 then
                                if items[42].quantity >= 1 then
                                    Items:addItem(items[9].name, -3)
                                    Items:addItem(items[10].name, -3)
                                    Items:addItem(items[30].name, -2)
                                    Items:addItem(items[26].name, -2)
                                    Items:addItem(items[40].name, -1)
                                    recipes[6].quantity = recipes[6].quantity + 1

                                    print("success")
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Meaty Pizza" then --4 Meaty Chunks\n/ 3 Tomas\n/ 3 Shrooma\n/ 4 Mozzerell\n/ 2 Doughball
        if recipes[7].index == 7 then
            if recipes[7].found == true then
                if items[1].quantity >= 4 then
                    if items[10].quantity >= 3 then
                        if items[8].quantity >= 3 then
                            if items[26].quantity >= 4 then
                                if items[31].quantity >= 2 then
                                    Items:addItem(items[1].name, -3)
                                    Items:addItem(items[10].name, -3)
                                    Items:addItem(items[8].name, -2)
                                    Items:addItem(items[26].name, -2)
                                    Items:addItem(items[31].name, -1)
                                    recipes[7].quantity = recipes[7].quantity + 1

                                    print("success")
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Cheesy Pizza" then --4 Cheddah\n/ 4 Mozzerell\n/ 3 Tomas\n/ 2 Doughball
        if recipes[8].index == 8 then
            if recipes[8].found == true then
                if items[30].quantity >= 4 then
                    if items[31].quantity >= 4 then
                        if items[10].quantity >= 3 then
                            if items[26].quantity >= 2 then
                                Items:addItem(items[30].name, -4)
                                Items:addItem(items[31].name, -4)
                                Items:addItem(items[10].name, -3)
                                Items:addItem(items[26].name, -2)

                                recipes[8].quantity = recipes[8].quantity + 1

                                print("success")
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Mac n Cheese" then --10 Noodles\n/ 4 Cheddah\n/ 2 Crema
        if recipes[9].index == 9 then
            if recipes[9].found == true then
                if items[27].quantity >= 10 then
                    if items[30].quantity >= 4 then
                        if items[29].quantity >= 2 then
                            Items:addItem(items[27].name, -10)
                            Items:addItem(items[31].name, -4)
                            Items:addItem(items[29].name, -2)

                            recipes[9].quantity = recipes[9].quantity + 1

                            print("success")
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Mushroom Soup" then --10 Shrooma\n/ 5 Crema\n/ 1 Savory
        if recipes[10].index == 10 then
            if recipes[10].found == true then
                if items[8].quantity >= 10 then
                    if items[29].quantity >= 5 then
                        if items[42].quantity >= 1 then
                            Items:addItem(items[8].name, -10)
                            Items:addItem(items[31].name, -5)
                            Items:addItem(items[42].name, -1)

                            recipes[10].quantity = recipes[10].quantity + 1

                            print("success")
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Meaty Stew" then --5 Meaty Chunks\n/ 3 Brussels\n/ 5 Shrooma\n/ 1 Savory
        if recipes[11].index == 11 then
            if recipes[11].found == true then
                if items[1].quantity >= 5 then
                    if items[9].quantity >= 3 then
                        if items[8].quantity >= 5 then
                            if items[42].quantity >= 1 then
                                Items:addItem(items[1].name, -5)
                                Items:addItem(items[9].name, -3)
                                Items:addItem(items[8].name, -5)
                                Items:addItem(items[42].name, -1)

                                recipes[11].quantity = recipes[11].quantity + 1

                                print("success")
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Toma Soup" then --10 Tomas\n/ 5 Crema\n/ 1 Savory
        if recipes[12].index == 12 then
            if recipes[12].found == true then
                if items[10].quantity >= 10 then
                    if items[29].quantity >= 5 then
                        if items[42].quantity >= 1 then
                            Items:addItem(items[10].name, -10)
                            Items:addItem(items[29].name, -5)
                            Items:addItem(items[42].name, -1)

                            recipes[12].quantity = recipes[12].quantity + 1

                            print("success")
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Ramen" then --4 Meaty Chunks\n/ 4 Shrooma\n/ 10 Noodles\n/ 2 Eggies\n/ 1 Savory
        if recipes[13].index == 13 then
            if recipes[13].found == true then
                if items[1].quantity >= 4 then
                    if items[8].quantity >= 4 then
                        if items[27].quantity >= 10 then
                            if items[28].quantity >= 2 then
                                if items[42].quantity >= 1 then
                                    Items:addItem(items[1].name, -4)
                                    Items:addItem(items[8].name, -4)
                                    Items:addItem(items[27].name, -10)
                                    Items:addItem(items[28].name, -2)
                                    Items:addItem(items[42].name, -1)

                                    recipes[13].quantity = recipes[13].quantity + 1

                                    print("success")
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Berry Tart" then --10 Berries\n/ 2 Doughball\n/ 1 Sweet
        if recipes[14].index == 14 then
            if recipes[14].found == true then
                if items[6].quantity >= 10 then
                    if items[26].quantity >= 2 then
                        if items[41].quantity >= 1 then
                            Items:addItem(items[6].name, -10)
                            Items:addItem(items[26].name, -2)
                            Items:addItem(items[41].name, -1)

                            recipes[14].quantity = recipes[14].quantity + 1

                            print("success")
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Cookies" then --12 Doughball\n/ 1 Sweet
        if recipes[15].index == 15 then
            if recipes[15].found == true then
                if items[26].quantity >= 12 then
                    if items[41].quantity >= 1 then
                        Items:addItem(items[26].name, -12)
                        Items:addItem(items[41].name, -1)

                        recipes[15].quantity = recipes[15].quantity + 1

                        print("success")
                    end
                end
            end
        end
    elseif recipeItem == "Nanner Puddin" then --10 Nanners\n/ 4 Crema\n/ 1 Sweet
        if recipes[16].index == 16 then
            if recipes[16].found == true then
                if items[11].quantity >= 10 then
                    if items[29].quantity >= 4 then
                        if items[41].quantity >= 1 then
                            Items:addItem(items[11].name, -10)
                            Items:addItem(items[29].name, -4)
                            Items:addItem(items[41].name, -1)

                            recipes[16].quantity = recipes[16].quantity + 1

                            print("success")
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Fries" then --10 Taters\n/ 1 Savory
        if recipes[17].index == 17 then
            if recipes[17].found == true then
                if items[12].quantity >= 12 then
                    if items[42].quantity >= 1 then
                        Items:addItem(items[12].name, -12)
                        Items:addItem(items[42].name, -1)

                        recipes[17].quantity = recipes[17].quantity + 1

                        print("success")
                    end
                end
            end
        end
    elseif recipeItem == "Trail Mix" then --5 Meaty Chunks\n/ 5 Nuts\n/ 5 Berries\n/ 5 Nanners\n/ 1 Spicy
        if recipes[18].index == 18 then
            if recipes[18].found == true then
                if items[1].quantity >= 5 then
                    if items[15].quantity >= 5 then
                        if items[6].quantity >= 5 then
                            if items[11].quantity >= 5 then
                                if items[40].quantity >= 1 then
                                    Items:addItem(items[1].name, -5)
                                    Items:addItem(items[15].name, -5)
                                    Items:addItem(items[6].name, 5)
                                    Items:addItem(items[11].name, -5)
                                    Items:addItem(items[40].name, -1)

                                    recipes[18].quantity = recipes[18].quantity + 1

                                    print("success")
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif recipeItem == "Brussel Bites" then --10 Brussels\n/ 5 Mozzerrel\n/ 1 Savory
        if recipes[19].index == 19 then
            if recipes[19].found == true then
                if items[9].quantity >= 10 then
                    if items[31].quantity >= 5 then
                        if items[42].quantity >= 1 then
                            Items:addItem(items[9].name, -10)
                            Items:addItem(items[31].name, -5)
                            Items:addItem(items[42].name, -1)

                            recipes[19].quantity = recipes[19].quantity + 1

                            print("success")
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
        ["index"] = 1,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = "",
        ["requiredItems"] = "",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 2,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Meatball Special",
        ["ID"] = "MEATBALL SPECIAL",
        ["description"] = "Just like grandma used to make. Pasta in rich toma sauce with meatballs.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 5 Meaty Chunks\n/ 10 Tomas\n/ 1 Noodles\n/ 2 Mozzerell\n/ 1 Spicy",

    },
    {
        ["categoryID"] = 1,
        ["index"] = 3,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Grilled Fish",
        ["ID"] = "GRILLED FISH",
        ["description"] = "Straight from the air to the grill, lemmy fresh.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 4 Flying Fish\n/ 2 Lemmies\n/ 1 Savory",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 4,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Fried Chop",
        ["ID"] = "FRIED CHOP",
        ["description"] = "Fried to pork-fection.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 2 Big Chop\n/ 1 Savory",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 5,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Meaty Sando",
        ["ID"] = "MEATY SANDO",
        ["description"] = "Chunks of meat, tomas and cheddah in a savory sando.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 5 Meaty Chunks\n/ 3 Tomas\n/ 2 Cheddah\n/ 2 Doughball\n/ 1 Savory",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 6,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Veggie Sando",
        ["ID"] = "VEGGIE SANDO",
        ["description"] = "Brussels, tomas and cheddah in a spicy sando.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 3 Brussels\n/ 3 Tomas\n/ 2 Cheddah\n/ 2 Doughball\n/ 1 Spicy",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 7,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Meaty Pizza",
        ["ID"] = "MEATY PIZZA",
        ["description"] = "Chunks of meat, tomas, shrooma and mozzerell on a thin crust.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 4 Meaty Chunks\n/ 3 Tomas\n/ 3 Shrooma\n/ 4 Mozzerell\n/ 2 Doughball",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 8,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Cheesy Pizza",
        ["ID"] = "CHEESY PIZZA",
        ["description"] = "Cheddah, mozzerell and tomas on a thin crust.",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 4 Cheddah\n/ 4 Mozzerell\n/ 3 Tomas\n/ 2 Doughball",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 9,
        ["category"] = "Main Dish",
        ["found"] = false,
        ["name"] = "Mac n Cheese",
        ["ID"] = "MAC N CHEESE",
        ["description"] = "Little noodles in a creamy, cheesy sauce",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Noodles\n/ 4 Cheddah\n/ 2 Crema",
    },
    {
        ["categoryID"] = 2,
        ["index"] = 10,
        ["category"] = "Side Dish",
        ["found"] = false,
        ["name"] = "Mushroom Soup",
        ["ID"] = "MUSHROOM SOUP",
        ["description"] = "Savory mushrooms in a creamy soup",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Shrooma\n/ 5 Crema\n/ 1 Savory",
    },
    {
        ["categoryID"] = 2,
        ["index"] = 11,
        ["category"] = "Side Dish",
        ["found"] = false,
        ["name"] = "Meaty Stew",
        ["ID"] = "MEATY STEW",
        ["description"] = "Savory stew to warm any tum",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 5 Meaty Chunks\n/ 3 Brussels\n/ 5 Shrooma\n/ 1 Savory",
    },
    {
        ["categoryID"] = 2,
        ["index"] = 12,
        ["category"] = "Side Dish",
        ["found"] = false,
        ["name"] = "Toma Soup",
        ["ID"] = "TOMA SOUP",
        ["description"] = "Savory tomas in a creamy soup",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Tomas\n/ 5 Crema\n/ 1 Savory",
    },
    {
        ["categoryID"] = 2,
        ["index"] = 13,
        ["category"] = "Side Dish",
        ["found"] = false,
        ["name"] = "Ramen",
        ["ID"] = "RAMEN",
        ["description"] = "Rich broth with noodles, meat, shrooma and topped with eggies",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 4 Meaty Chunks\n/ 4 Shrooma\n/ 10 Noodles\n/ 2 Eggies\n/ 1 Savory",
    },
    {
        ["categoryID"] = 3,
        ["index"] = 14,
        ["category"] = "Dessert",
        ["found"] = false,
        ["name"] = "Berry Tart",
        ["ID"] = "BERRY TART",
        ["description"] = "Baked to berry perfection",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Berries\n/ 2 Doughball\n/ 1 Sweet",
    },
    {
        ["categoryID"] = 3,
        ["index"] = 15,
        ["category"] = "Dessert",
        ["found"] = false,
        ["name"] = "Cookies",
        ["ID"] = "COOKIES",
        ["description"] = "Warm and chewy",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 12 Doughball\n/ 1 Sweet",
    },
    {
        ["categoryID"] = 3,
        ["index"] = 16,
        ["category"] = "Dessert",
        ["found"] = false,
        ["name"] = "Nanner Puddin",
        ["ID"] = "NANNER PUDDIN",
        ["description"] = "Chunks of nanners in a creamy pudding",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Nanners\n/ 4 Crema\n/ 1 Sweet",
    },
    {
        ["categoryID"] = 4,
        ["index"] = 17,
        ["category"] = "Snacks",
        ["found"] = false,
        ["name"] = "Fries",
        ["ID"] = "FRIES",
        ["description"] = "Fried Taters with savory seasoning",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Taters\n/ 1 Savory",
    },
    {
        ["categoryID"] = 4,
        ["index"] = 18,
        ["category"] = "Snacks",
        ["found"] = false,
        ["name"] = "Trail Mix",
        ["ID"] = "TRAIL MIX",
        ["description"] = "Spicy mix of various snacks",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 5 Meaty Chunks\n/ 5 Nuts\n/ 5 Berries\n/ 5 Nanners\n/ 1 Spicy",
    },
    {
        ["categoryID"] = 4,
        ["index"] = 19,
        ["category"] = "Snacks",
        ["found"] = false,
        ["name"] = "Brussel Bites",
        ["ID"] = "BRUSSEL BITES",
        ["description"] = "Fried Brussels topped with mozzerell and savory seasoning",
        ["quantity"] = 0,
        ["requiredItems"] = "/ 10 Brussels\n/ 5 Mozzerrel\n/ 1 Savory",
    },
    {
        ["categoryID"] = 1,
        ["index"] = 20,
        ["category"] = "Main Dish",
        ["found"] = true,
        ["name"] = "",
        ["ID"] = "",
        ["description"] = "",
        ["quantity"] = "",
        ["requiredItems"] = "",
    },

}
