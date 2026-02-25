local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local MAIN_API_URL = "https://swamm-backend-gsrd.onrender.com"
local FINAL_SCRIPT_URL = "https://raw.githubusercontent.com/swamm-89/swamm_free_guy/refs/heads/main/CoffinGUARD"

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = " CONTROL PANEL",
    LoadingTitle = "SWAMM X FREE GUY",
    LoadingSubtitle = "Verification System",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SWAMM",
        FileName = "Config"
    }
})

-- TAB
local MainTab = Window:CreateTab("Main", 4483362458)

-- Important Note
MainTab:CreateSection("Important Note")

MainTab:CreateLabel("🚫 Do not attempt to kill M3GUN..She is the manager of the hack, and doing so may result in a ban.. 💞 Our hack will always remain free for our valued users ")

local StatusLabel = MainTab:CreateLabel("Status: Send Verify Request")
local StatusDot   = MainTab:CreateLabel("🔴 Not Requested")

-- Check Verification Status Button
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
                Title = "Approved!",
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
                Title = "Rejected",
                Content = "Your verification was rejected.Contact Admin.",
                Duration = 20
            })

        else

            StatusLabel:Set("Status: Waiting for Approval")
            StatusDot:Set("🟡 Pending")

            Rayfield:Notify({
                Title = "Pending",
                Content = "Admin has not approved yet.",
                Duration = 6
            })

        end
    end,
})

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



MainTab:CreateParagraph({
    Title = "Admin ID 💖",
    Content = "Platform: Telegram"
})

MainTab:CreateButton({
    Name = "Copy @zigs_009",
    Callback = function()
        setclipboard("@zigs_009")
    end,
})