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
    
    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, frame.size.width, frame.size.height)];
    [imageView setImage:image];
    [imageView setImageScaling:NSImageScaleProportionallyUpOrDown];
    [imageView setImageAlignment:NSImageAlignCenter];
    [imageView setWantsLayer:YES];
    imageView.layer.contentsGravity = kCAGravityResizeAspectFill;
    
    [window setContentView:imageView];
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
        [contentView setWantsLayer:YES];
        CALayer *layer = [contentView layer];
        layer.masksToBounds = YES;
        
        // Create circular mask - starts at 0 radius
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [NSColor whiteColor].CGColor;
        layer.mask = maskLayer;
        
        [window setAlphaValue:1.0];
        [window makeKeyAndOrderFront:nil];
        pumpRunLoop();
        
        // Calculate max radius to cover entire screen from center
        double centerX = screenFrame.size.width / 2.0;
        double centerY = screenFrame.size.height / 2.0;
        double maxRadius = sqrt(pow(screenFrame.size.width, 2) + pow(screenFrame.size.height, 2)) / 2.0 + 20;
        
        // Animation timing
        double fps = 60.0;
        double frameDuration = 1.0 / fps;
        
        struct timespec start, current;
        clock_gettime(CLOCK_MONOTONIC, &start);
        double elapsed = 0.0;
        
        // Animate circle expanding
        while (elapsed < duration) {
            clock_gettime(CLOCK_MONOTONIC, &current);
            elapsed = (current.tv_sec - start.tv_sec) + (current.tv_nsec - start.tv_nsec) / 1e9;
            
            double progress = fmin(elapsed / duration, 1.0);
            double easedProgress = easeOutQuart(progress);
            double radius = maxRadius * easedProgress;
            
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
        
        // Set actual wallpaper and cleanup
        setWallpaper(path);
        usleep(50000);
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
        
        usleep(50000);
        return EXIT_SUCCESS;
    }
}
