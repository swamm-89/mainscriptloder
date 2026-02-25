local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local MAIN_API_URL = "https://swamm-backend-gsrd.onrender.com"  
local FINAL_SCRIPT_URL = "https://raw.githubusercontent.com/swamm-89/swamm_free_guy/refs/heads/main/CoffinGUARD"  -- Tera final script link

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "SWAMM CONTROL PANEL",
    LoadingTitle = "SWAMM",
    LoadingSubtitle = "Verification System",
    ConfigurationSaving = { Enabled = true, FolderName = "SWAMM", FileName = "Config" }
})

local MainTab = Window:CreateTab("Main", 4483362458)

-- Important Note
MainTab:CreateSection("Important Note")
MainTab:CreateLabel("Verification ke liye neeche diye gaye admins se contact karen.")
MainTab:CreateLabel("Sirf trusted admins se baat karen. Fake IDs se bachna.")
MainTab:CreateLabel("Joining ke baad 24 ghante mein verification approve ho jayegi.")

-- Admin Contact IDs
MainTab:CreateSection("Admin Contact IDs (Click to Copy)")

MainTab:CreateParagraph({
    Title = "Admin ID ♥️",
    Content = "Platform: Telegram\nID: @zigs_009"
})

MainTab:CreateButton({
    Name = "Copy @zigs_009",
    Callback = function()
        setclipboard("@zigs_009")
    end,
})

MainTab:CreateParagraph({
    Title = "Admin ID 💞",
    Content = "Platform: Telegram\nID: @pikachu"
})

MainTab:CreateButton({
    Name = "Copy @pikachu",
    Callback = function()
        setclipboard("@pikachu")
    end,
})

-- Verification Section
MainTab:CreateSection("Verification Status")

local StatusLabel = MainTab:CreateLabel("Status: Send Verify Request")
local StatusDot   = MainTab:CreateLabel("🔴 Not Requested")

-- Request Verification Button
MainTab:CreateButton({
    Name = "🔐 Request Verification",
    Callback = function()
        Rayfield:Notify({
            Title = "Request Sent",
            Content = "Waiting for admin approval...",
            Duration = 5
        })

        pcall(function()
            game:HttpGet(MAIN_API_URL .. "/request-verification/" .. player.UserId)
        end)

        StatusLabel:Set("Status: Waiting for Approval")
        StatusDot:Set("🟡 Pending")
    end,
})

-- Check Verification Status Button (Manual Check)
MainTab:CreateButton({
    Name = "🔍 Check Verification Status",
    Callback = function()
        Rayfield:Notify({
            Title = "Checking...",
            Content = "Please wait",
            Duration = 3
        })

        local success, res = pcall(function()
            return game:HttpGet(MAIN_API_URL .. "/check/" .. player.UserId, true)
        end)

        if not success then
            Rayfield:Notify({
                Title = "Error",
                Content = "Server connection failed",
                Duration = 6
            })
            return
        end

        local data = HttpService:JSONDecode(res)

       

        local verified = data.verified or "pending"

        if verified == "approved" then
            StatusLabel:Set("Status: Approved")
            StatusDot:Set("🟢 Approved")
            Rayfield:Notify({
                Title = "✅ Approved!",
                Content = "Loading Full Script...",
                Duration = 5
            })

            pcall(function()
                local finalCode = game:HttpGet(FINAL_SCRIPT_URL, true)
                loadstring(finalCode)()
            end)

        elseif verified == "rejected" then
            StatusLabel:Set("Status: Request Rejected")
            StatusDot:Set("🔴 Rejected")
            Rayfield:Notify({
                Title = "❌ Rejected",
                Content = "Your verification was rejected.\nContact admin.",
                Duration = 10
            })

        else
            StatusLabel:Set("Status: Waiting for Approval")
            StatusDot:Set("🟡 Pending")
            Rayfield:Notify({
                Title = "⏳ Pending",
                Content = "Admin ne abhi approve nahi kiya",
                Duration = 6
            })
        end
    end,
})