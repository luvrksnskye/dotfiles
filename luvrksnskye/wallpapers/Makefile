# ╭─────────────────────────────────────────────────────────────────────────────╮
# │     ✧･ﾟ: *✧･ﾟ:*  WALLPAPER ANIMATOR  *:･ﾟ✧*:･ﾟ✧                           │
# ╰─────────────────────────────────────────────────────────────────────────────╯

UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),arm64)
    ARCH = -arch arm64
else
    ARCH = -arch x86_64
endif

CC = clang
CFLAGS = -Wall -O2 $(ARCH)
FRAMEWORKS = -framework Cocoa -framework QuartzCore -framework CoreGraphics
TARGET = wallpaper_animate
SRC = wallpaper_animate.m
INSTALL_DIR = $(HOME)/.config/luvrksnskye/wallpapers

.PHONY: all clean install

all: $(TARGET)

$(TARGET): $(SRC)
	@echo "  ✧ Building..."
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) $(FRAMEWORKS)
	@echo "  ✧ Done!"

clean:
	rm -f $(TARGET)

install: $(TARGET)
	@mkdir -p $(INSTALL_DIR)
	@cp $(TARGET) wallpaper_*.sh $(INSTALL_DIR)/
	@chmod +x $(INSTALL_DIR)/*
	@echo ""
	@echo "  ✧ Installed to $(INSTALL_DIR)/"
	@echo ""
	@echo "  Add aliases to your shell config:"
	@echo ""
	@echo "    alias wset='$(INSTALL_DIR)/wallpaper_set.sh'"
	@echo "    alias wselect='$(INSTALL_DIR)/wallpaper_select.sh'"
	@echo "    alias wrandom='$(INSTALL_DIR)/wallpaper_random.sh'"
	@echo "    alias wlist='$(INSTALL_DIR)/wallpaper_list.sh'"
	@echo ""
