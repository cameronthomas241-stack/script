local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "⛏️ SELL ORES 🤑",
    Icon = 0,
    LoadingTitle = "⛏️ Loading Sell Ores...",
    LoadingSubtitle = "💎 by Arcane",
    ShowText = "Rayfield",
    Theme = "Default",

    ToggleUIKeybind = "K",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Big Hub"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },

    KeySystem = false,

    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--==================================================
-- MAIN TAB
--==================================================

local MainTab = Window:CreateTab("🏠 Main", nil)
local MainSection = MainTab:CreateSection("⚙️ Main Controls")

local AutoSell = false
local FurnaceMode = false
local Running = false

--==================================================
-- MOVEMENT LOCK
--==================================================

local MovementBusy = false
local RollerUsingMovement = false

local function takeMovementLock(isRoller)

    if isRoller then

        while MovementBusy do
            task.wait(0.03)
        end

        MovementBusy = true
        RollerUsingMovement = true

    else

        while MovementBusy or RollerUsingMovement do
            task.wait(0.05)
        end

        MovementBusy = true

    end
end

local function releaseMovementLock(isRoller)

    if isRoller then
        RollerUsingMovement = false
    end

    MovementBusy = false
end

--==================================================
-- HELPERS
--==================================================

local function getRoot()

    local character =
        player.Character or player.CharacterAdded:Wait()

    return character:WaitForChild("HumanoidRootPart")

end

local function getClosestBase()

    local root = getRoot()

    local bases = workspace:FindFirstChild("Bases")

    if not bases then
        return nil
    end

    local closestBase = nil
    local closestDistance = math.huge

    for _, base in ipairs(bases:GetChildren()) do

        local crateMaker =
            base:FindFirstChild("CrateMaker", true)

        local sellerTable =
            base:FindFirstChild("SellerTable", true)

        if crateMaker and sellerTable then

            local position

            if crateMaker:IsA("Model") then

                position =
                    crateMaker:GetPivot().Position

            elseif crateMaker:IsA("BasePart") then

                position =
                    crateMaker.Position

            end

            if position then

                local distance =
                    (root.Position - position).Magnitude

                if distance < closestDistance then

                    closestDistance = distance
                    closestBase = base

                end

            end
        end
    end

    return closestBase
end

local function teleport(part)

    if not part then
        return
    end

    local root = getRoot()

    root.CFrame =
        part.CFrame + Vector3.new(0, 3, 0)

end

--==================================================
-- FURNACE
--==================================================

local function getFurnace(base)

    if not base then
        return nil
    end

    return base:FindFirstChild(
        "Furnace",
        true
    )

end

local function getFurnacePrompt(furnace)

    if not furnace then
        return nil
    end

    for _, object in ipairs(
        furnace:GetDescendants()
    ) do

        if object:IsA("ProximityPrompt")
            and object.Enabled then

            return object

        end

    end

    return nil
end

--==================================================
-- AUTO SELL
--==================================================

local function startAutoSell()

    if Running then
        return
    end

    Running = true

    task.spawn(function()

        while AutoSell do

            local base = getClosestBase()

            if base then

                local crateMaker =
                    base:FindFirstChild(
                        "CrateMaker",
                        true
                    )

                local spawnPoint =
                    crateMaker
                    and crateMaker:FindFirstChild(
                        "CrateSpawnPoint",
                        true
                    )

                local sellerTable =
                    base:FindFirstChild(
                        "SellerTable",
                        true
                    )

                local sellPoint =
                    sellerTable
                    and sellerTable:FindFirstChild(
                        "CrateSellTransform",
                        true
                    )

                local sellPrompt =
                    sellerTable
                    and sellerTable:FindFirstChild(
                        "SellOresPrompt",
                        true
                    )

                local furnace =
                    getFurnace(base)

                if crateMaker
                    and spawnPoint
                    and sellPoint
                    and sellPrompt then

                    local pickupPrompt = nil
                    local crateObject = nil

                    -- Find crate
                    for _, crate in ipairs(
                        crateMaker:GetChildren()
                    ) do

                        local prompt =
                            crate:FindFirstChildWhichIsA(
                                "ProximityPrompt",
                                true
                            )

                        if prompt
                            and prompt.Enabled then

                            pickupPrompt = prompt
                            crateObject = crate

                            break

                        end
                    end

                    if pickupPrompt then

                        -- Auto Sell uses normal priority
                        takeMovementLock(false)

                        --==================================
                        -- PICK UP CRATE
                        --==================================

                        if crateObject:IsA("BasePart") then

                            teleport(crateObject)

                        else

                            teleport(spawnPoint)

                        end

                        task.wait(0.4)

                        if not AutoSell then

                            releaseMovementLock(false)
                            break

                        end

                        pcall(function()

                            fireproximityprompt(
                                pickupPrompt
                            )

                        end)

                        task.wait(0.8)

                        if not AutoSell then

                            releaseMovementLock(false)
                            break

                        end

                        --==================================
                        -- FURNACE MODE
                        --==================================

                        if FurnaceMode and furnace then

                            local furnacePrompt =
                                getFurnacePrompt(
                                    furnace
                                )

                            if furnacePrompt then

                                local furnacePart =
                                    furnacePrompt.Parent

                                if furnacePart:IsA(
                                    "BasePart"
                                ) then

                                    teleport(
                                        furnacePart
                                    )

                                else

                                    local fallbackPart =
                                        furnace:FindFirstChildWhichIsA(
                                            "BasePart",
                                            true
                                        )

                                    if fallbackPart then

                                        teleport(
                                            fallbackPart
                                        )

                                    end
                                end

                                task.wait(0.5)

                                if not AutoSell then

                                    releaseMovementLock(false)
                                    break

                                end

                                -- Place crate in furnace
                                pcall(function()

                                    fireproximityprompt(
                                        furnacePrompt
                                    )

                                end)

                                task.wait(1)

                                if not AutoSell then

                                    releaseMovementLock(false)
                                    break

                                end

                                -- Pick crate back up
                                local pickupAgain = nil

                                for _, object in ipairs(
                                    furnace:GetDescendants()
                                ) do

                                    if object:IsA(
                                        "ProximityPrompt"
                                    )
                                    and object.Enabled then

                                        pickupAgain = object
                                        break

                                    end

                                end

                                if pickupAgain then

                                    pcall(function()

                                        fireproximityprompt(
                                            pickupAgain
                                        )

                                    end)

                                    task.wait(0.8)

                                end
                            end
                        end

                        --==================================
                        -- SELL
                        --==================================

                        if not AutoSell then

                            releaseMovementLock(false)
                            break

                        end

                        teleport(sellPoint)

                        task.wait(0.5)

                        if not AutoSell then

                            releaseMovementLock(false)
                            break

                        end

                        if sellPrompt:IsA(
                            "ProximityPrompt"
                        )
                        and sellPrompt.Enabled then

                            pcall(function()

                                fireproximityprompt(
                                    sellPrompt
                                )

                            end)

                        end

                        task.wait(0.8)

                        if not AutoSell then

                            releaseMovementLock(false)
                            break

                        end

                        -- Return to crates
                        teleport(spawnPoint)

                        task.wait(0.3)

                        releaseMovementLock(false)

                    else

                        task.wait(0.5)

                    end

                else

                    task.wait(1)

                end

            else

                task.wait(1)

            end

        end

        Running = false

    end)
end

--==================================================
-- AUTO SELL TOGGLE
--==================================================

MainTab:CreateToggle({
    Name = "💰 Auto Sell",
    CurrentValue = false,
    Flag = "AutoSell",

    Callback = function(Value)

        AutoSell = Value

        if Value then
            startAutoSell()
        end

    end,
})

--==================================================
-- FURNACE TOGGLE
--==================================================

MainTab:CreateToggle({
    Name = "🔥 Furnace Mode",
    CurrentValue = false,
    Flag = "FurnaceMode",

    Callback = function(Value)

        FurnaceMode = Value

    end,
})

--==================================================
-- AUTO UPGRADES
--==================================================

local AutoDrillSpeed = false
local AutoDrillYield = false
local AutoOreRegen = false
local AutoOreLuck = false
local AutoPedestal = false

MainTab:CreateSection("⬆️ Auto Upgrades")

MainTab:CreateToggle({
    Name = "⚡ Auto Drill Speed",
    CurrentValue = false,
    Flag = "AutoDrillSpeed",

    Callback = function(Value)

        AutoDrillSpeed = Value

        if Value then

            task.spawn(function()

                while AutoDrillSpeed do

                    local base = getClosestBase()

                    if base then

                        pcall(function()

                            ReplicatedStorage.Remotes
                                .BaseUpgradeDrillSpeed
                                :InvokeServer(
                                    base.Name,
                                    1
                                )

                        end)

                    end

                    task.wait(1)

                end

            end)

        end

    end,
})

MainTab:CreateToggle({
    Name = "⛏️ Auto Drill Yield",
    CurrentValue = false,
    Flag = "AutoDrillYield",

    Callback = function(Value)

        AutoDrillYield = Value

        if Value then

            task.spawn(function()

                while AutoDrillYield do

                    local base = getClosestBase()

                    if base then

                        pcall(function()

                            ReplicatedStorage.Remotes
                                .BaseUpgradeDrillYield
                                :InvokeServer(
                                    base.Name,
                                    1
                                )

                        end)

                    end

                    task.wait(1)

                end

            end)

        end

    end,
})

MainTab:CreateToggle({
    Name = "♻️ Auto Ore Regen Speed",
    CurrentValue = false,
    Flag = "AutoOreRegen",

    Callback = function(Value)

        AutoOreRegen = Value

        if Value then

            task.spawn(function()

                while AutoOreRegen do

                    local base = getClosestBase()

                    if base then

                        pcall(function()

                            ReplicatedStorage.Remotes
                                .BaseUpgradeOreRegenSpeed
                                :InvokeServer(
                                    base.Name,
                                    1
                                )

                        end)

                    end

                    task.wait(1)

                end

            end)

        end

    end,
})

MainTab:CreateToggle({
    Name = "🍀 Auto Ore Luck",
    CurrentValue = false,
    Flag = "AutoOreLuck",

    Callback = function(Value)

        AutoOreLuck = Value

        if Value then

            task.spawn(function()

                while AutoOreLuck do

                    local base = getClosestBase()

                    if base then

                        pcall(function()

                            ReplicatedStorage
                                .RollerUpgradeOreLuck
                                :InvokeServer(
                                    base.Name
                                )

                        end)

                    end

                    task.wait(1)

                end

            end)

        end

    end,
})

MainTab:CreateToggle({
    Name = "🏆 Auto Pedestal",
    CurrentValue = false,
    Flag = "AutoPedestal",

    Callback = function(Value)

        AutoPedestal = Value

        if Value then

            task.spawn(function()

                while AutoPedestal do

                    local base = getClosestBase()

                    if base then

                        pcall(function()

                            ReplicatedStorage
                                .RollerUpgradePedestal
                                :InvokeServer(
                                    base.Name
                                )

                        end)

                    end

                    task.wait(1)

                end

            end)

        end

    end,
})

--==================================================
-- AUTO ROLLER
--==================================================

local RollerTab =
    Window:CreateTab("🎰 AUTO ROLLER", nil)

RollerTab:CreateSection("🎰 Roller Controls")

local AutoRoller = false

local function getRollerPrompt(base)

    if not base then
        return nil
    end

    local roller =
        base:FindFirstChild(
            "Roller",
            true
        )

    if not roller then
        return nil
    end

    local lever =
        roller:FindFirstChild(
            "Lever",
            true
        )

    if not lever then
        return nil
    end

    return lever:FindFirstChildWhichIsA(
        "ProximityPrompt",
        true
    )
end

RollerTab:CreateToggle({
    Name = "🎰 Auto Roller",
    CurrentValue = false,
    Flag = "AutoRoller",

    Callback = function(Value)

        AutoRoller = Value

        if Value then

            task.spawn(function()

                while AutoRoller do

                    local base =
                        getClosestBase()

                    local prompt =
                        getRollerPrompt(base)

                    if base
                        and prompt
                        and prompt.Enabled then

                        -- Roller gets priority
                        takeMovementLock(true)

                        local root = getRoot()

                        local oldCFrame =
                            root.CFrame

                        local part =
                            prompt.Parent

                        if part
                            and part:IsA("BasePart") then

                            teleport(part)

                            task.wait(0.25)

                            if AutoRoller then

                                pcall(function()

                                    fireproximityprompt(
                                        prompt
                                    )

                                end)

                                task.wait(0.5)

                            end

                            -- Return to where we were
                            root.CFrame =
                                oldCFrame

                        end

                        releaseMovementLock(true)

                    else

                        task.wait(0.2)

                    end

                end

            end)

        end

    end,
})

--==================================================
-- ROLLER BUY
--==================================================

local BuyTab =
    Window:CreateTab("🛒 ROLLER BUY", nil)

BuyTab:CreateSection("✨ Rarity Filter")

local SelectedRarities = {
    Common = true,
    Uncommon = true,
    Rare = true,
    Epic = true,
    Legendary = true,
    Mythic = true,
    Secret = true
}

local RarityList = {
    "Common",
    "Uncommon",
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Secret"
}

BuyTab:CreateDropdown({
    Name = "✨ Buy Rarities",
    Options = RarityList,
    CurrentOption = RarityList,
    MultipleOptions = true,
    Flag = "BuyRarities",

    Callback = function(Options)

        SelectedRarities = {}

        for _, rarity in ipairs(Options) do
            SelectedRarities[rarity] = true
        end

    end,
})

local LatestRollResults = {}

local RollerRollEvent =
    ReplicatedStorage:FindFirstChild(
        "RollerRollEvent"
    )

if RollerRollEvent then

    RollerRollEvent.OnClientEvent:Connect(
        function(data)

            if type(data) ~= "table" then
                return
            end

            if not data.results then
                return
            end

            if not data.baseName then
                return
            end

            LatestRollResults[
                data.baseName
            ] = data.results

        end
    )

end

local AutoBuySelected = false

BuyTab:CreateToggle({
    Name = "🛒 Auto Buy Selected Rarities",
    CurrentValue = false,
    Flag = "AutoBuySelected",

    Callback = function(Value)

        AutoBuySelected = Value

        if Value then

            task.spawn(function()

                while AutoBuySelected do

                    local base =
                        getClosestBase()

                    if base then

                        local results =
                            LatestRollResults[
                                base.Name
                            ]

                        if results then

                            for _, result in
                                ipairs(results) do

                                if not AutoBuySelected then
                                    break
                                end

                                if result.rarity
                                    and SelectedRarities[
                                        result.rarity
                                    ]
                                    and result.pedestalName
                                    and result.oreName then

                                    pcall(function()

                                        ReplicatedStorage
                                            .RollerPurchaseEvent
                                            :FireServer(
                                                result.pedestalName,
                                                result.oreName
                                            )

                                    end)

                                    task.wait(0.15)

                                end

                            end

                        end

                    end

                    task.wait(0.5)

                end

            end)

        end

    end,
})

--==================================================
-- AUTO TUNNEL
--==================================================

local TunnelTab =
    Window:CreateTab("🚇 AUTO TUNNEL", nil)

TunnelTab:CreateSection("🚇 Tunnel Controls")

local AutoTunnel = false
local AutoPlace = false

local PurchaseTunnel =
    ReplicatedStorage.Remotes
        .BaseBuildPurchaseTunnel

local EquipOre =
    ReplicatedStorage.Remotes
        .BaseBuildEquipOre

local TunnelNumber = 2
local TunnelName = "Tunnel5"

local PlaceOreName = "Stone Ore"
local PlaceAmount = 1
local PlaceOrder = "4"

TunnelTab:CreateToggle({
    Name = "🚇 Auto Tunnel",
    CurrentValue = false,
    Flag = "AutoTunnel",

    Callback = function(Value)

        AutoTunnel = Value

        if Value then

            task.spawn(function()

                while AutoTunnel do

                    local base =
                        getClosestBase()

                    if base then

                        pcall(function()

                            PurchaseTunnel:InvokeServer(
                                base.Name,
                                TunnelNumber,
                                TunnelName
                            )

                        end)

                    end

                    task.wait(1)

                end

            end)

        end

    end,
})

TunnelTab:CreateSection("🪨 Place Ore")

TunnelTab:CreateInput({
    Name = "🪨 Ore Name",
    CurrentValue = "Stone Ore",
    PlaceholderText = "Stone Ore",
    RemoveTextAfterFocusLost = false,

    Callback = function(Text)

        if Text and Text ~= "" then
            PlaceOreName = Text
        end

    end,
})

TunnelTab:CreateInput({
    Name = "🔢 Order ID",
    CurrentValue = "4",
    PlaceholderText = "4",
    RemoveTextAfterFocusLost = false,

    Callback = function(Text)

        if Text and Text ~= "" then
            PlaceOrder = Text
        end

    end,
})

TunnelTab:CreateToggle({
    Name = "📦 Auto Place",
    CurrentValue = false,
    Flag = "AutoPlace",

    Callback = function(Value)

        AutoPlace = Value

        if Value then

            task.spawn(function()

                while AutoPlace do

                    local base =
                        getClosestBase()

                    if base then

                        pcall(function()

                            EquipOre:InvokeServer(
                                base.Name,
                                TunnelNumber,
                                TunnelName,
                                PlaceOreName,
                                PlaceAmount,
                                PlaceOrder
                            )

                        end)

                    end

                    task.wait(1)

                end

            end)

        end

    end,
})

--==================================================
-- LOADED
--==================================================

Rayfield:Notify({
    Title = "⛏️ SELL ORES 🤑",
    Content = "✅ Loaded successfully! Happy mining! 💎",
    Duration = 4
})
