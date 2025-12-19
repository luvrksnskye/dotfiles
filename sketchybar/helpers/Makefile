# ╔═══════════════════════════════════════════════════════════════════╗
# ║         🌙 Skye's Animation Helper - Build System 🌙               ║
# ║                                                                    ║
# ║  Pure C implementation - lightweight and fast!                     ║
# ╚═══════════════════════════════════════════════════════════════════╝

CC = clang
CFLAGS = -O2 -Wall -Wextra -std=c11
LDFLAGS = -lpthread -lm

TARGET = skye_animator
SOURCE = skye_animator.c

# Main build target
$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCE) $(LDFLAGS)
	@echo ""
	@echo "✨ Built $(TARGET) successfully!"
	@echo ""

# Debug build with symbols
debug: $(SOURCE)
	$(CC) -g -O0 -Wall -Wextra -std=c11 -o $(TARGET)_debug $(SOURCE) $(LDFLAGS)
	@echo "🔧 Debug build complete"

# Install to sketchybar helpers directory
install: $(TARGET)
	@mkdir -p ~/.config/sketchybar/helpers
	cp $(TARGET) ~/.config/sketchybar/helpers/
	chmod +x ~/.config/sketchybar/helpers/$(TARGET)
	@echo ""
	@echo "✨ Installed to ~/.config/sketchybar/helpers/"
	@echo ""
	@echo "To run as daemon, add to sketchybarrc:"
	@echo '  $$CONFIG_DIR/helpers/skye_animator &'
	@echo ""

# Run the helper
run: $(TARGET)
	./$(TARGET)

# Run as daemon (background)
daemon: $(TARGET)
	./$(TARGET) &
	@echo "🌙 Daemon started in background"

# Clean build artifacts
clean:
	rm -f $(TARGET) $(TARGET)_debug
	@echo "🧹 Cleaned build artifacts"

# Build and install
all: $(TARGET) install

# Help
help:
	@echo "🌙 Skye's Animation Helper"
	@echo ""
	@echo "Usage:"
	@echo "  make          - Build the helper"
	@echo "  make install  - Build and install to ~/.config/sketchybar/helpers/"
	@echo "  make run      - Build and run interactively"
	@echo "  make daemon   - Build and run as background daemon"
	@echo "  make debug    - Build with debug symbols"
	@echo "  make clean    - Remove build artifacts"
	@echo ""
	@echo "Commands (when running interactively):"
	@echo "  pulse <item> <color> [times]  - Pulse animation"
	@echo "  bounce <item>                 - Bounce animation"
	@echo "  glow <item> <color>           - Add glow effect"
	@echo "  unglow <item>                 - Remove glow"
	@echo "  update                        - Force media update"
	@echo ""

.PHONY: install clean all debug run daemon help
