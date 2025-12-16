#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <Cocoa/Cocoa.h>
#include <CoreGraphics/CoreGraphics.h>

typedef enum {
    TRANSITION_WAVE,
    TRANSITION_FADE,
    TRANSITION_GROW,
    TRANSITION_LIQUID,
    TRANSITION_SPIRAL,
    TRANSITION_FOLD
} TransitionType;

TransitionType parseTransition(const char *str) {
    if (!str) return TRANSITION_WAVE;
    if (strcmp(str, "fade") == 0) return TRANSITION_FADE;
    if (strcmp(str, "grow") == 0) return TRANSITION_GROW;
    if (strcmp(str, "liquid") == 0) return TRANSITION_LIQUID;
    if (strcmp(str, "spiral") == 0) return TRANSITION_SPIRAL;
    if (strcmp(str, "fold") == 0) return TRANSITION_FOLD;
    return TRANSITION_WAVE;
}

double getDuration(TransitionType type) {
    switch (type) {
        case TRANSITION_WAVE:      return 0.8;
        case TRANSITION_FADE:     return 0.7;
        case TRANSITION_GROW:     return 1.0;
        case TRANSITION_LIQUID:   return 0.85;
        case TRANSITION_SPIRAL:   return 1.2;
        case TRANSITION_FOLD:     return 0.9;
        default:                  return 0.8;
    }
}

int setWallpaper(const char *path) {
    char cmd[2048];
    snprintf(cmd, sizeof(cmd),
        "osascript -e 'tell application \"System Events\" to tell every desktop to set picture to \"%s\"'",
        path);
    return system(cmd) == 0 ? 0 : -1;
}

void animateFade(const char *path, double duration) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSScreen *mainScreen = [NSScreen mainScreen];
    NSRect screenFrame = [mainScreen frame];
    
    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask: NSBorderlessWindowMask
        backing:NSBackingStoreBuffered
        defer:NO];
    
    [window setLevel:NSScreenSaverWindowLevel];
    [window setBackgroundColor:[NSColor blackColor]];
    [window setOpaque:YES];
    [window setIgnoresMouseEvents:YES];
    [window makeKeyAndOrderFront:nil];
    
    setWallpaper(path);
    
    clock_t start = clock();
    
    while (1) {
        double elapsed = (double)(clock() - start) / CLOCKS_PER_SEC;
        double progress = elapsed / duration;
        
        if (progress >= 1.0) {
            [window close];
            break;
        }
        
        double alpha = 1.0 - progress;
        [window setAlphaValue:alpha];
        usleep(16666);
    }
    
    [window release];
    [pool drain];
}

void animateGrow(const char *path, double duration) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSScreen *mainScreen = [NSScreen mainScreen];
    NSRect screenFrame = [mainScreen frame];
    
    setWallpaper(path);
    
    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSBorderlessWindowMask
        backing:NSBackingStoreBuffered
        defer:NO];
    
    [window setLevel:NSScreenSaverWindowLevel];
    [window setBackgroundColor:[NSColor blackColor]];
    [window setOpaque:YES];
    [window setIgnoresMouseEvents:YES];
    [window makeKeyAndOrderFront:nil];
    
    double centerX = NSMidX(screenFrame);
    double centerY = NSMidY(screenFrame);
    
    clock_t start = clock();
    
    while (1) {
        double elapsed = (double)(clock() - start) / CLOCKS_PER_SEC;
        double progress = elapsed / duration;
        
        if (progress >= 1.0) {
            [window close];
            break;
        }
        
        double eased = 1.0 - (progress * progress * progress);
        double scale = eased;
        double newWidth = screenFrame.size.width * scale;
        double newHeight = screenFrame.size.height * scale;
        double newX = centerX - newWidth / 2;
        double newY = centerY - newHeight / 2;
        
        NSRect newFrame = NSMakeRect(newX, newY, newWidth, newHeight);
        [window setFrame:newFrame display:YES];
        
        usleep(16666);
    }
    
    [window release];
    [pool drain];
}

void animateRipple(const char *path, double duration) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    setWallpaper(path);
    
    NSScreen *mainScreen = [NSScreen mainScreen];
    NSRect screenFrame = [mainScreen frame];
    
    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSBorderlessWindowMask
        backing:NSBackingStoreBuffered
        defer:NO];
    
    [window setLevel:NSScreenSaverWindowLevel];
    [window setBackgroundColor:[NSColor blackColor]];
    [window setOpaque:YES];
    [window setIgnoresMouseEvents: YES];
    [window makeKeyAndOrderFront:nil];
    
    clock_t start = clock();
    
    while (1) {
        double elapsed = (double)(clock() - start) / CLOCKS_PER_SEC;
        double progress = elapsed / duration;
        
        if (progress >= 1.0) {
            [window close];
            break;
        }
        
        double alpha = 1.0 - progress;
        [window setAlphaValue:alpha];
        usleep(16666);
    }
    
    [window release];
    [pool drain];
}

int main(int argc, const char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: wallpaper_animate <image_path> [wave|fade|grow|liquid|spiral|fold]\n");
        return EXIT_FAILURE;
    }
    
    const char *imagePath = argv[1];
    const char *transitionStr = argc > 2 ? argv[2] : "wave";
    
    if (access(imagePath, F_OK) == -1) {
        fprintf(stderr, "Error: File not found: %s\n", imagePath);
        return EXIT_FAILURE;
    }
    
    TransitionType transition = parseTransition(transitionStr);
    double duration = getDuration(transition);
    
    switch (transition) {
        case TRANSITION_FADE:
            animateFade(imagePath, duration);
            break;
        case TRANSITION_GROW:
            animateGrow(imagePath, duration);
            break;
        default:
            animateRipple(imagePath, duration);
            break;
    }
    
    sleep(1);
    return EXIT_SUCCESS;
}