local pd <const> = playdate
local gfx <const> = pd.graphics

quests = {
    {
        ["ID"] = 1,
        ["intro"] = false,
        ["inProgress"] = false,
        ["complete"] = false,
        ["title"] = "Gather Berries",
        ["owner"] = "Junlop",
        ["introCopy"] = "Hello, I need to make a Berry Tart, but I am out of Berries, can you bring me 10 Berries?",
        ["inProgressCopy"] = "In case you forgot, I need 10 Berries to make a Berry Tart",
        ["turninCopy"] = "Thank you, just one minute......  ...... .. There! Have a Berry Tart for your troubles",
        ["completeCopy"] = "Thank you!",
        ["description"] = "Junlop is looking to make a Berry Tart, but is out of berries. Help him gather 10 berries.",
        ["gatherItem"] = "Berries",
        ["quantity"] = 10,
        ["reward"] = "Berry Tart",
        ["rewardQty"] = 2,
        ["rewardReceived"] = false,
        ["recipeReceived"] = false,

    },
    {
        ["ID"] = 2,
        ["intro"] = false,
        ["inProgress"] = false,
        ["complete"] = false,
        ["title"] = "Gather Berries",
        ["owner"] = "Junlop",
        ["introCopy"] = "can you bring me 30 Berries?",
        ["inProgressCopy"] = "I need 30 Berries to make a Berry Tart",
        ["turninCopy"] = "Thank you, just one minute......  ...... .. There! Have a Berry Tart for your troubles",
        ["completeCopy"] = "Thank you!",
        ["description"] = "Junlop is looking to make a Berry Tart, but is out of berries. Help him gather 30 berries.",
        ["gatherItem"] = "Berries",
        ["quantity"] = 5,
        ["reward"] = "Meaty Chunks",
        ["rewardQty"] = 2,
        ["rewardReceived"] = false,
        ["recipeReceived"] = true,


    },
    {
        ["ID"] = 3,
        ["intro"] = false,
        ["inProgress"] = false,
        ["complete"] = false,
        ["title"] = "Gather Meaty Chunks",
        ["owner"] = "Junlop",
        ["introCopy"] = "can you bring me 10 Meaty Chunks?",
        ["inProgressCopy"] = "I need 10 Meaty Chunks",
        ["turninCopy"] = "Thank you, just one minute......  ...... .. There! Have a Meaty Chunks for your troubles",
        ["completeCopy"] = "Thank you!",
        ["description"] =
        "Junlop is looking to make a Meaty Treat, but is out of Meaty Chunks. Help him gather 10 Meaty Chunks.",
        ["gatherItem"] = "Meaty Chunks",
        ["quantity"] = 10,
        ["reward"] = "Meaty Chunks",
        ["rewardQty"] = 2,
        ["rewardReceived"] = false,
        ["recipeReceived"] = true,

    },

}
