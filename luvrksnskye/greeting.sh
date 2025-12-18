#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │                                                                             │
# │     ✧･ﾟ: *✧･ﾟ:*  GREETING DASHBOARD  *:･ﾟ✧*:･ﾟ✧                           │
# │                                                                             │
# │              Time-based Animated Greeting                                   │
# │              Weather • Moon Phase • Activity Report                         │
# │              Caracas, Venezuela 🇻🇪                                          │
# │              Catppuccin Mocha Theme                                         │
# │                                                                             │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# ═══════════════════════════════════════════════════════════════════════════════
# COLORS — Catppuccin Mocha 
# ═══════════════════════════════════════════════════════════════════════════════

R='\033[0m'
B='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'

PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
LAVENDER='\033[38;2;180;190;254m'
RED='\033[38;2;243;139;168m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
BLUE='\033[38;2;137;180;250m'
SAPPHIRE='\033[38;2;116;199;236m'
FLAMINGO='\033[38;2;242;205;205m'
ROSEWATER='\033[38;2;245;224;220m'

TEXT='\033[38;2;205;214;244m'
SUBTEXT1='\033[38;2;186;194;222m'
SUBTEXT0='\033[38;2;166;173;200m'
OVERLAY2='\033[38;2;147;153;178m'
OVERLAY1='\033[38;2;127;132;156m'
OVERLAY0='\033[38;2;108;112;134m'
SURFACE2='\033[38;2;88;91;112m'
SURFACE1='\033[38;2;69;71;90m'
SURFACE0='\033[38;2;49;50;68m'
BASE='\033[38;2;30;30;46m'
MANTLE='\033[38;2;24;24;37m'
CRUST='\033[38;2;17;17;27m'

# ═══════════════════════════════════════════════════════════════════════════════
# NERD FONT ICONS
# ═══════════════════════════════════════════════════════════════════════════════

ICON_SUN=""         # nf-fa-sun_o
ICON_CLOUD=""       # nf-weather-day_sunny_overcast
ICON_SUNSET="󰖝"      # nf-md-weather_sunset
ICON_MOON=""        # nf-fa-moon_o
ICON_STAR=""        # nf-fa-star
ICON_HEART=""       # nf-fa-heart
ICON_COFFEE=""      # nf-fa-coffee
ICON_SPARKLE="󰫢"     # nf-md-shimmer
ICON_TEMP="󰔏"        # nf-md-thermometer
ICON_HUMID="󰖎"       # nf-md-water_percent
ICON_WIND="󰖝"        # nf-md-weather_windy
ICON_RAIN="󰖗"        # nf-md-weather_rainy
ICON_SUNRISE="󰖜"     # nf-md-weather_sunset_up
ICON_SUNSET_2="󰖛"    # nf-md-weather_sunset_down
ICON_LOCATION=""    # nf-fa-map_marker
ICON_CALENDAR=""    # nf-fa-calendar
ICON_CLOCK=""       # nf-fa-clock_o
ICON_MOON_NEW="󰽤"    # nf-md-moon_new
ICON_MOON_WAXC="󰽥"   # nf-md-moon_waxing_crescent
ICON_MOON_FQ="󰽣"     # nf-md-moon_first_quarter
ICON_MOON_WAXG="󰽦"   # nf-md-moon_waxing_gibbous
ICON_MOON_FULL="󰽢"   # nf-md-moon_full
ICON_MOON_WANG="󰽧"   # nf-md-moon_waning_gibbous
ICON_MOON_LQ="󰽡"     # nf-md-moon_last_quarter
ICON_MOON_WANC="󰽨"   # nf-md-moon_waning_crescent
ICON_CHECK="󰄬"       # nf-md-check
ICON_TASKS=""       # nf-fa-tasks
ICON_BOLT="󱐋"        # nf-md-lightning_bolt
ICON_INFO=""        # nf-fa-info_circle
ICON_GLOBE=""       # nf-fa-globe

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

LOCATION="Caracas"
COUNTRY="Venezuela"
TIMEZONE="America/Caracas"
LATITUDE="10.49"
LONGITUDE="-66.88"
USER_NAME="Skye"

# ═══════════════════════════════════════════════════════════════════════════════
# TIME DETECTION
# ═══════════════════════════════════════════════════════════════════════════════

HOUR=$(TZ=$TIMEZONE date +%H)
CURRENT_DATE=$(TZ=$TIMEZONE date "+%A, %B %d, %Y")
CURRENT_TIME=$(TZ=$TIMEZONE date "+%I:%M:%S %p")
WEEK_NUMBER=$(TZ=$TIMEZONE date "+%V")
DAY_OF_YEAR=$(TZ=$TIMEZONE date "+%j")
DAYS_LEFT=$((365 - DAY_OF_YEAR))

get_period() {
    if [ $HOUR -ge 5 ] && [ $HOUR -lt 12 ]; then
        echo "morning"
    elif [ $HOUR -ge 12 ] && [ $HOUR -lt 17 ]; then
        echo "afternoon"
    elif [ $HOUR -ge 17 ] && [ $HOUR -lt 21 ]; then
        echo "evening"
    else
        echo "night"
    fi
}

PERIOD=$(get_period)

# ═══════════════════════════════════════════════════════════════════════════════
# ANIMATION
# ═══════════════════════════════════════════════════════════════════════════════

DELAY=0.012
FAST_DELAY=0.006
VERY_FAST=0.003

animate_line() {
    local text="$1"
    local delay="${2:-$DELAY}"
    echo -e "$text"
    sleep $delay
}

type_text() {
    local text="$1"
    local color="${2:-$TEXT}"
    local delay="${3:-0.02}"
    
    echo -ne "$color"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep $delay
    done
    echo -e "$R"
}

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " ${MAUVE}%c${R}  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# ═══════════════════════════════════════════════════════════════════════════════
# WEATHER DATA (using wttr.in)
# ═══════════════════════════════════════════════════════════════════════════════

fetch_weather() {
    # Try to fetch weather data with timeout
    WEATHER_DATA=$(timeout 10 curl -s "wttr.in/${LOCATION}?format=j1" 2>/dev/null)
    
    if [ -n "$WEATHER_DATA" ] && echo "$WEATHER_DATA" | grep -q "temp_C"; then
        TEMP_C=$(echo "$WEATHER_DATA" | grep -o '"temp_C": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        FEELS_LIKE=$(echo "$WEATHER_DATA" | grep -o '"FeelsLikeC": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        HUMIDITY=$(echo "$WEATHER_DATA" | grep -o '"humidity": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        WIND_KPH=$(echo "$WEATHER_DATA" | grep -o '"windspeedKmph": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        WEATHER_DESC=$(echo "$WEATHER_DATA" | grep -o '"weatherDesc": *\[{"value": *"[^"]*"' | head -1 | sed 's/.*"value": *"//' | sed 's/"$//')
        PRECIP_MM=$(echo "$WEATHER_DATA" | grep -o '"precipMM": *"[^"]*"' | head -1 | grep -o '[0-9.]*')
        UV_INDEX=$(echo "$WEATHER_DATA" | grep -o '"uvIndex": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        VISIBILITY=$(echo "$WEATHER_DATA" | grep -o '"visibility": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        PRESSURE=$(echo "$WEATHER_DATA" | grep -o '"pressure": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        CLOUDCOVER=$(echo "$WEATHER_DATA" | grep -o '"cloudcover": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        
        # Sunrise/Sunset
        SUNRISE=$(echo "$WEATHER_DATA" | grep -o '"sunrise": *"[^"]*"' | head -1 | sed 's/"sunrise": *"//' | sed 's/"$//')
        SUNSET=$(echo "$WEATHER_DATA" | grep -o '"sunset": *"[^"]*"' | head -1 | sed 's/"sunset": *"//' | sed 's/"$//')
        
        # Moon data
        MOON_PHASE=$(echo "$WEATHER_DATA" | grep -o '"moon_phase": *"[^"]*"' | head -1 | sed 's/"moon_phase": *"//' | sed 's/"$//')
        MOON_ILLUM=$(echo "$WEATHER_DATA" | grep -o '"moon_illumination": *"[^"]*"' | head -1 | grep -o '[0-9]*')
        MOONRISE=$(echo "$WEATHER_DATA" | grep -o '"moonrise": *"[^"]*"' | head -1 | sed 's/"moonrise": *"//' | sed 's/"$//')
        MOONSET=$(echo "$WEATHER_DATA" | grep -o '"moonset": *"[^"]*"' | head -1 | sed 's/"moonset": *"//' | sed 's/"$//')
        
        WEATHER_LOADED=true
    else
        # Fallback: Typical Caracas weather data (December averages)
        TEMP_C="25"
        FEELS_LIKE="26"
        HUMIDITY="75"
        WIND_KPH="10"
        WEATHER_DESC="Partly cloudy"
        PRECIP_MM="0.1"
        UV_INDEX="6"
        VISIBILITY="10"
        PRESSURE="1015"
        CLOUDCOVER="40"
        SUNRISE="06:30 AM"
        SUNSET="06:03 PM"
        MOON_PHASE="Waning Crescent"
        MOON_ILLUM="2"
        MOONRISE="05:15 AM"
        MOONSET="04:45 PM"
        WEATHER_LOADED=true
        USING_FALLBACK=true
    fi
}

get_weather_icon() {
    local desc="${1,,}"
    case "$desc" in
        *sunny*|*clear*)
            if [ $HOUR -ge 6 ] && [ $HOUR -lt 19 ]; then
                echo ""
            else
                echo ""
            fi
            ;;
        *partly*cloudy*) echo "" ;;
        *cloudy*|*overcast*) echo "" ;;
        *rain*|*drizzle*) echo "" ;;
        *thunder*|*storm*) echo "" ;;
        *snow*) echo "" ;;
        *fog*|*mist*) echo "" ;;
        *) echo "" ;;
    esac
}

get_moon_icon() {
    local phase="${1,,}"
    case "$phase" in
        *new*moon*) echo "$ICON_MOON_NEW" ;;
        *waxing*crescent*) echo "$ICON_MOON_WAXC" ;;
        *first*quarter*) echo "$ICON_MOON_FQ" ;;
        *waxing*gibbous*) echo "$ICON_MOON_WAXG" ;;
        *full*moon*) echo "$ICON_MOON_FULL" ;;
        *waning*gibbous*) echo "$ICON_MOON_WANG" ;;
        *last*quarter*|*third*quarter*) echo "$ICON_MOON_LQ" ;;
        *waning*crescent*) echo "$ICON_MOON_WANC" ;;
        *) echo "$ICON_MOON" ;;
    esac
}

get_uv_level() {
    local uv=$1
    if [ -z "$uv" ]; then
        echo "N/A"
    elif [ $uv -le 2 ]; then
        echo "${GREEN}Low${R}"
    elif [ $uv -le 5 ]; then
        echo "${YELLOW}Moderate${R}"
    elif [ $uv -le 7 ]; then
        echo "${PEACH}High${R}"
    elif [ $uv -le 10 ]; then
        echo "${RED}Very High${R}"
    else
        echo "${MAUVE}Extreme${R}"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# ACTIVITY REPORT
# ═══════════════════════════════════════════════════════════════════════════════

get_activity_suggestions() {
    local period=$1
    local temp=$2
    local weather="${3,,}"
    
    case "$period" in
        morning)
            if [[ "$weather" == *rain* ]] || [[ "$weather" == *storm* ]]; then
                echo "Morning meditation|Reading with coffee|Indoor yoga"
            else
                echo "Sunrise walk|Outdoor exercise|Breakfast on the terrace"
            fi
            ;;
        afternoon)
            if [ -n "$temp" ] && [ $temp -gt 28 ]; then
                echo "Indoor work session|Swimming pool time|Power nap"
            else
                echo "Productive meetings|Creative project|Downtown stroll"
            fi
            ;;
        evening)
            echo "Dinner with friends|Relaxing reading|Movie night"
            ;;
        night)
            echo "Stargazing|Deep rest|Planning tomorrow"
            ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════════
# PROGRESS BAR FOR YEAR
# ═══════════════════════════════════════════════════════════════════════════════

year_progress() {
    local current_day=$1
    local total_days=365
    local percentage=$((current_day * 100 / total_days))
    local bar_width=30
    local filled=$((percentage * bar_width / 100))
    local empty=$((bar_width - filled))
    
    printf "${SURFACE0}["
    for ((i=0; i<filled; i++)); do printf "${GREEN}━"; done
    for ((i=0; i<empty; i++)); do printf "${SURFACE2}─"; done
    printf "${SURFACE0}]${R} ${SUBTEXT0}${percentage}%%${R}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# DISPLAY
# ═══════════════════════════════════════════════════════════════════════════════

clear
tput civis
trap 'tput cnorm; exit' INT TERM

# Fetch weather data with loading indicator
echo -ne "    ${DIM}${SUBTEXT0}Loading data...${R}"
fetch_weather &
spinner $!
echo -ne "\r                           \r"

echo ""
animate_line "    ${PINK}━━━━${MAUVE}━━━━${LAVENDER}━━━━${BLUE}━━━━${SAPPHIRE}━━━━${TEAL}━━━━${GREEN}━━━━${YELLOW}━━━━${PEACH}━━━━${RED}━━━━${PINK}━━━━${R}" $VERY_FAST
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# GREETING SECTION
# ═══════════════════════════════════════════════════════════════════════════════

case "$PERIOD" in
    morning)
        ICON="$ICON_SUN"
        COLOR="$YELLOW"
        ACCENT="$PEACH"
        GREETING="Good Morning"
        MESSAGE="Let's make today great"
        EXTRA="$ICON_COFFEE Time for coffee"
        ;;
    afternoon)
        ICON="$ICON_CLOUD"
        COLOR="$SKY"
        ACCENT="$TEAL"
        GREETING="Good Afternoon"
        MESSAGE="Keep up the great work"
        EXTRA="$ICON_BOLT Stay energized"
        ;;
    evening)
        ICON="$ICON_SUNSET"
        COLOR="$PEACH"
        ACCENT="$MAUVE"
        GREETING="Good Evening"
        MESSAGE="Time to unwind"
        EXTRA="$ICON_HEART Time for yourself"
        ;;
    night)
        ICON="$ICON_MOON"
        COLOR="$MAUVE"
        ACCENT="$PINK"
        GREETING="Good Night"
        MESSAGE="Sweet dreams"
        EXTRA="$ICON_SPARKLE Rest well"
        ;;
esac

animate_line "    ${MAUVE}╭─────────────────────────────────────────────────────────────────╮${R}" $VERY_FAST
animate_line "    ${MAUVE}│${R}                                                                 ${MAUVE}│${R}" $VERY_FAST
animate_line "    ${MAUVE}│${R}   ${COLOR}${B}${ICON}  ${GREETING}, ${USER_NAME}!${R}                                     ${MAUVE}│${R}" $FAST_DELAY
animate_line "    ${MAUVE}│${R}      ${ACCENT}${MESSAGE}${R}                                        ${MAUVE}│${R}" $FAST_DELAY
animate_line "    ${MAUVE}│${R}                                                                 ${MAUVE}│${R}" $VERY_FAST
animate_line "    ${MAUVE}╰─────────────────────────────────────────────────────────────────╯${R}" $VERY_FAST

echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# DATE & TIME SECTION
# ═══════════════════════════════════════════════════════════════════════════════

animate_line "    ${BLUE}╭───────────────────────────────────────╮${R}" $VERY_FAST
animate_line "    ${BLUE}│${R}  ${ICON_CALENDAR}  ${B}${TEXT}DATE & TIME${R}                         ${BLUE}│${R}" $FAST_DELAY
animate_line "    ${BLUE}├───────────────────────────────────────┤${R}" $VERY_FAST
animate_line "    ${BLUE}│${R}  ${ICON_LOCATION} ${SUBTEXT1}${LOCATION}, ${COUNTRY}${R}                 ${BLUE}│${R}" $FAST_DELAY
animate_line "    ${BLUE}│${R}  ${ICON_CALENDAR} ${TEXT}${CURRENT_DATE}${R}         ${BLUE}│${R}" $FAST_DELAY
animate_line "    ${BLUE}│${R}  ${ICON_CLOCK} ${YELLOW}${B}${CURRENT_TIME}${R}                       ${BLUE}│${R}" $FAST_DELAY
animate_line "    ${BLUE}│${R}                                       ${BLUE}│${R}" $VERY_FAST
animate_line "    ${BLUE}│${R}  ${SUBTEXT0}Week ${WEEK_NUMBER} • Day ${DAY_OF_YEAR}/365${R}              ${BLUE}│${R}" $FAST_DELAY
animate_line "    ${BLUE}│${R}  ${SUBTEXT0}${DAYS_LEFT} days until end of year${R}           ${BLUE}│${R}" $FAST_DELAY
animate_line "    ${BLUE}│${R}  $(year_progress $DAY_OF_YEAR)       ${BLUE}│${R}" $FAST_DELAY
animate_line "    ${BLUE}╰───────────────────────────────────────╯${R}" $VERY_FAST

echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# WEATHER SECTION
# ═══════════════════════════════════════════════════════════════════════════════

if [ "$WEATHER_LOADED" = true ]; then
    WEATHER_ICON=$(get_weather_icon "$WEATHER_DESC")
    UV_LEVEL=$(get_uv_level "$UV_INDEX")
    
    FALLBACK_NOTE=""
    if [ "$USING_FALLBACK" = true ]; then
        FALLBACK_NOTE=" ${DIM}(typical data)${R}"
    fi
    
    animate_line "    ${TEAL}╭───────────────────────────────────────────────────────────────╮${R}" $VERY_FAST
    animate_line "    ${TEAL}│${R}  ${WEATHER_ICON}  ${B}${TEXT}CURRENT WEATHER${R}${FALLBACK_NOTE}                                ${TEAL}│${R}" $FAST_DELAY
    animate_line "    ${TEAL}├───────────────────────────────────────────────────────────────┤${R}" $VERY_FAST
    animate_line "    ${TEAL}│${R}                                                               ${TEAL}│${R}" $VERY_FAST
    animate_line "    ${TEAL}│${R}   ${YELLOW}${B}${TEMP_C}°C${R}  ${DIM}${SUBTEXT0}Feels like: ${FEELS_LIKE}°C${R}                              ${TEAL}│${R}" $FAST_DELAY
    animate_line "    ${TEAL}│${R}   ${SAPPHIRE}${WEATHER_DESC}${R}                                           ${TEAL}│${R}" $FAST_DELAY
    animate_line "    ${TEAL}│${R}                                                               ${TEAL}│${R}" $VERY_FAST
    animate_line "    ${TEAL}├───────────────────────────────────────────────────────────────┤${R}" $VERY_FAST
    animate_line "    ${TEAL}│${R}  ${ICON_HUMID} Humidity   ${TEXT}${HUMIDITY}%${R}       ${ICON_WIND} Wind     ${TEXT}${WIND_KPH} km/h${R}          ${TEAL}│${R}" $FAST_DELAY
    animate_line "    ${TEAL}│${R}  ${ICON_RAIN} Precip.    ${TEXT}${PRECIP_MM} mm${R}       Pressure ${TEXT}${PRESSURE} hPa${R}         ${TEAL}│${R}" $FAST_DELAY
    animate_line "    ${TEAL}│${R}   Clouds     ${TEXT}${CLOUDCOVER}%${R}         Visib.   ${TEXT}${VISIBILITY} km${R}           ${TEAL}│${R}" $FAST_DELAY
    animate_line "    ${TEAL}│${R}   UV Index   ${UV_LEVEL} (${UV_INDEX})                                  ${TEAL}│${R}" $FAST_DELAY
    animate_line "    ${TEAL}│${R}                                                               ${TEAL}│${R}" $VERY_FAST
    animate_line "    ${TEAL}├───────────────────────────────────────────────────────────────┤${R}" $VERY_FAST
    animate_line "    ${TEAL}│${R}  ${ICON_SUNRISE} Sunrise   ${PEACH}${SUNRISE}${R}         ${ICON_SUNSET_2} Sunset     ${PEACH}${SUNSET}${R}        ${TEAL}│${R}" $FAST_DELAY
    animate_line "    ${TEAL}╰───────────────────────────────────────────────────────────────╯${R}" $VERY_FAST
    
    echo ""
    
    # ═══════════════════════════════════════════════════════════════════════════════
    # MOON PHASE SECTION
    # ═══════════════════════════════════════════════════════════════════════════════
    
    MOON_ICON=$(get_moon_icon "$MOON_PHASE")
    
    # Moon phase names (already in English from API)
    MOON_PHASE_EN="$MOON_PHASE"
    
    animate_line "    ${MAUVE}╭───────────────────────────────────────╮${R}" $VERY_FAST
    animate_line "    ${MAUVE}│${R}  ${MOON_ICON}  ${B}${TEXT}MOON PHASE${R}                          ${MAUVE}│${R}" $FAST_DELAY
    animate_line "    ${MAUVE}├───────────────────────────────────────┤${R}" $VERY_FAST
    animate_line "    ${MAUVE}│${R}                                       ${MAUVE}│${R}" $VERY_FAST
    animate_line "    ${MAUVE}│${R}   ${LAVENDER}${B}${MOON_PHASE_EN}${R}                       ${MAUVE}│${R}" $FAST_DELAY
    animate_line "    ${MAUVE}│${R}   ${SUBTEXT0}Illumination: ${TEXT}${MOON_ILLUM}%${R}              ${MAUVE}│${R}" $FAST_DELAY
    animate_line "    ${MAUVE}│${R}                                       ${MAUVE}│${R}" $VERY_FAST
    animate_line "    ${MAUVE}│${R}   ${ICON_MOON} Rises   ${PINK}${MOONRISE}${R}                  ${MAUVE}│${R}" $FAST_DELAY
    animate_line "    ${MAUVE}│${R}   ${ICON_MOON} Sets    ${PINK}${MOONSET}${R}                 ${MAUVE}│${R}" $FAST_DELAY
    animate_line "    ${MAUVE}│${R}                                       ${MAUVE}│${R}" $VERY_FAST
    animate_line "    ${MAUVE}╰───────────────────────────────────────╯${R}" $VERY_FAST
    
else
    animate_line "    ${RED}╭───────────────────────────────────────╮${R}" $VERY_FAST
    animate_line "    ${RED}│${R}  ${ICON_INFO} ${TEXT}Could not load weather data${R}       ${RED}│${R}" $FAST_DELAY
    animate_line "    ${RED}│${R}  ${SUBTEXT0}Check your internet connection${R}       ${RED}│${R}" $FAST_DELAY
    animate_line "    ${RED}╰───────────────────────────────────────╯${R}" $VERY_FAST
fi

echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# ACTIVITY SUGGESTIONS
# ═══════════════════════════════════════════════════════════════════════════════

ACTIVITIES=$(get_activity_suggestions "$PERIOD" "$TEMP_C" "$WEATHER_DESC")
IFS='|' read -ra ACTIVITY_ARRAY <<< "$ACTIVITIES"

animate_line "    ${GREEN}╭───────────────────────────────────────╮${R}" $VERY_FAST
animate_line "    ${GREEN}│${R}  ${ICON_TASKS}  ${B}${TEXT}SUGGESTIONS${R}                        ${GREEN}│${R}" $FAST_DELAY
animate_line "    ${GREEN}├───────────────────────────────────────┤${R}" $VERY_FAST

for activity in "${ACTIVITY_ARRAY[@]}"; do
    animate_line "    ${GREEN}│${R}   ${ICON_CHECK} ${TEXT}${activity}${R}                    ${GREEN}│${R}" $FAST_DELAY
done

animate_line "    ${GREEN}╰───────────────────────────────────────╯${R}" $VERY_FAST

echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# EXTRA MESSAGE
# ═══════════════════════════════════════════════════════════════════════════════

animate_line "    ${DIM}${ACCENT}${EXTRA}${R}" $DELAY

echo ""
animate_line "    ${PINK}━━━━${MAUVE}━━━━${LAVENDER}━━━━${BLUE}━━━━${SAPPHIRE}━━━━${TEAL}━━━━${GREEN}━━━━${YELLOW}━━━━${PEACH}━━━━${RED}━━━━${PINK}━━━━${R}" $VERY_FAST
echo ""

tput cnorm
