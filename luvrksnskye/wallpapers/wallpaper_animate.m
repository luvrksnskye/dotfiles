#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include <time.h>

#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

// ═══════════════════════════════════════════════════════════════════════════════
// WALLPAPER ANIMATOR - Enhanced Edition
// Catppuccin Mocha · Feminine Transitions
// ═══════════════════════════════════════════════════════════════════════════════

typedef enum {
    TRANSITION_WAVE,
    TRANSITION_FADE,
    TRANSITION_GROW,
    TRANSITION_LIQUID,
    TRANSITION_SPIRAL,
    TRANSITION_FOLD,
    TRANSITION_SLIDE,
    TRANSITION_BLOOM,
    TRANSITION_GLITCH
} TransitionType;

typedef struct {
    double duration;
    int fps;
    double frameDuration;
} AnimationConfig;

// Run loop helper
static inline void pumpRunLoop(void) {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0001]];
}

// ═══════════════════════════════════════════════════════════════════════════════
// EASING FUNCTIONS - Smooth & Beautiful
// ═══════════════════════════════════════════════════════════════════════════════

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

static inline double easeOutBack(double t) {
    const double c1 = 1.70158;
    const double c3 = c1 + 1.0;
    return 1.0 + c3 * pow(t - 1.0, 3.0) + c1 * pow(t - 1.0, 2.0);
}

static inline double easeOutElastic(double t) {
    if (t == 0 || t == 1) return t;
    return pow(2.0, -10.0 * t) * sin((t * 10.0 - 0.75) * (2.0 * M_PI / 3.0)) + 1.0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════

static TransitionType parseTransition(const char *str) {
    if (!str) return TRANSITION_WAVE;
    if (strcasecmp(str, "fade") == 0) return TRANSITION_FADE;
    if (strcasecmp(str, "grow") == 0) return TRANSITION_GROW;
    if (strcasecmp(str, "liquid") == 0) return TRANSITION_LIQUID;
    if (strcasecmp(str, "spiral") == 0) return TRANSITION_SPIRAL;
    if (strcasecmp(str, "fold") == 0) return TRANSITION_FOLD;
    if (strcasecmp(str, "wave") == 0) return TRANSITION_WAVE;
    if (strcasecmp(str, "slide") == 0) return TRANSITION_SLIDE;
    if (strcasecmp(str, "bloom") == 0) return TRANSITION_BLOOM;
    if (strcasecmp(str, "glitch") == 0) return TRANSITION_GLITCH;
    return TRANSITION_WAVE;
}

static AnimationConfig getAnimationConfig(TransitionType type) {
    AnimationConfig config;
    config.fps = 60;
    config.frameDuration = 1.0 / config.fps;

    switch (type) {
        case TRANSITION_LIQUID:  config.duration = 1.2; break;
        case TRANSITION_FADE:    config.duration = 0.7; break;
        case TRANSITION_GROW:    config.duration = 0.9; break;
        case TRANSITION_WAVE:    config.duration = 0.8; break;
        case TRANSITION_SPIRAL:  config.duration = 1.3; break;
        case TRANSITION_FOLD:    config.duration = 0.9; break;
        case TRANSITION_SLIDE:   config.duration = 0.8; break;
        case TRANSITION_BLOOM:   config.duration = 1.1; break;
        case TRANSITION_GLITCH:  config.duration = 0.6; break;
        default:                 config.duration = 0.8; break;
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

// ═══════════════════════════════════════════════════════════════════════════════
// WAVE TRANSITION - Gentle wave effect
// ═══════════════════════════════════════════════════════════════════════════════

static void animateWave(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    setWallpaper(path);

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
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
        
        // Wave effect with sine
        double wave = sin(progress * M_PI * 3.0) * 0.05 * (1.0 - progress);
        double alpha = (1.0 - easeInOutSine(progress)) + wave;
        alpha = fmax(0.0, fmin(1.0, alpha));

        [window setAlphaValue:alpha];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════════
// FADE TRANSITION - Simple elegant fade
// ═══════════════════════════════════════════════════════════════════════════════

static void animateFade(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
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

// ═══════════════════════════════════════════════════════════════════════════════
// GROW TRANSITION - Expand from center
// ═══════════════════════════════════════════════════════════════════════════════

static void animateGrow(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    setWallpaper(path);

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
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
        double scale = 1.0 - easeOutBack(progress);

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

// ═══════════════════════════════════════════════════════════════════════════════
// LIQUID TRANSITION - Smooth liquid effect
// ═══════════════════════════════════════════════════════════════════════════════

static void animateLiquid(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
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
        double wave = sin(progress * M_PI * 2.5) * 0.06 * (1.0 - progress);
        double liquidProgress = baseEase + wave;
        liquidProgress = fmax(0.0, fmin(1.0, liquidProgress));

        double alpha = 1.0 - easeInOutQuart(progress);
        double scale = 1.0 + (sin(progress * M_PI) * 0.015);

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

// ═══════════════════════════════════════════════════════════════════════════════
// SPIRAL TRANSITION - Spin away
// ═══════════════════════════════════════════════════════════════════════════════

static void animateSpiral(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    setWallpaper(path);

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
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
        double rotation = progress * M_PI * 1.5;
        double scale = 1.0 - (easeInOutCubic(progress) * 0.25);

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

// ═══════════════════════════════════════════════════════════════════════════════
// FOLD TRANSITION - Fold horizontally
// ═══════════════════════════════════════════════════════════════════════════════

static void animateFold(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    setWallpaper(path);

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
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

// ═══════════════════════════════════════════════════════════════════════════════
// SLIDE TRANSITION - Directional slide
// ═══════════════════════════════════════════════════════════════════════════════

static void animateSlide(const char *path, AnimationConfig config, const char *direction) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    setWallpaper(path);

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
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
        double eased = easeOutQuart(progress);

        NSRect newFrame = screenFrame;

        if (strcmp(direction, "left") == 0) {
            newFrame.origin.x = -screenFrame.size.width * eased;
        } else if (strcmp(direction, "right") == 0) {
            newFrame.origin.x = screenFrame.size.width * eased;
        } else if (strcmp(direction, "up") == 0) {
            newFrame.origin.y = screenFrame.size.height * eased;
        } else {
            newFrame.origin.y = -screenFrame.size.height * eased;
        }

        [window setFrame:newFrame display:YES];
        
        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════════
// BLOOM TRANSITION - Soft bloom/glow effect
// ═══════════════════════════════════════════════════════════════════════════════

static void animateBloom(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    // Create white overlay for bloom effect
    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
        backing:NSBackingStoreBuffered
        defer:NO];

    [window setLevel:NSScreenSaverWindowLevel];
    [window setBackgroundColor:[NSColor whiteColor]];
    [window setOpaque:NO];
    [window setIgnoresMouseEvents:YES];
    [window setAlphaValue:0.0];
    [window makeKeyAndOrderFront:nil];
    pumpRunLoop();

    struct timespec start, current;
    clock_gettime(CLOCK_MONOTONIC, &start);

    // Phase 1: Bloom in (white flash)
    double phase1 = config.duration * 0.3;
    double elapsed = 0.0;
    
    while (elapsed < phase1) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        double progress = fmin(elapsed / phase1, 1.0);
        double alpha = easeOutQuart(progress) * 0.9;

        [window setAlphaValue:alpha];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    // Set wallpaper at peak
    setWallpaper(path);
    pumpRunLoop();

    // Phase 2: Bloom out
    double phase2Start = elapsed;
    while (elapsed < config.duration) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        double phaseProgress = (elapsed - phase2Start) / (config.duration - phase2Start);
        phaseProgress = fmin(phaseProgress, 1.0);
        double alpha = 0.9 * (1.0 - easeInOutCubic(phaseProgress));

        [window setAlphaValue:alpha];

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════════
// GLITCH TRANSITION - Digital glitch effect
// ═══════════════════════════════════════════════════════════════════════════════

static void animateGlitch(const char *path, AnimationConfig config) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSScreen *mainScreen = [NSScreen mainScreen];
    if (!mainScreen) { [pool drain]; return; }

    NSRect screenFrame = [mainScreen frame];

    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:screenFrame
        styleMask:NSWindowStyleMaskBorderless
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

    srand((unsigned int)time(NULL));
    int glitchFrames = 8;
    double glitchInterval = config.duration / glitchFrames;
    int lastGlitch = -1;

    double elapsed = 0.0;
    while (elapsed < config.duration) {
        clock_gettime(CLOCK_MONOTONIC, &current);
        elapsed = (current.tv_sec - start.tv_sec) +
                  (current.tv_nsec - start.tv_nsec) / 1e9;

        int currentGlitch = (int)(elapsed / glitchInterval);
        
        if (currentGlitch != lastGlitch) {
            lastGlitch = currentGlitch;
            
            // Random offset for glitch effect
            double offsetX = (rand() % 40 - 20) * (1.0 - elapsed / config.duration);
            double offsetY = (rand() % 20 - 10) * (1.0 - elapsed / config.duration);
            
            NSRect glitchFrame = screenFrame;
            glitchFrame.origin.x += offsetX;
            glitchFrame.origin.y += offsetY;
            [window setFrame:glitchFrame display:YES];
            
            // Random alpha flicker
            double flicker = 0.7 + (rand() % 30) / 100.0;
            [window setAlphaValue:flicker * (1.0 - elapsed / config.duration)];
            
            // Set wallpaper midway through
            if (currentGlitch == glitchFrames / 2) {
                setWallpaper(path);
            }
        }

        pumpRunLoop();
        usleep((useconds_t)(config.frameDuration * 1000000));
    }

    [window close];
    [window release];
    [pool drain];
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN
// ═══════════════════════════════════════════════════════════════════════════════

int main(int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
    [NSApp finishLaunching];
    pumpRunLoop();

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <image_path> [transition] [direction]\n", argv[0]);
        fprintf(stderr, "\nTransitions:\n");
        fprintf(stderr, "  wave    - Gentle wave fade (default)\n");
        fprintf(stderr, "  fade    - Simple elegant fade\n");
        fprintf(stderr, "  grow    - Expand from center\n");
        fprintf(stderr, "  liquid  - Smooth liquid effect\n");
        fprintf(stderr, "  spiral  - Spin away\n");
        fprintf(stderr, "  fold    - Horizontal fold\n");
        fprintf(stderr, "  slide   - Directional slide (left/right/up/down)\n");
        fprintf(stderr, "  bloom   - Soft white bloom\n");
        fprintf(stderr, "  glitch  - Digital glitch\n");
        [pool drain];
        return EXIT_FAILURE;
    }

    const char *imagePath = argv[1];
    const char *transitionStr = (argc > 2) ? argv[2] : "wave";
    const char *direction = (argc > 3) ? argv[3] : "left";

    if (access(imagePath, F_OK) == -1) {
        fprintf(stderr, "Error: File not found: %s\n", imagePath);
        [pool drain];
        return EXIT_FAILURE;
    }

    TransitionType transition = parseTransition(transitionStr);
    AnimationConfig config = getAnimationConfig(transition);

    switch (transition) {
        case TRANSITION_WAVE:    animateWave(imagePath, config); break;
        case TRANSITION_FADE:    animateFade(imagePath, config); break;
        case TRANSITION_GROW:    animateGrow(imagePath, config); break;
        case TRANSITION_LIQUID:  animateLiquid(imagePath, config); break;
        case TRANSITION_SPIRAL:  animateSpiral(imagePath, config); break;
        case TRANSITION_FOLD:    animateFold(imagePath, config); break;
        case TRANSITION_SLIDE:   animateSlide(imagePath, config, direction); break;
        case TRANSITION_BLOOM:   animateBloom(imagePath, config); break;
        case TRANSITION_GLITCH:  animateGlitch(imagePath, config); break;
        default:                 animateWave(imagePath, config); break;
    }

    usleep(50000);

    [pool drain];
    return EXIT_SUCCESS;
}
