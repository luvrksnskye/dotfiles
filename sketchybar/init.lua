-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║             🌙 Skye's Dreamy SketchyBar 🌙                         ║
-- ║                                                                    ║
-- ║  Complete macOS menu bar replacement with:                        ║
-- ║  • Functional Control Center items                                ║
-- ║  • Animated Music Player                                          ║
-- ║  • Weather (Caracas timezone)                                     ║
-- ║  • Beautiful Catppuccin Mocha theme                              ║
-- ║                                                                    ║
-- ║              ✨ Made with love for Skye ✨                          ║
-- ╚═══════════════════════════════════════════════════════════════════╝

-- Load SbarLua
local sbar = require("sketchybar")

-- Load configuration modules
local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- ═══════════════════════════════════════════════════════════════════════
--                           BAR CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════

sbar.bar({
    position = "top",
    height = settings.size.bar_height,
    color = colors.bar_bg,
    border_color = colors.bar_border,
    border_width = 1,
    shadow = true,
    corner_radius = 0,  -- Full width bar
    blur_radius = settings.blur.bar,
    padding_left = 12,
    padding_right = 12,
    y_offset = 0,
    margin = 0,
    sticky = true,
    topmost = false,
    notch_width = settings.notch_width,
    font_smoothing = true,
})

-- ═══════════════════════════════════════════════════════════════════════
--                         DEFAULT ITEM SETTINGS
-- ═══════════════════════════════════════════════════════════════════════

sbar.default({
    updates = "when_shown",
    icon = {
        font = {
            family = settings.font.icons,
            style = settings.font.style.bold,
            size = settings.size.icon,
        },
        color = colors.text,
        padding_left = settings.size.padding,
        padding_right = settings.size.padding,
    },
    label = {
        font = {
            family = settings.font.text,
            style = settings.font.style.semibold,
            size = settings.size.label,
        },
        color = colors.subtext1,
        padding_left = settings.size.padding,
        padding_right = settings.size.padding,
    },
    background = {
        color = colors.item_bg,
        corner_radius = settings.size.item_corner_radius,
        height = settings.size.item_height,
        padding_left = 4,
        padding_right = 4,
    },
    popup = {
        background = {
            color = colors.popup.bg,
            corner_radius = settings.size.popup_corner_radius,
            border_width = settings.size.popup_border_width,
            border_color = colors.popup.border,
        },
        blur_radius = settings.blur.popup,
    },
})

-- ═══════════════════════════════════════════════════════════════════════
--                              EVENTS
-- ═══════════════════════════════════════════════════════════════════════

-- Custom events
sbar.add("event", "spotify_change", "com.spotify.client.PlaybackStateChanged")
sbar.add("event", "music_change", "com.apple.Music.playerInfo")
sbar.add("event", "bluetooth_change", "com.apple.bluetooth.status")

-- ═══════════════════════════════════════════════════════════════════════
--                         LEFT SIDE ITEMS
-- ═══════════════════════════════════════════════════════════════════════

-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║                     APPLE MENU (Functional!)                      ║
-- ╚═══════════════════════════════════════════════════════════════════╝

local apple = sbar.add("item", "apple", {
    position = "left",
    icon = {
        string = icons.apple,
        font = { size = 18.0 },
        color = colors.mauve,
    },
    label = { drawing = false },
    background = { drawing = false },
    padding_left = 6,
    padding_right = 2,
})

-- Apple popup menu
local apple_popup = {
    { name = "about", icon = icons.apple, label = "About This Mac", 
      script = "open 'x-apple.systempreferences:com.apple.SystemProfiler.AboutExtension'" },
    { name = "settings", icon = icons.preferences, label = "System Settings...", 
      script = "open 'x-apple.systempreferences:'" },
    { name = "activity", icon = icons.activity, label = "Activity Monitor", 
      script = "open -a 'Activity Monitor'" },
    { name = "divider1", divider = true },
    { name = "sleep", icon = icons.sleep, label = "Sleep", 
      script = "pmset sleepnow" },
    { name = "restart", icon = icons.restart, label = "Restart...", 
      script = "osascript -e 'tell app \"loginwindow\" to «event aevtrrst»'" },
    { name = "shutdown", icon = icons.power, label = "Shut Down...", 
      script = "osascript -e 'tell app \"loginwindow\" to «event aevtrsdn»'" },
    { name = "divider2", divider = true },
    { name = "lock", icon = icons.lock, label = "Lock Screen", 
      script = "pmset displaysleepnow" },
    { name = "logout", icon = icons.logout, label = "Log Out " .. settings.greeting.name .. "...", 
      script = "osascript -e 'tell app \"System Events\" to log out'" },
}

for i, item in ipairs(apple_popup) do
    if item.divider then
        sbar.add("item", "apple." .. item.name, {
            position = "popup.apple",
            icon = { drawing = false },
            label = { drawing = false },
            background = {
                color = colors.surface1,
                height = 1,
                corner_radius = 0,
                padding_left = 8,
                padding_right = 8,
            },
        })
    else
        local popup_item = sbar.add("item", "apple." .. item.name, {
            position = "popup.apple",
            icon = {
                string = item.icon,
                color = item.name == "shutdown" and colors.red or colors.mauve,
            },
            label = {
                string = item.label,
                color = colors.text,
            },
            click_script = item.script .. "; sketchybar --set apple popup.drawing=off",
        })
        
        popup_item:subscribe("mouse.entered", function(env)
            sbar.animate("tanh", 10, function()
                popup_item:set({ background = { color = colors.item_bg_hover } })
            end)
        end)
        
        popup_item:subscribe("mouse.exited", function(env)
            sbar.animate("tanh", 10, function()
                popup_item:set({ background = { color = colors.transparent } })
            end)
        end)
    end
end

apple:subscribe("mouse.clicked", function(env)
    sbar.set("apple", { popup = { drawing = "toggle" } })
end)

-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║                           SPACES                                  ║
-- ╚═══════════════════════════════════════════════════════════════════╝

local spaces = {}
for i = 1, 10 do
    local space = sbar.add("space", "space." .. i, {
        space = i,
        icon = {
            string = icons.spaces[i] or icons.star,
            font = { size = 14.0 },
            color = colors.overlay1,
            highlight_color = colors.mauve,
        },
        label = { drawing = false },
        background = {
            color = colors.transparent,
            corner_radius = 8,
            height = 26,
        },
        padding_left = 4,
        padding_right = 4,
    })
    
    space:subscribe("space_change", function(env)
        local selected = env.SELECTED == "true"
        sbar.animate("tanh", 15, function()
            space:set({
                icon = {
                    highlight = selected,
                    color = selected and colors.mauve or colors.overlay1,
                },
                background = {
                    color = selected and colors.mauve_faded or colors.transparent,
                },
            })
        end)
    end)
    
    -- Click to focus space (works with yabai, Aerospace, or native)
    space:subscribe("mouse.clicked", function(env)
        sbar.exec("yabai -m space --focus " .. i .. " 2>/dev/null || " ..
                  "aerospace workspace " .. i .. " 2>/dev/null || " ..
                  "osascript -e 'tell application \"System Events\" to key code " .. (17 + i) .. " using control down' 2>/dev/null")
    end)
    
    spaces[i] = space
end

-- Spaces bracket
sbar.add("bracket", "spaces_bracket", { "/space\\..*/" }, {
    background = {
        color = colors.item_bg,
        corner_radius = 12,
        height = 30,
    },
})

-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║                         FRONT APP                                 ║
-- ╚═══════════════════════════════════════════════════════════════════╝

local front_app = sbar.add("item", "front_app", {
    position = "left",
    icon = { drawing = false },
    label = {
        string = "Desktop",
        font = { style = settings.font.style.bold, size = 13.0 },
        color = colors.pink,
    },
    background = { drawing = false },
    padding_left = 8,
})

-- Make front_app clickable - opens app's menu
front_app:subscribe("front_app_switched", function(env)
    sbar.animate("tanh", 15, function()
        front_app:set({ label = { string = env.INFO } })
    end)
end)

front_app:subscribe("mouse.clicked", function(env)
    sbar.exec("sketchybar --set apple popup.drawing=toggle")
end)

-- ═══════════════════════════════════════════════════════════════════════
--                          CENTER ITEMS
-- ═══════════════════════════════════════════════════════════════════════

-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║                    MUSIC PLAYER (Animated!) 🎵                    ║
-- ╚═══════════════════════════════════════════════════════════════════╝

-- Music icon (main item)
local music = sbar.add("item", "music", {
    position = "center",
    icon = {
        string = icons.media.spotify,
        font = { size = 18.0 },
        color = colors.green,
    },
    label = {
        string = "Not Playing",
        font = { style = settings.font.style.medium, size = 12.0 },
        color = colors.subtext1,
        max_chars = 40,
    },
    background = {
        color = colors.media_bg,
        corner_radius = 12,
        height = 30,
    },
    padding_left = 8,
    padding_right = 8,
    scroll_texts = true,  -- Enable marquee effect for long titles
})

-- Music popup with controls
local music_cover = sbar.add("item", "music.cover", {
    position = "popup.music",
    icon = { drawing = false },
    label = { drawing = false },
    background = {
        image = { 
            string = "media.artwork",
            scale = 0.6,
        },
        color = colors.surface0,
        corner_radius = 8,
    },
    padding_left = 8,
    padding_right = 8,
})

local music_title = sbar.add("item", "music.title", {
    position = "popup.music",
    icon = { drawing = false },
    label = {
        string = "No Track",
        font = { style = settings.font.style.bold, size = 14.0 },
        color = colors.text,
        max_chars = 30,
    },
    background = { drawing = false },
})

local music_artist = sbar.add("item", "music.artist", {
    position = "popup.music",
    icon = { drawing = false },
    label = {
        string = "Unknown Artist",
        font = { style = settings.font.style.medium, size = 12.0 },
        color = colors.subtext0,
        max_chars = 30,
    },
    background = { drawing = false },
})

-- Control buttons
local controls_holder = sbar.add("item", "music.controls_bg", {
    position = "popup.music",
    icon = { drawing = false },
    label = { drawing = false },
    background = {
        color = colors.surface0,
        corner_radius = 8,
        height = 36,
    },
    width = 150,
})

local music_prev = sbar.add("item", "music.prev", {
    position = "popup.music",
    icon = {
        string = icons.media.prev,
        font = { size = 18.0 },
        color = colors.subtext1,
    },
    label = { drawing = false },
    background = { drawing = false },
    click_script = "nowplaying-cli previous 2>/dev/null || osascript -e 'tell application \"Spotify\" to previous track' 2>/dev/null || osascript -e 'tell application \"Music\" to previous track'",
})

local music_play = sbar.add("item", "music.play", {
    position = "popup.music",
    icon = {
        string = icons.media.play,
        font = { size = 22.0 },
        color = colors.pink,
    },
    label = { drawing = false },
    background = { drawing = false },
    click_script = "nowplaying-cli togglePlayPause 2>/dev/null || osascript -e 'tell application \"Spotify\" to playpause' 2>/dev/null || osascript -e 'tell application \"Music\" to playpause'",
})

local music_next = sbar.add("item", "music.next", {
    position = "popup.music",
    icon = {
        string = icons.media.next,
        font = { size = 18.0 },
        color = colors.subtext1,
    },
    label = { drawing = false },
    background = { drawing = false },
    click_script = "nowplaying-cli next 2>/dev/null || osascript -e 'tell application \"Spotify\" to next track' 2>/dev/null || osascript -e 'tell application \"Music\" to next track'",
})

-- Music update function
local function update_music()
    sbar.exec("nowplaying-cli get title artist playbackRate 2>/dev/null", function(result)
        local lines = {}
        for line in result:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        
        local title = lines[1]
        local artist = lines[2]
        local playing = lines[3] == "1"
        
        if title and title ~= "null" and title ~= "" then
            local display_text = title
            if artist and artist ~= "null" then
                display_text = artist .. " - " .. title
            end
            
            sbar.animate("tanh", 15, function()
                music:set({
                    icon = {
                        string = playing and icons.media.spotify or icons.media.pause,
                        color = playing and colors.green or colors.overlay1,
                    },
                    label = {
                        string = display_text,
                        color = colors.text,
                    },
                })
                
                music_play:set({
                    icon = {
                        string = playing and icons.media.pause or icons.media.play,
                    },
                })
                
                music_title:set({ label = { string = title } })
                music_artist:set({ label = { string = artist or "Unknown" } })
            end)
        else
            -- Fallback to Spotify/Music check
            sbar.exec([[
                osascript -e '
                    if application "Spotify" is running then
                        tell application "Spotify"
                            if player state is playing then
                                return name of current track & "|||" & artist of current track & "|||playing"
                            else
                                return name of current track & "|||" & artist of current track & "|||paused"
                            end if
                        end tell
                    else if application "Music" is running then
                        tell application "Music"
                            if player state is playing then
                                return name of current track & "|||" & artist of current track & "|||playing"
                            else
                                return name of current track & "|||" & artist of current track & "|||paused"
                            end if
                        end tell
                    else
                        return "|||||||none"
                    end if
                ' 2>/dev/null
            ]], function(res)
                local parts = {}
                for part in res:gmatch("[^|||]+") do
                    table.insert(parts, part)
                end
                
                local track = parts[1]
                local artist = parts[2]
                local state = parts[3]
                
                if track and track ~= "" then
                    local playing = state:find("playing")
                    local display = artist .. " - " .. track
                    
                    sbar.animate("tanh", 15, function()
                        music:set({
                            icon = {
                                string = playing and icons.media.spotify or icons.media.pause,
                                color = playing and colors.green or colors.overlay1,
                            },
                            label = {
                                string = display,
                                color = colors.text,
                            },
                        })
                        
                        music_play:set({
                            icon = { string = playing and icons.media.pause or icons.media.play },
                        })
                        
                        music_title:set({ label = { string = track } })
                        music_artist:set({ label = { string = artist } })
                    end)
                else
                    music:set({
                        icon = { string = icons.media.music, color = colors.overlay1 },
                        label = { string = "Not Playing", color = colors.subtext0 },
                    })
                end
            end)
        end
    end)
end

-- Subscribe to music events
music:subscribe({ "spotify_change", "music_change", "media_change", "routine" }, function(env)
    update_music()
end)

music:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "left" then
        sbar.set("music", { popup = { drawing = "toggle" } })
    elseif env.BUTTON == "right" then
        -- Right click: play/pause
        sbar.exec("nowplaying-cli togglePlayPause 2>/dev/null || osascript -e 'tell application \"Spotify\" to playpause'")
        update_music()
    end
end)

-- Hover effects on controls
for _, ctrl in ipairs({ music_prev, music_play, music_next }) do
    ctrl:subscribe("mouse.entered", function(env)
        sbar.animate("tanh", 10, function()
            ctrl:set({ icon = { color = colors.pink } })
        end)
    end)
    
    ctrl:subscribe("mouse.exited", function(env)
        local default_color = ctrl == music_play and colors.pink or colors.subtext1
        sbar.animate("tanh", 10, function()
            ctrl:set({ icon = { color = default_color } })
        end)
    end)
end

-- Initial update
sbar.exec("sleep 1 && sketchybar --trigger routine")

-- ═══════════════════════════════════════════════════════════════════════
--                          RIGHT SIDE ITEMS
-- ═══════════════════════════════════════════════════════════════════════

-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║                       CLOCK (Caracas Time)                        ║
-- ╚═══════════════════════════════════════════════════════════════════╝

local clock = sbar.add("item", "clock", {
    position = "right",
    icon = {
        string = icons.clock,
        color = colors.lavender,
        font = { size = 16.0 },
    },
    label = {
        string = "--:--",
        font = { family = settings.font.numbers, style = settings.font.style.bold, size = 13.0 },
        color = colors.text,
    },
    background = {
        color = colors.item_bg,
        corner_radius = 10,
    },
    update_freq = settings.update_freq.clock,
    padding_right = 6,
})

clock:subscribe({ "routine", "forced" }, function(env)
    -- Caracas timezone (VET = UTC-4)
    sbar.exec("TZ='America/Caracas' date '+%a %d %b  %H:%M'", function(time)
        clock:set({ label = { string = time:gsub("\n", "") } })
    end)
end)

clock:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a Calendar")
end)

-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║                    WEATHER (Caracas, Venezuela)                   ║
-- ╚═══════════════════════════════════════════════════════════════════╝

local weather = sbar.add("item", "weather", {
    position = "right",
    icon = {
        string = icons.weather.clear,
        color = colors.sky,
        font = { size = 16.0 },
    },
    label = {
        string = "--°",
        color = colors.text,
    },
    background = {
        color = colors.item_bg,
        corner_radius = 10,
    },
    update_freq = settings.update_freq.weather,
})

local function get_weather_icon(condition)
    condition = condition:lower()
    if condition:find("clear") or condition:find("sunny") then
        return icons.weather.clear, colors.yellow
    elseif condition:find("partly") then
        return icons.weather.partly_cloudy, colors.sky
    elseif condition:find("cloud") or condition:find("overcast") then
        return icons.weather.cloudy, colors.overlay2
    elseif condition:find("rain") or condition:find("drizzle") then
        return icons.weather.rain, colors.blue
    elseif condition:find("thunder") or condition:find("storm") then
        return icons.weather.thunder, colors.mauve
    elseif condition:find("snow") then
        return icons.weather.snow, colors.text
    elseif condition:find("fog") or condition:find("mist") then
        return icons.weather.fog, colors.overlay1
    else
        return icons.weather.unknown, colors.sky
    end
end

weather:subscribe({ "routine", "forced", "system_woke" }, function(env)
    sbar.exec("curl -s 'wttr.in/" .. settings.location.query .. "?format=%C|%t' 2>/dev/null", function(result)
        if result and result ~= "" then
            local condition, temp = result:match("([^|]+)|([^|]+)")
            if condition and temp then
                condition = condition:gsub("^%s+", ""):gsub("%s+$", "")
                temp = temp:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%+", "")
                
                local icon, color = get_weather_icon(condition)
                
                sbar.animate("tanh", 15, function()
                    weather:set({
                        icon = { string = icon, color = color },
                        label = { string = temp },
                    })
                end)
            end
        end
    end)
end)

weather:subscribe("mouse.clicked", function(env)
    sbar.exec("open 'https://wttr.in/" .. settings.location.query .. "'")
end)

-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║                    CONTROL CENTER ITEMS                           ║
-- ╚═══════════════════════════════════════════════════════════════════╝

-- Battery (Functional - shows details on click)
local battery = sbar.add("item", "battery", {
    position = "right",
    icon = {
        string = icons.battery._100,
        color = colors.green,
        font = { size = 16.0 },
    },
    label = {
        string = "--%",
        color = colors.text,
    },
    background = {
        color = colors.item_bg,
        corner_radius = 10,
    },
    update_freq = settings.update_freq.battery,
})

battery:subscribe({ "routine", "forced", "system_woke", "power_source_change" }, function(env)
    sbar.exec("pmset -g batt", function(result)
        local percent = result:match("(%d+)%%")
        local charging = result:find("AC Power")
        
        if percent then
            percent = tonumber(percent)
            local icon, color
            
            if charging then
                icon = icons.battery.charging
                color = colors.lavender
            elseif percent > 80 then
                icon = icons.battery._100
                color = colors.green
            elseif percent > 60 then
                icon = icons.battery._80
                color = colors.green
            elseif percent > 40 then
                icon = icons.battery._60
                color = colors.yellow
            elseif percent > 20 then
                icon = icons.battery._40
                color = colors.peach
            elseif percent > 10 then
                icon = icons.battery._20
                color = colors.red
            else
                icon = icons.battery._10
                color = colors.red
            end
            
            sbar.animate("tanh", 15, function()
                battery:set({
                    icon = { string = icon, color = color },
                    label = { string = percent .. "%" },
                })
            end)
        end
    end)
end)

battery:subscribe("mouse.clicked", function(env)
    sbar.exec("open 'x-apple.systempreferences:com.apple.preference.battery'")
end)

-- WiFi (Functional - opens WiFi settings)
local wifi = sbar.add("item", "wifi", {
    position = "right",
    icon = {
        string = icons.wifi.connected,
        color = colors.teal,
        font = { size = 16.0 },
    },
    label = { drawing = false },
    background = {
        color = colors.item_bg,
        corner_radius = 10,
    },
    update_freq = settings.update_freq.wifi,
})

wifi:subscribe({ "routine", "forced", "wifi_change" }, function(env)
    sbar.exec("networksetup -getairportnetwork en0 2>/dev/null | cut -d: -f2", function(ssid)
        if ssid and ssid:gsub("%s+", "") ~= "" then
            sbar.animate("tanh", 10, function()
                wifi:set({
                    icon = { string = icons.wifi.connected, color = colors.teal },
                })
            end)
        else
            wifi:set({
                icon = { string = icons.wifi.disconnected, color = colors.overlay1 },
            })
        end
    end)
end)

wifi:subscribe("mouse.clicked", function(env)
    sbar.exec("open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi'")
end)

-- Bluetooth (Functional)
local bluetooth = sbar.add("item", "bluetooth", {
    position = "right",
    icon = {
        string = icons.bluetooth.on,
        color = colors.blue,
        font = { size = 14.0 },
    },
    label = { drawing = false },
    background = {
        color = colors.item_bg,
        corner_radius = 10,
    },
})

bluetooth:subscribe({ "routine", "forced", "bluetooth_change" }, function(env)
    sbar.exec("blueutil --power 2>/dev/null || echo 1", function(state)
        local is_on = state:gsub("%s+", "") == "1"
        bluetooth:set({
            icon = {
                string = is_on and icons.bluetooth.on or icons.bluetooth.off,
                color = is_on and colors.blue or colors.overlay1,
            },
        })
    end)
end)

bluetooth:subscribe("mouse.clicked", function(env)
    sbar.exec("open 'x-apple.systempreferences:com.apple.preference.Bluetooth'")
end)

-- Volume (Functional with slider on click)
local volume = sbar.add("item", "volume", {
    position = "right",
    icon = {
        string = icons.volume.high,
        color = colors.peach,
        font = { size = 16.0 },
    },
    label = { drawing = false },
    background = {
        color = colors.item_bg,
        corner_radius = 10,
    },
})

volume:subscribe("volume_change", function(env)
    local vol = tonumber(env.INFO) or 0
    local icon, color
    
    if vol >= 66 then
        icon = icons.volume.high
        color = colors.peach
    elseif vol >= 33 then
        icon = icons.volume.mid
        color = colors.peach
    elseif vol > 0 then
        icon = icons.volume.low
        color = colors.yellow
    else
        icon = icons.volume.mute
        color = colors.overlay1
    end
    
    sbar.animate("tanh", 10, function()
        volume:set({
            icon = { string = icon, color = color },
            label = { string = vol .. "%", drawing = true },
        })
    end)
    
    -- Hide label after 2 seconds
    sbar.exec("sleep 2 && sketchybar --set volume label.drawing=off &")
end)

volume:subscribe("mouse.clicked", function(env)
    sbar.exec("open 'x-apple.systempreferences:com.apple.preference.sound'")
end)

-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║                     STATUS ICONS BRACKET                          ║
-- ╚═══════════════════════════════════════════════════════════════════╝

sbar.add("bracket", "status_bracket", { "clock", "weather", "battery", "wifi", "bluetooth", "volume" }, {
    background = {
        color = colors.transparent,
        corner_radius = 12,
        height = 32,
    },
})

-- ═══════════════════════════════════════════════════════════════════════
--                      GREETING (Optional cute touch)
-- ═══════════════════════════════════════════════════════════════════════

-- Uncomment to show a greeting based on time of day
--[[
local function get_greeting()
    local hour = tonumber(os.date("%H"))
    if hour >= 5 and hour < 12 then
        return settings.greeting.morning .. ", " .. settings.greeting.name .. " ✨"
    elseif hour >= 12 and hour < 17 then
        return settings.greeting.afternoon .. ", " .. settings.greeting.name .. " 🌤"
    elseif hour >= 17 and hour < 21 then
        return settings.greeting.evening .. ", " .. settings.greeting.name .. " 🌙"
    else
        return settings.greeting.night .. ", " .. settings.greeting.name .. " 💜"
    end
end
]]--

-- ═══════════════════════════════════════════════════════════════════════
--                         FINAL INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════

-- Enable hot reload
sbar.hotload(true)

-- Trigger initial updates
sbar.trigger("forced")

-- Print startup message
print("")
print("╔═══════════════════════════════════════════════════════════════╗")
print("║                                                               ║")
print("║        ✨ Skye's Dreamy Bar has loaded! ✨                    ║")
print("║                                                               ║")
print("║  🌙 Caracas Time  •  🎵 Music Player  •  💜 Made for Skye    ║")
print("║                                                               ║")
print("╚═══════════════════════════════════════════════════════════════╝")
print("")
