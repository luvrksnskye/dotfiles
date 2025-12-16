#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include <time.h>

#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

// ═══════════════════════════════════════════════════════════════════════════
// TYPES & CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

typedef enum {
    TRANSITION_WAVE,
    TRANSITION_FADE,
    TRANSITION_GROW,
    TRANSITION_LIQUID,
    TRANSITION_SPIRAL,
    TRANSITION_FOLD
} TransitionType;

typedef struct {
    double duration;
    int fps;
    double frameDuration;
} AnimationConfig;

// Small helper to let AppKit/WindowServer process events even in CLI loops
static inline void pumpRunLoop(void) {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
}

// ═══════════════════════════════════════════════════════════════════════════
// EASING FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════

static inline double easeInOutCubic(double t) {
    return t < 0.5
        ? 4.0 * t * t * t
        : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
}

static inline double easeOutQuart(double t) {
    return 1.0 - pow(1.0 - t, 4.0);
}

static inline double easeInOutQuart(double t) {
    return t < 0.5
        ? 8.0 * t * t * t * t
        : 1.0 - pow(-2.0 * t + 2.0, 4.0) / 2.0;
}

static inline double easeOutExpo(double t) {
    return t >= 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * t);
}

static inline double easeInOutSine(double t) {
    return -(cos(M_PI * t) - 1.0) / 2.0;
}

// ═══════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════

static TransitionType parseTransition(const char *str) {
    if (!str) return TRANSITION_LIQUID;
    if (strcasecmp(str, "fade") == 0) return TRANSITION_FADE;
    if (strcasecmp(str, "grow") == 0) return TRANSITION_GROW;
    if (strcasecmp(str, "liquid") == 0) return TRANSITION_LIQUID;
    if (strcasecmp(str, "spiral") == 0) return TRANSITION_SPIRAL;
    if (strcasecmp(str, "fold") == 0) return TRANSITION_FOLD;
    if (strcasecmp(str, "wave") == 0) return TRANSITION_WAVE;
    return TRANSITION_LIQUID;
}

static AnimationConfig getAnimationConfig(TransitionType type) {
    AnimationConfig config;
    config.fps = 60;
    config.frameDuration = 1.0 / config.fps;

    switch (type) {
        case TRANSITION_LIQUID: config.duration = 1.2; break;
        case TRANSITION_FADE:   config.duration = 0.8; break;
        case TRANSITION_GROW:   config.duration = 1.0; break;
        case TRANSITION_WAVE:   config.duration = 0.9; break;
        case TRANSITION_SPIRAL: config.duration = 1.4; break;
        case TRANSITION_FOLD:   config.duration = 1.0; break;
        default:                config.duration = 1.0; break;
    }

    return config;
}

static int setWallpaper(const char *path) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *imagePath = [NSString stringWithUTF8String:path];
    NSURL *imageURL = [NSURL fileURLWithPath:imagePath];

    NSError *error = nil;
    NSArray *screens = [NSScreen screens];

    for (NSScreen *screen in screens) {
        NSDictionary *screenOptions =
            [[NSWorkspace sharedWorkspace] desktopImageOptionsForScreen:screen];

        [[NSWorkspace sharedWorkspace]
            setDesktopImageURL:imageURL
            forScreen:screen
            options:screenOptions
            error:&error];

        if (error) {
            [pool drain];
            return -1;
        }
    }

    [pool drain];
    return 0;
}

// ═══════════════════════════════════════════════════════════════════════════
// LIQUID TRANSITION
// ═══════════════════════════════════════════════════════════════════════════

static void animateLiquid(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSBorderlessWindowMask
        backing:NSBackingStoreBuffered
        defer:NO];

    [window setLevel:NSScreenSaverWindowLevel];
    [window setBackgroundColor:[NSColor blackColor]];
    [window setOpaque:NO];
    [window setIgnoresMouseEvents:YES];
    [window setHasShadow:NO];
    [window makeKeyAndOrderFront:nil];
    pumpRunLoop();

    setWallpaper(path);

    NSView *contentView = [window contentView];
    [contentView setWantsLayer:YES];
    CALayer *layer = [contentView layer];

    struct timespec start, current;
    clock_gettime(CLOCK_MONOTONIC, &start);

    double elapsed = 0.0;
    while (elapsed < config.duration) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        double progress = fmin(elapsed / config.duration, 1.0);

        double baseEase = easeOutExpo(progress);
        double wave = sin(progress * M_PI * 2.0) * 0.08 * (1.0 - progress);
        double liquidProgress = baseEase + wave;
        liquidProgress = fmax(0.0, fmin(1.0, liquidProgress));

        double alpha = 1.0 - easeInOutQuart(progress);
        double scale = 1.0 + (sin(progress * M_PI) * 0.02);

        [CATransaction begin];
        [CATransaction setDisableActions:YES];

        [window setAlphaValue:alpha];

        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, scale, scale, 1.0);
        layer.transform = transform;

        [CATransaction commit];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window setAlphaValue:0.0];
    pumpRunLoop();

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════
// FADE TRANSITION
// ═══════════════════════════════════════════════════════════════════════════

static void animateFade(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

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
    pumpRunLoop();

    setWallpaper(path);

    struct timespec start, current;
    clock_gettime(CLOCK_MONOTONIC, &start);

    double elapsed = 0.0;
    while (elapsed < config.duration) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        double progress = fmin(elapsed / config.duration, 1.0);
        double alpha = 1.0 - easeInOutCubic(progress);

        [window setAlphaValue:alpha];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════
// GROW TRANSITION
// ═══════════════════════════════════════════════════════════════════════════

static void animateGrow(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

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
    pumpRunLoop();

    double centerX = NSMidX(screenFrame);
    double centerY = NSMidY(screenFrame);

    struct timespec start, current;
    clock_gettime(CLOCK_MONOTONIC, &start);

    double elapsed = 0.0;
    while (elapsed < config.duration) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        double progress = fmin(elapsed / config.duration, 1.0);
        double scale = 1.0 - easeOutQuart(progress);

        double newWidth = screenFrame.size.width * scale;
        double newHeight = screenFrame.size.height * scale;
        double newX = centerX - newWidth / 2.0;
        double newY = centerY - newHeight / 2.0;

        NSRect newFrame = NSMakeRect(newX, newY, newWidth, newHeight);
        [window setFrame:newFrame display:YES];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════
// WAVE TRANSITION
// ═══════════════════════════════════════════════════════════════════════════

static void animateWave(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

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
    pumpRunLoop();

    struct timespec start, current;
    clock_gettime(CLOCK_MONOTONIC, &start);

    double elapsed = 0.0;
    while (elapsed < config.duration) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        double progress = fmin(elapsed / config.duration, 1.0);
        double alpha = 1.0 - easeInOutSine(progress);

        [window setAlphaValue:alpha];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════
// SPIRAL TRANSITION
// ═══════════════════════════════════════════════════════════════════════════

static void animateSpiral(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    setWallpaper(path);

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSBorderlessWindowMask
        backing:NSBackingStoreBuffered
        defer:NO];

    [window setLevel:NSScreenSaverWindowLevel];
    [window setBackgroundColor:[NSColor blackColor]];
    [window setOpaque:NO];
    [window setIgnoresMouseEvents:YES];
    [window makeKeyAndOrderFront:nil];
    pumpRunLoop();

    NSView *contentView = [window contentView];
    [contentView setWantsLayer:YES];
    CALayer *layer = [contentView layer];

    struct timespec start, current;
    clock_gettime(CLOCK_MONOTONIC, &start);

    double elapsed = 0.0;
    while (elapsed < config.duration) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        double progress = fmin(elapsed / config.duration, 1.0);
        double alpha = 1.0 - easeOutQuart(progress);
        double rotation = progress * M_PI * 2.0;
        double scale = 1.0 - (easeInOutCubic(progress) * 0.3);

        [CATransaction begin];
        [CATransaction setDisableActions:YES];

        [window setAlphaValue:alpha];

        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, scale, scale, 1.0);
        transform = CATransform3DRotate(transform, rotation, 0, 0, 1.0);
        layer.transform = transform;

        [CATransaction commit];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════
// FOLD TRANSITION
// ═══════════════════════════════════════════════════════════════════════════

static void animateFold(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

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
    pumpRunLoop();

    struct timespec start, current;
    clock_gettime(CLOCK_MONOTONIC, &start);

    double elapsed = 0.0;
    while (elapsed < config.duration) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        double progress = fmin(elapsed / config.duration, 1.0);
        double scale = 1.0 - easeOutQuart(progress);

        NSRect newFrame = screenFrame;
        newFrame.size.width *= scale;
        [window setFrame:newFrame display:YES];

        double alpha = 1.0 - easeInOutCubic(progress);
        [window setAlphaValue:alpha];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════
// MAIN
// ═══════════════════════════════════════════════════════════════════════════

int main(int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // ✅ IMPORTANT: initialize AppKit for CLI usage (prevents many segfaults)
    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
    [NSApp finishLaunching];
    pumpRunLoop();

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <image_path> [liquid|fade|grow|wave|spiral|fold]\n", argv[0]);
        fprintf(stderr, "\nTransition types:\n");
        fprintf(stderr, "  liquid  - Smooth liquid-like fade with wave effect (default)\n");
        fprintf(stderr, "  fade    - Simple cross-fade\n");
        fprintf(stderr, "  grow    - Grow from center\n");
        fprintf(stderr, "  wave    - Wave-like fade\n");
        fprintf(stderr, "  spiral  - Spiral rotation fade\n");
        fprintf(stderr, "  fold    - Horizontal fold effect\n");
        [pool drain];
        return EXIT_FAILURE;
    }

    const char *imagePath = argv[1];
    const char *transitionStr = (argc > 2) ? argv[2] : "liquid";

    if (access(imagePath, F_OK) == -1) {
        fprintf(stderr, "Error: File not found: %s\n", imagePath);
        [pool drain];
        return EXIT_FAILURE;
    }

    TransitionType transition = parseTransition(transitionStr);
    AnimationConfig config = getAnimationConfig(transition);

    switch (transition) {
        case TRANSITION_LIQUID: animateLiquid(imagePath, config); break;
        case TRANSITION_FADE:   animateFade(imagePath, config); break;
        case TRANSITION_GROW:   animateGrow(imagePath, config); break;
        case TRANSITION_WAVE:   animateWave(imagePath, config); break;
        case TRANSITION_SPIRAL: animateSpiral(imagePath, config); break;
        case TRANSITION_FOLD:   animateFold(imagePath, config); break;
        default:                animateLiquid(imagePath, config); break;
    }

    usleep(100000);

    [pool drain];
    return EXIT_SUCCESS;
}
