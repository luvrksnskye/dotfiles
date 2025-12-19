/*
 * ╔═══════════════════════════════════════════════════════════════════╗
 * ║         🌙 Skye's Animation Helper for SketchyBar 🌙              ║
 * ║                                                                   ║
 * ║  A lightweight C helper that provides:                            ║
 * ║  • Smooth 60fps color transitions                                 ║
 * ║  • Media detection with YouTube support                           ║
 * ║  • Screen recording compatible animations                         ║
 * ║  • Custom animation curves (dreamy, spring, bounce)               ║
 * ║                                                                   ║
 * ║  Compile with:                                                    ║
 * ║  clang -O2 -o skye_animator skye_animator.c                       ║
 * ║                                                                   ║
 * ║              ✨ Made with love for Skye ✨                         ║
 * ╚═══════════════════════════════════════════════════════════════════╝
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <math.h>
#include <time.h>
#include <pthread.h>
#include <signal.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

/* ═══════════════════════════════════════════════════════════════════════
 *                         CONFIGURATION
 * ═══════════════════════════════════════════════════════════════════════ */

#define SKETCHYBAR_PATH "/opt/homebrew/bin/sketchybar"
#define NOWPLAYING_PATH "/opt/homebrew/bin/nowplaying-cli"
#define MAX_CMD_LEN 1024
#define MAX_TITLE_LEN 256
#define POLL_INTERVAL_US 2000000  /* 2 seconds in microseconds */
#define ANIMATION_FPS 60

/* Global running flag for signal handling */
volatile int running = 1;

/* ═══════════════════════════════════════════════════════════════════════
 *                         ANIMATION CURVES
 * ═══════════════════════════════════════════════════════════════════════ */

typedef enum {
    CURVE_LINEAR,
    CURVE_EASE_IN,
    CURVE_EASE_OUT,
    CURVE_EASE_IN_OUT,
    CURVE_SPRING,
    CURVE_BOUNCE,
    CURVE_ELASTIC,
    CURVE_DREAMY      /* Skye's custom curve ✨ */
} AnimationCurve;

double apply_curve(double t, AnimationCurve curve) {
    double c4, c5, n1, d1;
    
    switch (curve) {
        case CURVE_LINEAR:
            return t;
            
        case CURVE_EASE_IN:
            return t * t * t;
            
        case CURVE_EASE_OUT:
            return 1.0 - pow(1.0 - t, 3.0);
            
        case CURVE_EASE_IN_OUT:
            return t < 0.5 
                ? 4.0 * t * t * t 
                : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
            
        case CURVE_SPRING:
            c4 = (2.0 * M_PI) / 3.0;
            if (t == 0) return 0;
            if (t == 1) return 1;
            return pow(2.0, -10.0 * t) * sin((t * 10.0 - 0.75) * c4) + 1.0;
            
        case CURVE_BOUNCE:
            n1 = 7.5625;
            d1 = 2.75;
            if (t < 1.0 / d1) {
                return n1 * t * t;
            } else if (t < 2.0 / d1) {
                t -= 1.5 / d1;
                return n1 * t * t + 0.75;
            } else if (t < 2.5 / d1) {
                t -= 2.25 / d1;
                return n1 * t * t + 0.9375;
            } else {
                t -= 2.625 / d1;
                return n1 * t * t + 0.984375;
            }
            
        case CURVE_ELASTIC:
            c5 = (2.0 * M_PI) / 4.5;
            if (t == 0) return 0;
            if (t == 1) return 1;
            if (t < 0.5) {
                return -(pow(2.0, 20.0 * t - 10.0) * sin((20.0 * t - 11.125) * c5)) / 2.0;
            }
            return (pow(2.0, -20.0 * t + 10.0) * sin((20.0 * t - 11.125) * c5)) / 2.0 + 1.0;
            
        case CURVE_DREAMY: {
            /* Smooth dreamy curve - soft and gentle like moonlight 🌙 */
            double smoothed = sin(t * M_PI / 2.0);
            double eased = t < 0.5 
                ? 2.0 * t * t 
                : 1.0 - pow(-2.0 * t + 2.0, 2.0) / 2.0;
            return (smoothed + eased) / 2.0;
        }
            
        default:
            return t;
    }
}

/* ═══════════════════════════════════════════════════════════════════════
 *                         COLOR UTILITIES
 * ═══════════════════════════════════════════════════════════════════════ */

typedef struct {
    int a, r, g, b;
} Color;

/* Parse 0xAARRGGBB format */
Color parse_color(const char *hex) {
    Color c = {0, 0, 0, 0};
    unsigned int val = 0;
    
    if (hex[0] == '0' && hex[1] == 'x') {
        sscanf(hex + 2, "%x", &val);
    } else if (hex[0] == '#') {
        sscanf(hex + 1, "%x", &val);
    }
    
    c.a = (val >> 24) & 0xFF;
    c.r = (val >> 16) & 0xFF;
    c.g = (val >> 8) & 0xFF;
    c.b = val & 0xFF;
    
    return c;
}

/* Interpolate between two colors */
void interpolate_color(const char *from, const char *to, double progress, char *result) {
    Color c1 = parse_color(from);
    Color c2 = parse_color(to);
    
    int a = (int)(c1.a + (c2.a - c1.a) * progress);
    int r = (int)(c1.r + (c2.r - c1.r) * progress);
    int g = (int)(c1.g + (c2.g - c1.g) * progress);
    int b = (int)(c1.b + (c2.b - c1.b) * progress);
    
    sprintf(result, "0x%02x%02x%02x%02x", a, r, g, b);
}

/* ═══════════════════════════════════════════════════════════════════════
 *                      SKETCHYBAR COMMUNICATION
 * ═══════════════════════════════════════════════════════════════════════ */

void sketchybar_exec(const char *args) {
    char cmd[MAX_CMD_LEN];
    snprintf(cmd, sizeof(cmd), "%s %s >/dev/null 2>&1", SKETCHYBAR_PATH, args);
    system(cmd);
}

void sketchybar_set(const char *item, const char *property, const char *value) {
    char cmd[MAX_CMD_LEN];
    snprintf(cmd, sizeof(cmd), "--set %s %s=%s", item, property, value);
    sketchybar_exec(cmd);
}

void sketchybar_animate(const char *item, const char *property, const char *value) {
    char cmd[MAX_CMD_LEN];
    snprintf(cmd, sizeof(cmd), "--animate tanh 15 --set %s %s=%s", item, property, value);
    sketchybar_exec(cmd);
}

/* ═══════════════════════════════════════════════════════════════════════
 *                         ANIMATION ENGINE
 * ═══════════════════════════════════════════════════════════════════════ */

typedef struct {
    char item[64];
    char property[64];
    char from[32];
    char to[32];
    double duration;
    AnimationCurve curve;
} AnimationJob;

void* animate_thread(void *arg) {
    AnimationJob *job = (AnimationJob *)arg;
    
    int total_frames = (int)(job->duration * ANIMATION_FPS);
    int frame_delay_us = 1000000 / ANIMATION_FPS;
    
    for (int frame = 0; frame <= total_frames; frame++) {
        double progress = (double)frame / (double)total_frames;
        double eased = apply_curve(progress, job->curve);
        
        char value[32];
        
        /* Check if it's a color */
        if (job->from[0] == '0' && job->from[1] == 'x') {
            interpolate_color(job->from, job->to, eased, value);
        } else {
            /* Numeric interpolation */
            double from_num = atof(job->from);
            double to_num = atof(job->to);
            double interpolated = from_num + (to_num - from_num) * eased;
            snprintf(value, sizeof(value), "%.2f", interpolated);
        }
        
        sketchybar_set(job->item, job->property, value);
        usleep(frame_delay_us);
    }
    
    free(job);
    return NULL;
}

void animate(const char *item, const char *property, 
             const char *from, const char *to,
             double duration, AnimationCurve curve) {
    
    AnimationJob *job = malloc(sizeof(AnimationJob));
    strncpy(job->item, item, sizeof(job->item) - 1);
    strncpy(job->property, property, sizeof(job->property) - 1);
    strncpy(job->from, from, sizeof(job->from) - 1);
    strncpy(job->to, to, sizeof(job->to) - 1);
    job->duration = duration;
    job->curve = curve;
    
    pthread_t thread;
    pthread_create(&thread, NULL, animate_thread, job);
    pthread_detach(thread);
}

/* Pulse animation */
void pulse(const char *item, const char *color, int times) {
    const char *original = "0x99313244";  /* Default ITEM_BG */
    
    for (int i = 0; i < times; i++) {
        animate(item, "background.color", original, color, 0.2, CURVE_EASE_OUT);
        usleep(200000);
        animate(item, "background.color", color, original, 0.2, CURVE_EASE_IN);
        usleep(200000);
    }
}

/* Bounce animation */
void bounce(const char *item) {
    char cmd[MAX_CMD_LEN];
    snprintf(cmd, sizeof(cmd), "--animate elastic 8 --set %s icon.padding_left=10 icon.padding_right=10", item);
    sketchybar_exec(cmd);
    
    usleep(150000);
    
    snprintf(cmd, sizeof(cmd), "--animate elastic 8 --set %s icon.padding_left=6 icon.padding_right=6", item);
    sketchybar_exec(cmd);
}

/* Glow effect */
void glow(const char *item, const char *color) {
    animate(item, "background.border_color", "0x00000000", color, 0.3, CURVE_EASE_OUT);
    sketchybar_set(item, "background.border_width", "2");
}

void unglow(const char *item) {
    sketchybar_set(item, "background.border_width", "0");
}

/* ═══════════════════════════════════════════════════════════════════════
 *                         MEDIA DETECTION
 * ═══════════════════════════════════════════════════════════════════════ */

typedef struct {
    char title[MAX_TITLE_LEN];
    char artist[MAX_TITLE_LEN];
    char source[32];
    int is_playing;
} MediaInfo;

/* Get current media info using nowplaying-cli */
int get_media_info(MediaInfo *info) {
    FILE *fp;
    char cmd[MAX_CMD_LEN];
    char line[MAX_TITLE_LEN];
    
    memset(info, 0, sizeof(MediaInfo));
    
    /* Get title */
    snprintf(cmd, sizeof(cmd), "%s get title 2>/dev/null", NOWPLAYING_PATH);
    fp = popen(cmd, "r");
    if (fp) {
        if (fgets(line, sizeof(line), fp)) {
            line[strcspn(line, "\n")] = 0;
            if (strcmp(line, "null") != 0 && strlen(line) > 0) {
                strncpy(info->title, line, sizeof(info->title) - 1);
            }
        }
        pclose(fp);
    }
    
    if (strlen(info->title) == 0) {
        return 0;  /* No media playing */
    }
    
    /* Get artist */
    snprintf(cmd, sizeof(cmd), "%s get artist 2>/dev/null", NOWPLAYING_PATH);
    fp = popen(cmd, "r");
    if (fp) {
        if (fgets(line, sizeof(line), fp)) {
            line[strcspn(line, "\n")] = 0;
            if (strcmp(line, "null") != 0) {
                strncpy(info->artist, line, sizeof(info->artist) - 1);
            }
        }
        pclose(fp);
    }
    
    /* Get playback rate */
    snprintf(cmd, sizeof(cmd), "%s get playbackRate 2>/dev/null", NOWPLAYING_PATH);
    fp = popen(cmd, "r");
    if (fp) {
        if (fgets(line, sizeof(line), fp)) {
            info->is_playing = (line[0] == '1');
        }
        pclose(fp);
    }
    
    /* Get bundle identifier to determine source */
    snprintf(cmd, sizeof(cmd), "%s get clientBundleIdentifier 2>/dev/null", NOWPLAYING_PATH);
    fp = popen(cmd, "r");
    if (fp) {
        if (fgets(line, sizeof(line), fp)) {
            line[strcspn(line, "\n")] = 0;
            
            /* Convert to lowercase for comparison */
            for (int i = 0; line[i]; i++) {
                if (line[i] >= 'A' && line[i] <= 'Z') {
                    line[i] = line[i] + 32;
                }
            }
            
            /* Detect source */
            if (strstr(line, "spotify")) {
                strcpy(info->source, "spotify");
            } else if (strstr(line, "music") || strstr(line, "itunes")) {
                strcpy(info->source, "apple");
            } else if (strstr(line, "chrome") || strstr(line, "safari") ||
                       strstr(line, "firefox") || strstr(line, "arc") ||
                       strstr(line, "brave") || strstr(line, "edge") ||
                       strstr(line, "opera") || strstr(line, "vivaldi")) {
                /* Check if likely YouTube (no artist usually means YouTube) */
                if (strlen(info->artist) == 0) {
                    strcpy(info->source, "youtube");
                } else {
                    strcpy(info->source, "browser");
                }
            } else {
                strcpy(info->source, "media");
            }
        }
        pclose(fp);
    }
    
    return 1;
}

/* ═══════════════════════════════════════════════════════════════════════
 *                         MEDIA DISPLAY
 * ═══════════════════════════════════════════════════════════════════════ */

static char last_title[MAX_TITLE_LEN] = "";

void update_media_display(void) {
    MediaInfo info;
    char cmd[MAX_CMD_LEN];
    char display[MAX_TITLE_LEN];
    const char *icon;
    const char *color;
    
    if (!get_media_info(&info)) {
        /* Nothing playing */
        if (strlen(last_title) > 0) {
            last_title[0] = '\0';
            sketchybar_exec("--set music icon=󰎆 icon.color=0xff6c7086 label=\"Not Playing\" label.color=0xffa6adc8");
        }
        return;
    }
    
    /* Check if title changed */
    if (strcmp(info.title, last_title) == 0) {
        return;  /* No change */
    }
    strncpy(last_title, info.title, sizeof(last_title) - 1);
    
    /* Determine icon and color based on source */
    if (strcmp(info.source, "spotify") == 0) {
        icon = "󰓇";
        color = info.is_playing ? "0xffa6e3a1" : "0xff6c7086";
    } else if (strcmp(info.source, "apple") == 0) {
        icon = "󰎆";
        color = info.is_playing ? "0xfff5c2e7" : "0xff6c7086";
    } else if (strcmp(info.source, "youtube") == 0) {
        icon = "";
        color = info.is_playing ? "0xfff38ba8" : "0xff6c7086";
    } else if (strcmp(info.source, "browser") == 0) {
        icon = "󰖟";
        color = info.is_playing ? "0xff89dceb" : "0xff6c7086";
    } else {
        icon = info.is_playing ? "󰐊" : "󰏤";
        color = info.is_playing ? "0xffa6e3a1" : "0xff6c7086";
    }
    
    /* Build display string */
    if (strlen(info.artist) > 0) {
        snprintf(display, sizeof(display), "%s • %s", info.artist, info.title);
    } else {
        strncpy(display, info.title, sizeof(display) - 1);
    }
    
    /* Truncate if too long */
    if (strlen(display) > 45) {
        display[42] = '.';
        display[43] = '.';
        display[44] = '.';
        display[45] = '\0';
    }
    
    /* Escape quotes for shell */
    char escaped[MAX_TITLE_LEN * 2];
    int j = 0;
    for (int i = 0; display[i] && j < sizeof(escaped) - 2; i++) {
        if (display[i] == '"' || display[i] == '`' || display[i] == '$') {
            escaped[j++] = '\\';
        }
        escaped[j++] = display[i];
    }
    escaped[j] = '\0';
    
    /* Update display with animation */
    snprintf(cmd, sizeof(cmd), 
             "--animate tanh 15 --set music icon=\"%s\" icon.color=\"%s\" label=\"%s\" label.color=0xffcdd6f4",
             icon, color, escaped);
    sketchybar_exec(cmd);
    
    /* Bounce effect on new track */
    if (info.is_playing) {
        bounce("music");
    }
}

/* ═══════════════════════════════════════════════════════════════════════
 *                      COMMAND HANDLER
 * ═══════════════════════════════════════════════════════════════════════ */

void handle_command(const char *command) {
    char cmd[MAX_CMD_LEN];
    char arg1[64], arg2[64], arg3[64], arg4[64];
    
    /* Parse command */
    int n = sscanf(command, "%63s %63s %63s %63s", cmd, arg1, arg2, arg3);
    
    if (strcmp(cmd, "pulse") == 0 && n >= 3) {
        int times = (n >= 4) ? atoi(arg3) : 3;
        pulse(arg1, arg2, times);
    }
    else if (strcmp(cmd, "bounce") == 0 && n >= 2) {
        bounce(arg1);
    }
    else if (strcmp(cmd, "glow") == 0 && n >= 3) {
        glow(arg1, arg2);
    }
    else if (strcmp(cmd, "unglow") == 0 && n >= 2) {
        unglow(arg1);
    }
    else if (strcmp(cmd, "animate") == 0 && n >= 4) {
        /* animate <item> <property> <from> <to> [duration] [curve] */
        sscanf(command, "%*s %63s %63s %63s %63s", arg1, arg2, arg3, arg4);
        animate(arg1, arg2, arg3, arg4, 0.3, CURVE_DREAMY);
    }
    else if (strcmp(cmd, "update") == 0) {
        update_media_display();
    }
}

/* ═══════════════════════════════════════════════════════════════════════
 *                      MEDIA POLLING THREAD
 * ═══════════════════════════════════════════════════════════════════════ */

void* media_poll_thread(void *arg) {
    (void)arg;  /* Unused */
    
    while (running) {
        update_media_display();
        usleep(POLL_INTERVAL_US);
    }
    
    return NULL;
}

/* ═══════════════════════════════════════════════════════════════════════
 *                              MAIN
 * ═══════════════════════════════════════════════════════════════════════ */

void signal_handler(int sig) {
    (void)sig;  /* Unused */
    running = 0;
}

int main(int argc, char *argv[]) {
    (void)argc;  /* Unused */
    (void)argv;  /* Unused */
    
    /* Handle signals gracefully */
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    printf("✨ Skye's Animation Helper started!\n");
    printf("🌙 Polling for media changes every 2 seconds...\n");
    printf("💜 Send commands via stdin or use as daemon\n\n");
    
    /* Check if running in daemon mode (no stdin) */
    int daemon_mode = !isatty(STDIN_FILENO);
    
    if (daemon_mode) {
        printf("Running in daemon mode (media polling only)\n");
        
        while (running) {
            update_media_display();
            usleep(POLL_INTERVAL_US);
        }
    } else {
        /* Interactive mode - also poll for media */
        pthread_t poll_thread;
        
        /* Start media polling in background */
        pthread_create(&poll_thread, NULL, media_poll_thread, NULL);
        
        /* Read commands from stdin */
        char line[MAX_CMD_LEN];
        while (running && fgets(line, sizeof(line), stdin)) {
            line[strcspn(line, "\n")] = 0;
            if (strlen(line) > 0) {
                handle_command(line);
            }
        }
        
        running = 0;
        pthread_join(poll_thread, NULL);
    }
    
    printf("\n✨ Goodbye!\n");
    return 0;
}
