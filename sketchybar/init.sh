#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════╗
# ║                    🌙 SbarLua Initializer 🌙                        ║
# ╚═══════════════════════════════════════════════════════════════════╝

CONFIG_DIR="$HOME/.config/sketchybar"

# Check if SbarLua is installed
if [ ! -f "$CONFIG_DIR/sketchybar.so" ]; then
    echo "⚠️  SbarLua not found. Installing..."
    
    # Try to build SbarLua
    if command -v lua &> /dev/null; then
        git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua 2>/dev/null
        cd /tmp/SbarLua
        make install
        rm -rf /tmp/SbarLua
        echo "✅ SbarLua installed!"
    else
        echo "❌ Lua not found. Please install: brew install lua"
        echo "   Then run: brew services restart sketchybar"
        exit 1
    fi
fi

# Add config dir to LUA_CPATH
export LUA_CPATH="$CONFIG_DIR/?.so"

# Initialize sketchybar
sketchybar --bar height=0

# Run the Lua configuration
cd "$CONFIG_DIR"
lua init.lua &

echo "✨ Skye's Dreamy Bar loaded! ✨"
