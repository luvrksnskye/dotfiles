CC = clang
CFLAGS = -Wall -Wextra -O2
FRAMEWORKS = -framework Cocoa -framework ScreenCaptureKit -framework CoreGraphics

TARGET = wallpaper_animate
SRC = wallpaper_animate.m
OBJ = $(SRC:.m=.o)

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $(FRAMEWORKS) -o $@

%.o: %.m
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)

.PHONY: all clean
