# ╭─────────────────────────────────────────────────────────────────────────────╮
# │     ✧･ﾟ: *✧･ﾟ:*  WALLPAPER ANIMATOR  *:･ﾟ✧*:･ﾟ✧                           │
# │              Makefile for macOS Intel                                       │
# ╰─────────────────────────────────────────────────────────────────────────────╯

CC = clang
CFLAGS = -Wall -Wextra -O2 -arch x86_64
FRAMEWORKS = \
	-framework Cocoa \
	-framework Foundation \
	-framework QuartzCore \
	-framework CoreGraphics

LIBS = -lm

TARGET = wallpaper_animate
SRC = wallpaper_animate.m

.PHONY: all clean install

all: $(TARGET)

$(TARGET): $(SRC)
	@echo "  Compiling wallpaper animator..."
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) $(FRAMEWORKS) $(LIBS)
	@echo "  Done!"

clean:
	@echo "  Cleaning..."
	rm -f $(TARGET)
	@echo "  Clean!"

install: $(TARGET)
	@echo "  Installing to ~/.config/luvrksnskye/wallpapers/"
	mkdir -p ~/.config/luvrksnskye/wallpapers
	cp $(TARGET) ~/.config/luvrksnskye/wallpapers/
	@echo "  Installed!"
