-- ╔═══════════════════════════════════════════════════════════════════╗
-- ║         🌙 Skye's Dreamy Catppuccin Mocha Palette 🌙               ║
-- ║                                                                    ║
-- ║              ✨ Made with love for Skye ✨                          ║
-- ╚═══════════════════════════════════════════════════════════════════╝

local M = {}

-- Helper functions
M.hex = function(color)
    return "0xff" .. string.sub(color, 2)
end

M.with_alpha = function(color, alpha)
    if type(color) == "string" and color:sub(1, 1) == "#" then
        return string.format("0x%02x%s", math.floor(alpha * 255), color:sub(2))
    elseif type(color) == "string" and color:sub(1, 2) == "0x" then
        return string.format("0x%02x%s", math.floor(alpha * 255), color:sub(5))
    end
    return color
end

-- ═══════════════════════════════════════════════════════════════════════
--                      CATPPUCCIN MOCHA PALETTE
-- ═══════════════════════════════════════════════════════════════════════

-- Base colors (the cozy dark foundation)
M.crust = M.hex("#11111b")
M.mantle = M.hex("#181825")
M.base = M.hex("#1e1e2e")

-- Surface colors (layered elements)
M.surface0 = M.hex("#313244")
M.surface1 = M.hex("#45475a")
M.surface2 = M.hex("#585b70")

-- Overlay colors (subtle accents)
M.overlay0 = M.hex("#6c7086")
M.overlay1 = M.hex("#7f849c")
M.overlay2 = M.hex("#9399b2")

-- Text colors
M.subtext0 = M.hex("#a6adc8")
M.subtext1 = M.hex("#bac2de")
M.text = M.hex("#cdd6f4")

-- ═══════════════════════════════════════════════════════════════════════
--                    ACCENT COLORS (The Dreamy Pastels ✨)
-- ═══════════════════════════════════════════════════════════════════════

M.rosewater = M.hex("#f5e0dc")
M.flamingo = M.hex("#f2cdcd")
M.pink = M.hex("#f5c2e7")
M.mauve = M.hex("#cba6f7")
M.red = M.hex("#f38ba8")
M.maroon = M.hex("#eba0ac")
M.peach = M.hex("#fab387")
M.yellow = M.hex("#f9e2af")
M.green = M.hex("#a6e3a1")
M.teal = M.hex("#94e2d5")
M.sky = M.hex("#89dceb")
M.sapphire = M.hex("#74c7ec")
M.blue = M.hex("#89b4fa")
M.lavender = M.hex("#b4befe")

-- ═══════════════════════════════════════════════════════════════════════
--                     TRANSPARENT VARIANTS (Glass Effect)
-- ═══════════════════════════════════════════════════════════════════════

M.transparent = "0x00000000"

-- Bar background (dreamy glass effect)
M.bar_bg = M.with_alpha("#1e1e2e", 0.85)
M.bar_border = M.with_alpha("#cba6f7", 0.3)

-- Item backgrounds
M.item_bg = M.with_alpha("#313244", 0.6)
M.item_bg_hover = M.with_alpha("#45475a", 0.8)

-- Accent transparents (for highlights)
M.mauve_faded = M.with_alpha("#cba6f7", 0.3)
M.pink_faded = M.with_alpha("#f5c2e7", 0.3)
M.lavender_faded = M.with_alpha("#b4befe", 0.3)
M.sky_faded = M.with_alpha("#89dceb", 0.3)
M.green_faded = M.with_alpha("#a6e3a1", 0.3)
M.peach_faded = M.with_alpha("#fab387", 0.3)

-- ═══════════════════════════════════════════════════════════════════════
--                      POPUP CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════

M.popup = {
    bg = M.with_alpha("#181825", 0.95),
    border = M.mauve,
}

-- ═══════════════════════════════════════════════════════════════════════
--                      SPOTIFY / MEDIA COLORS
-- ═══════════════════════════════════════════════════════════════════════

M.spotify_green = M.hex("#1db954")
M.media_bg = M.with_alpha("#313244", 0.8)
M.media_playing = M.pink
M.media_paused = M.overlay1

-- ═══════════════════════════════════════════════════════════════════════
--                      SKYE'S SPECIAL COLORS 💜
-- ═══════════════════════════════════════════════════════════════════════

-- Personal accent (you can change this to your favorite!)
M.skye_accent = M.mauve
M.skye_secondary = M.pink
M.skye_glow = M.with_alpha("#cba6f7", 0.5)

return M
