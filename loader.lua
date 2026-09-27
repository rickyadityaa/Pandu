if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE = "https://raw.githubusercontent.com/rickyadityaa/Pandu/refs/heads/main/Games/"

local PANDU_GAMES = {
    [124216119978534] = "Ride%20a%20pet.lua",
}

local PANDU_CREATORS = {
}

local function notify(title, msg, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = tostring(title or "Pandu Hub"),
            Text = tostring(msg or ""),
            Duration = tonumber(dur) or 3,
        })
    end)
end

local function getScriptFile()
    return PANDU_GAMES[game.PlaceId] or PANDU_CREATORS[game.CreatorId]
end

local function main()
    local file = getScriptFile()
    if not file then
        notify("Pandu Hub", "Game tidak didukung", 4)
        return
    end

    local url = BASE .. file
    local okFetch, src = pcall(function()
        return game:HttpGet(url)
    end)

    if not okFetch or type(src) ~= "string" or src == "" then
        notify("Pandu Hub", "Gagal download script: " .. tostring(src), 4)
        return
    end

    if #src < 100 then
        notify("Pandu Hub", "Script terlalu kecil, kemungkinan 404", 4)
        return
    end

    local fn, compileErr = loadstring(src)
    if not fn then
        notify("Pandu Hub", "Syntax error: " .. tostring(compileErr), 5)
        warn("[Pandu Hub Loader] Compile error:", tostring(compileErr))
        return
    end

    local okRun, runtimeErr = pcall(fn)
    if not okRun then
        notify("Pandu Hub", "Runtime error, cek console", 5)
        warn("[Pandu Hub Loader] Runtime error:", tostring(runtimeErr))
        return
    end
end

main()