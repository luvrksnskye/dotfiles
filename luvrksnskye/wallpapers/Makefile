CC = clang
CFLAGS = -Wall -Wextra -O2
FRAMEWORKS = \
	-framework Cocoa \
	-framework Foundation \
	-framework QuartzCore \
	-framework CoreGraphics

LIBS = -lm

TARGET = wallpaper_animate
SRC = wallpaper_animate.m

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET) $(FRAMEWORKS) $(LIBS)

clean:
	rm -f $(TARGET)
