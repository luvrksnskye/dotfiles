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
// WALLPAPER ANIMATOR - Liquid Only
// Circle expanding from center revealing the new wallpaper
// ═══════════════════════════════════════════════════════════════════════════════

static inline void pumpRunLoop(void) {
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
    }
}

// Smooth easing - starts fast, slows down at end
static inline double easeOutQuart(double t) {
    return 1.0 - pow(1.0 - t, 4.0);
}

static int setWallpaper(const char *path) {
    @autoreleasepool {
        NSString *imagePath = [NSString stringWithUTF8String:path];
        NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
        NSError *error = nil;
        NSArray *screens = [NSScreen screens];
        for (NSScreen *screen in screens) {
            NSDictionary *options = @{
                NSWorkspaceDesktopImageScalingKey: @(NSImageScaleProportionallyUpOrDown),
                NSWorkspaceDesktopImageAllowClippingKey: @YES
            };
            [[NSWorkspace sharedWorkspace] setDesktopImageURL:imageURL forScreen:screen options:options error:&error];
            if (error) return -1;
        }
    }
    return 0;
}

static NSImage* loadImage(const char *path) {
    NSString *imagePath = [NSString stringWithUTF8String:path];
    return [[NSImage alloc] initWithContentsOfFile:imagePath];
}

// ═══════════════════════════════════════════════════════════════════════════════
// Create window with image that matches EXACTLY how macOS renders wallpaper
// Uses CALayer directly for precise control over scaling
// ═══════════════════════════════════════════════════════════════════════════════

static NSWindow* createImageWindow(NSImage *image, NSRect frame) {
    NSWindow *window = [[NSWindow alloc]
        initWithContentRect:frame
        styleMask:NSWindowStyleMaskBorderless
        backing:NSBackingStoreBuffered
        defer:NO];
    
    [window setLevel:CGWindowLevelForKey(kCGDesktopIconWindowLevelKey) + 1];
    [window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | 
                                  NSWindowCollectionBehaviorStationary | 
                                  NSWindowCollectionBehaviorIgnoresCycle];
    [window setOpaque:NO];
    [window setBackgroundColor:[NSColor clearColor]];
    [window setIgnoresMouseEvents:YES];
    [window setHasShadow:NO];
    
    // Use a plain NSView with a CALayer for the image
    // This gives us precise control over how the image is scaled
    NSView *containerView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, frame.size.height)];
    [containerView setWantsLayer:YES];
    containerView.layer.backgroundColor = [NSColor clearColor].CGColor;
    
    // Create image layer
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = containerView.bounds;
    imageLayer.contentsGravity = kCAGravityResizeAspectFill;
    imageLayer.contents = image;
    imageLayer.masksToBounds = YES;
    
    // Disable any implicit animations on the layer
    imageLayer.actions = @{
        @"contents": [NSNull null],
        @"bounds": [NSNull null],
        @"position": [NSNull null]
    };
    
    [containerView.layer addSublayer:imageLayer];
    [window setContentView:containerView];
    
    return window;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIQUID - Circle expanding from center
// ═══════════════════════════════════════════════════════════════════════════════

static void animateLiquid(const char *path, double duration) {
    @autoreleasepool {
        NSScreen *mainScreen = [NSScreen mainScreen];
        if (!mainScreen) return;
        
        NSRect screenFrame = [mainScreen frame];
        NSImage *newImage = loadImage(path);
        if (!newImage) {
            setWallpaper(path);
            return;
        }
        
        // Create window with new wallpaper image
        NSWindow *window = createImageWindow(newImage, screenFrame);
        NSView *contentView = [window contentView];
        
        // Get the image layer (first sublayer of contentView's layer)
        CALayer *imageLayer = [[contentView layer] sublayers][0];
        
        // Create circular mask - starts at 0 radius
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [NSColor whiteColor].CGColor;
        
        // Disable implicit animations on mask
        maskLayer.actions = @{
            @"path": [NSNull null],
            @"bounds": [NSNull null],
            @"position": [NSNull null]
        };
        
        imageLayer.mask = maskLayer;
        
        [window setAlphaValue:1.0];
        [window makeKeyAndOrderFront:nil];
        pumpRunLoop();
        
        // Calculate max radius to cover entire screen from center
        double centerX = screenFrame.size.width / 2.0;
        double centerY = screenFrame.size.height / 2.0;
        double maxRadius = sqrt(pow(screenFrame.size.width, 2) + pow(screenFrame.size.height, 2)) / 2.0 + 50;
        
        // Animation timing
        double fps = 60.0;
        double frameDuration = 1.0 / fps;
        
        struct timespec start, current;
        clock_gettime(CLOCK_MONOTONIC, &start);
        double elapsed = 0.0;
        
        // Set wallpaper early (at 80% of animation) to prevent flash
        BOOL wallpaperSet = NO;
        
        // Animate circle expanding
        while (elapsed < duration) {
            clock_gettime(CLOCK_MONOTONIC, &current);
            elapsed = (current.tv_sec - start.tv_sec) + (current.tv_nsec - start.tv_nsec) / 1e9;
            
            double progress = fmin(elapsed / duration, 1.0);
            double easedProgress = easeOutQuart(progress);
            double radius = maxRadius * easedProgress;
            
            // Set wallpaper at 80% progress to ensure no flash
            if (!wallpaperSet && progress >= 0.80) {
                setWallpaper(path);
                wallpaperSet = YES;
                pumpRunLoop();
            }
            
            // Create circle path centered on screen
            CGMutablePathRef circlePath = CGPathCreateMutable();
            CGPathAddEllipseInRect(circlePath, NULL, 
                CGRectMake(centerX - radius, centerY - radius, radius * 2, radius * 2));
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            maskLayer.path = circlePath;
            [CATransaction commit];
            
            CGPathRelease(circlePath);
            pumpRunLoop();
            usleep((useconds_t)(frameDuration * 1000000));
        }
        
        // Ensure wallpaper is set if animation was very short
        if (!wallpaperSet) {
            setWallpaper(path);
            pumpRunLoop();
        }
        
        // Small delay to let wallpaper render before closing window
        usleep(50000); // 50ms
        pumpRunLoop();
        
        // Close window
        [window orderOut:nil];
        [window close];
    }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN
// ═══════════════════════════════════════════════════════════════════════════════

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyProhibited];
        [NSApp finishLaunching];
        pumpRunLoop();
        
        if (argc < 2) {
            fprintf(stderr, "Usage: %s <image_path> [duration]\n", argv[0]);
            fprintf(stderr, "\nAnimates wallpaper change with expanding circle effect.\n");
            fprintf(stderr, "Duration is in seconds (default: 1.2)\n");
            return EXIT_FAILURE;
        }
        
        const char *imagePath = argv[1];
        double duration = (argc > 2) ? atof(argv[2]) : 1.2;
        
        if (duration <= 0) duration = 1.2;
        if (duration > 5.0) duration = 5.0;
        
        if (access(imagePath, F_OK) == -1) {
            fprintf(stderr, "Error: File not found: %s\n", imagePath);
            return EXIT_FAILURE;
        }
        
        animateLiquid(imagePath, duration);
        
        return EXIT_SUCCESS;
    }
}
