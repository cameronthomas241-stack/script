local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Anime jackpot rng",
    Icon = 0,
    LoadingTitle = "loading...",
    LoadingSubtitle = "by arcane",
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
        Enabled = true,
        Invite = "https://discord.gg/T85HQvySQ",
        RememberJoins = true
    },

    KeySystem = false
})

-- SERVICES

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer


-- MAIN TAB

local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main")


-- AUTO COLLECT 1-30

local AutoCollect = false
local CollectThread = nil

local function getMyPlot()
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")

    local closestPlot = nil
    local closestDistance = math.huge

    for _, plot in ipairs(workspace.Plots:GetChildren()) do
        local slots = plot:FindFirstChild("Slots")

        if slots then
            for _, slot in ipairs(slots:GetChildren()) do
                local part = slot:FindFirstChildWhichIsA("BasePart", true)

                if part then
                    local distance = (root.Position - part.Position).Magnitude

                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlot = plot
                    end
                end
            end
        end
    end

    return closestPlot
end

local function collectAll()
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    local plot = getMyPlot()

    if not plot then
        warn("Could not detect your plot")
        return
    end

    -- FLOOR 1: SLOTS 1-10

    local Slots = plot:FindFirstChild("Slots")

    if Slots then
        for i = 1, 10 do
            if not AutoCollect then
                return
            end

            local Slot = Slots:FindFirstChild("Slot " .. i)

            if Slot then
                local CollectButton = Slot:FindFirstChild("CollectButton")

                if CollectButton then
                    root.CFrame = CollectButton:GetPivot() + Vector3.new(0, 3, 0)
                    task.wait(0.5)
                end
            end
        end
    end

    -- FLOOR 2: SLOTS 11-20

    local SecondFloor = plot:FindFirstChild("Second Floor")

    if SecondFloor then
        local SecondSlots = SecondFloor:FindFirstChild("Slots")

        if SecondSlots then
            for i = 11, 20 do
                if not AutoCollect then
                    return
                end

                local Slot = SecondSlots:FindFirstChild("Slot " .. i)

                if Slot then
                    local CollectButton = Slot:FindFirstChild("CollectButton")

                    if CollectButton then
                        root.CFrame = CollectButton:GetPivot() + Vector3.new(0, 3, 0)
                        task.wait(0.5)
                    end
                end
            end
        end
    end

    -- FLOOR 3: SLOTS 21-30

    local ThirdFloor = plot:FindFirstChild("Third Floor")

    if ThirdFloor then
        local ThirdSlots = ThirdFloor:FindFirstChild("Slots")

        if ThirdSlots then
            for i = 21, 30 do
                if not AutoCollect then
                    return
                end

                local Slot = ThirdSlots:FindFirstChild("Slot " .. i)

                if Slot then
                    local CollectButton = Slot:FindFirstChild("CollectButton")

                    if CollectButton then
                        root.CFrame = CollectButton:GetPivot() + Vector3.new(0, 3, 0)
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end

MainTab:CreateToggle({
    Name = "Auto collect",
    CurrentValue = false,
    Flag = "AutoCollect",

    Callback = function(Value)
        AutoCollect = Value

        if Value then
            if CollectThread then
                return
            end

            CollectThread = task.spawn(function()
                while AutoCollect do
                    collectAll()

                    if AutoCollect then
                        task.wait(0.5)
                    end
                end

                CollectThread = nil
            end)
        else
            AutoCollect = false
        end
    end
})


-- AUTO MATERIALS

local AutoMaterials = false
local MaterialsThread = nil

local PurchaseMaterial = ReplicatedStorage.Remotes.PurchaseMaterial

MainTab:CreateToggle({
    Name = "Auto materials",
    CurrentValue = false,
    Flag = "AutoMaterials",

    Callback = function(Value)
        AutoMaterials = Value

        if Value then
            if MaterialsThread then
                return
            end

            MaterialsThread = task.spawn(function()
                while AutoMaterials do
                    PurchaseMaterial:FireServer("MaxAll")
                    task.wait(30)
                end

                MaterialsThread = nil
            end)
        else
            AutoMaterials = false
        end
    end
})


-- AUTO CLAIM INDEX

local AutoClaimIndex = false
local ClaimIndexThread = nil

local ClaimAllIndex = ReplicatedStorage.Remotes.ClaimAllIndex

MainTab:CreateToggle({
    Name = "Auto claim index",
    CurrentValue = false,
    Flag = "AutoClaimIndex",

    Callback = function(Value)
        AutoClaimIndex = Value

        if Value then
            if ClaimIndexThread then
                return
            end

            ClaimIndexThread = task.spawn(function()
                while AutoClaimIndex do
                    ClaimAllIndex:FireServer()
                    task.wait(30)
                end

                ClaimIndexThread = nil
            end)
        else
            AutoClaimIndex = false
        end
    end
})


-- BUY ALL SLOTS

local RepairSlot = ReplicatedStorage.Remotes.RepairSlot

MainTab:CreateButton({
    Name = "Buy All Slots Floor 1",

    Callback = function()
        local slots = {4, 5, 6, 7, 9, 10}

        for _, slotNumber in ipairs(slots) do
            RepairSlot:FireServer(slotNumber)
            task.wait(0.2)
        end
    end
})

MainTab:CreateButton({
    Name = "Buy All Floor 2 Slots",

    Callback = function()
        local slots = {11, 12, 14, 15, 16, 17, 19, 20}

        for _, slotNumber in ipairs(slots) do
            RepairSlot:FireServer(slotNumber)
            task.wait(0.2)
        end
    end
})

MainTab:CreateButton({
    Name = "Buy All Slots",

    Callback = function()
        local slots = {
            4, 5, 6, 7, 9, 10,
            11, 12, 14, 15, 16, 17, 19, 20,
            21, 22, 24, 25, 26, 27, 29, 30
        }

        for _, slotNumber in ipairs(slots) do
            RepairSlot:FireServer(slotNumber)
            task.wait(0.2)
        end
    end
})


-- AUTO EQUIP BEST

local AutoEquipBest = false
local EquipBestThread = nil

local EquipBest = ReplicatedStorage.Remotes.EquipBest

MainTab:CreateToggle({
    Name = "Auto Equip Best",
    CurrentValue = false,
    Flag = "AutoEquipBest",

    Callback = function(Value)
        AutoEquipBest = Value

        if Value then
            if EquipBestThread then
                return
            end

            EquipBestThread = task.spawn(function()
                while AutoEquipBest do
                    EquipBest:FireServer()
                    task.wait(300)
                end

                EquipBestThread = nil
            end)
        else
            AutoEquipBest = false
        end
    end
})

MainTab:CreateParagraph({
    Title = "Auto Equip Best",
    Content = "This will auto equip your best units every 5 minutes."
})


-- ANTI AFK

local AntiAFK = false
local AntiAFKThread = nil

MainTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",

    Callback = function(Value)
        AntiAFK = Value

        if Value then
            if AntiAFKThread then
                return
            end

            AntiAFKThread = task.spawn(function()
                while AntiAFK do
                    VirtualInputManager:SendKeyEvent(
                        true,
                        Enum.KeyCode.LeftControl,
                        false,
                        game
                    )

                    task.wait(0.1)

                    VirtualInputManager:SendKeyEvent(
                        false,
                        Enum.KeyCode.LeftControl,
                        false,
                        game
                    )

                    task.wait(60)
                end

                AntiAFKThread = nil
            end)
        else
            AntiAFK = false
        end
    end
})


-- UPGRADES TAB

local UpgradesTab = Window:CreateTab("Upgrades", nil)
local UpgradesSection = UpgradesTab:CreateSection("Upgrades")

local BuyUpgrade = ReplicatedStorage.Remotes.BuyUpgrade


-- AUTO LUCK I

local AutoLuckI = false
local LuckIThread = nil

UpgradesTab:CreateToggle({
    Name = "Auto Luck I",
    CurrentValue = false,
    Flag = "AutoLuckI",

    Callback = function(Value)
        AutoLuckI = Value

        if Value then
            if LuckIThread then
                return
            end

            LuckIThread = task.spawn(function()
                while AutoLuckI do
                    BuyUpgrade:FireServer("Luck I")
                    task.wait(0.5)
                end

                LuckIThread = nil
            end)
        else
            AutoLuckI = false
        end
    end
})


-- AUTO YEN

local AutoYen = false
local YenThread = nil

UpgradesTab:CreateToggle({
    Name = "Auto Yen",
    CurrentValue = false,
    Flag = "AutoYen",

    Callback = function(Value)
        AutoYen = Value

        if Value then
            if YenThread then
                return
            end

            YenThread = task.spawn(function()
                while AutoYen do
                    BuyUpgrade:FireServer("Yen")
                    task.wait(0.5)
                end

                YenThread = nil
            end)
        else
            AutoYen = false
        end
    end
})


-- AUTO FRIEND LUCK

local AutoFriendLuck = false
local FriendLuckThread = nil

UpgradesTab:CreateToggle({
    Name = "Auto Friend Luck",
    CurrentValue = false,
    Flag = "AutoFriendLuck",

    Callback = function(Value)
        AutoFriendLuck = Value

        if Value then
            if FriendLuckThread then
                return
            end

            FriendLuckThread = task.spawn(function()
                while AutoFriendLuck do
                    BuyUpgrade:FireServer("Friend Luck")
                    task.wait(0.5)
                end

                FriendLuckThread = nil
            end)
        else
            AutoFriendLuck = false
        end
    end
})


-- AUTO OFFLINE TIME

local AutoOfflineTime = false
local OfflineTimeThread = nil

UpgradesTab:CreateToggle({
    Name = "Auto Offline Time",
    CurrentValue = false,
    Flag = "AutoOfflineTime",

    Callback = function(Value)
        AutoOfflineTime = Value

        if Value then
            if OfflineTimeThread then
                return
            end

            OfflineTimeThread = task.spawn(function()
                while AutoOfflineTime do
                    BuyUpgrade:FireServer("Offline Time")
                    task.wait(0.5)
                end

                OfflineTimeThread = nil
            end)
        else
            AutoOfflineTime = false
        end
    end
})


-- PERFORMANCE TAB

local PerformanceTab = Window:CreateTab("Performance", nil)
local PerformanceSection = PerformanceTab:CreateSection("Performance")


-- 3D RENDERING

PerformanceTab:CreateToggle({
    Name = "3D Rendering",
    CurrentValue = true,
    Flag = "3DRendering",

    Callback = function(Value)
        RunService:Set3dRenderingEnabled(Value)
    end
})


-- FPS BOOSTER

local FPSBooster = false
local SavedObjects = {}
local SavedLighting = {}
local FPSDescendantConnection = nil

local function SaveAndDisableObject(obj)
    if SavedObjects[obj] ~= nil then
        return
    end

    if obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Beam")
        or obj:IsA("Smoke")
        or obj:IsA("Fire")
        or obj:IsA("Sparkles") then

        SavedObjects[obj] = obj.Enabled
        obj.Enabled = false

    elseif obj:IsA("BloomEffect")
        or obj:IsA("BlurEffect")
        or obj:IsA("ColorCorrectionEffect")
        or obj:IsA("DepthOfFieldEffect")
        or obj:IsA("SunRaysEffect") then

        SavedObjects[obj] = obj.Enabled
        obj.Enabled = false

    elseif obj:IsA("BasePart") then

        SavedObjects[obj] = {
            Material = obj.Material,
            CastShadow = obj.CastShadow
        }

        obj.Material = Enum.Material.SmoothPlastic
        obj.CastShadow = false
    end
end

local function EnableFPSBoost()
    if FPSBooster then
        return
    end

    FPSBooster = true

    -- Save Lighting settings
    SavedLighting.GlobalShadows = Lighting.GlobalShadows
    SavedLighting.FogEnd = Lighting.FogEnd
    SavedLighting.Brightness = Lighting.Brightness

    -- Lower lighting workload
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 500
    Lighting.Brightness = 1

    -- Disable current visual effects
    for _, obj in ipairs(game:GetDescendants()) do
        SaveAndDisableObject(obj)
    end

    -- Automatically handle new objects created while enabled
    if FPSDescendantConnection then
        FPSDescendantConnection:Disconnect()
    end

    FPSDescendantConnection = game.DescendantAdded:Connect(function(obj)
        if FPSBooster then
            task.defer(function()
                if FPSBooster and obj and obj.Parent then
                    SaveAndDisableObject(obj)
                end
            end)
        end
    end)
end

local function DisableFPSBoost()
    if not FPSBooster then
        return
    end

    FPSBooster = false

    -- Stop monitoring new objects
    if FPSDescendantConnection then
        FPSDescendantConnection:Disconnect()
        FPSDescendantConnection = nil
    end

    -- Restore Lighting
    if SavedLighting.GlobalShadows ~= nil then
        Lighting.GlobalShadows = SavedLighting.GlobalShadows
    end

    if SavedLighting.FogEnd ~= nil then
        Lighting.FogEnd = SavedLighting.FogEnd
    end

    if SavedLighting.Brightness ~= nil then
        Lighting.Brightness = SavedLighting.Brightness
    end

    -- Restore objects
    for obj, savedValue in pairs(SavedObjects) do
        if obj and obj.Parent then

            if obj:IsA("BasePart") then
                obj.Material = savedValue.Material
                obj.CastShadow = savedValue.CastShadow

            elseif obj:IsA("ParticleEmitter")
                or obj:IsA("Trail")
                or obj:IsA("Beam")
                or obj:IsA("Smoke")
                or obj:IsA("Fire")
                or obj:IsA("Sparkles")
                or obj:IsA("BloomEffect")
                or obj:IsA("BlurEffect")
                or obj:IsA("ColorCorrectionEffect")
                or obj:IsA("DepthOfFieldEffect")
                or obj:IsA("SunRaysEffect") then

                obj.Enabled = savedValue
            end
        end
    end

    SavedObjects = {}
    SavedLighting = {}
end


PerformanceTab:CreateToggle({
    Name = "FPS Booster",
    CurrentValue = false,
    Flag = "FPSBooster",

    Callback = function(Value)
        if Value then
            EnableFPSBoost()
        else
            DisableFPSBoost()
        end
    end
})


PerformanceTab:CreateParagraph({
    Title = "FPS Booster",
    Content = "Lowers visual quality by disabling shadows, particles, effects, and detailed materials."
})
