#!/usr/bin/env bash

# Optimized brightness control for Eve Spectrum ES07D03
# Uses aggressive caching and optimized ddcutil settings

I2C_BUS="2"
CACHE_FILE="/tmp/brightness_cache"
LOCK_FILE="/tmp/brightness_notification.lock"
APPLY_LOCK="/tmp/brightness_apply.lock"
NOTIFICATION_DELAY=1.5

# Initialize cache if it doesn't exist
if [ ! -f "$CACHE_FILE" ]; then
    # Get initial brightness once
    INITIAL=$(ddcutil --sleep-multiplier 0.01 --bus 2 getvcp 10 2>/dev/null | grep -oP 'current.*?=\s*\K[0-9]+' || echo "50")
    echo "$INITIAL" > "$CACHE_FILE"
fi

# Function to detect available brightness control methods
detect_brightness_method() {
    # Your monitor uses DDC/CI via I2C bus 2
    echo "ddcutil-optimized"
}

# Function to apply brightness change in background with batching
apply_brightness_background() {
    local target_brightness=$1
    
    # Use lock to prevent multiple simultaneous applications
    if [ -f "$APPLY_LOCK" ]; then
        # Update the target in the lock file (batch multiple changes)
        echo "$target_brightness" > "$APPLY_LOCK"
        return
    fi
    
    # Create lock with target brightness
    echo "$target_brightness" > "$APPLY_LOCK"
    
    # Apply changes in background with aggressive optimization
    (
        local last_applied=""
        while [ -f "$APPLY_LOCK" ]; do
            local current_target=$(cat "$APPLY_LOCK" 2>/dev/null)
            
            # Only apply if different from last applied value
            if [ "$current_target" != "$last_applied" ]; then
                # Ultra-aggressive ddcutil settings for Eve Spectrum
                ddcutil --sleep-multiplier 0.01 --bus 2 setvcp 10 "$current_target" 2>/dev/null
                last_applied="$current_target"
            fi
            
            # Very short delay to check for new changes
            sleep 0.05
            
            # If target hasn't changed, we're done
            if [ "$current_target" = "$(cat "$APPLY_LOCK" 2>/dev/null)" ]; then
                sleep 0.1  # Brief settling time
                if [ "$current_target" = "$(cat "$APPLY_LOCK" 2>/dev/null)" ]; then
                    rm -f "$APPLY_LOCK"
                    break
                fi
            fi
        done
    ) &
}

# Function to set brightness (immediate UI feedback, background application)
set_brightness() {
    local brightness=$1
    
    # Update cache immediately for instant UI feedback
    echo "$brightness" > "$CACHE_FILE"
    
    # Apply change in background
    apply_brightness_background "$brightness"
}

# Function to get current brightness (from cache for speed)
get_brightness() {
    cat "$CACHE_FILE" 2>/dev/null || echo "50"
}

# Function to get actual brightness from monitor (slow, only when needed)
get_actual_brightness() {
    ddcutil --sleep-multiplier 0.01 --bus 2 getvcp 10 2>/dev/null | grep -oP 'current.*?=\s*\K[0-9]+' || cat "$CACHE_FILE"
}

# Function to adjust brightness
adjust_brightness() {
    local change=$1
    local current=$(cat "$CACHE_FILE" 2>/dev/null || echo "50")
    local new_value=$((current + change))
    
    # Clamp to valid range
    if [ $new_value -lt 0 ]; then
        new_value=0
    elif [ $new_value -gt 100 ]; then
        new_value=100
    fi
    
    # Update cache immediately for fast UI feedback
    echo "$new_value" > "$CACHE_FILE"
    
    # Apply brightness change
    set_brightness "$new_value"
}

# Main control logic
case "$1" in
    up)
        adjust_brightness 10
        ;;
    down)
        adjust_brightness -10
        ;;
    min)
        echo "10" > "$CACHE_FILE"
        set_brightness 10
        ;;
    max)
        echo "100" > "$CACHE_FILE"
        set_brightness 100
        ;;
    set)
        if [ -n "$2" ]; then
            echo "$2" > "$CACHE_FILE"
            set_brightness "$2"
        else
            echo "Usage: $0 set <value>"
            exit 1
        fi
        ;;
    get)
        get_brightness
        ;;
    actual)
        get_actual_brightness
        ;;
    sync)
        # Sync cache with actual monitor brightness
        ACTUAL=$(get_actual_brightness)
        echo "$ACTUAL" > "$CACHE_FILE"
        echo "Synced: brightness is $ACTUAL"
        ;;
    detect)
        echo "Eve Spectrum ES07D03 detected on I2C bus 2"
        echo "Using optimized DDC/CI with aggressive sleep multiplier"
        ;;
    *)
        echo "Usage: $0 {up|down|min|max|set <value>|get|actual|sync|detect}"
        exit 1
        ;;
esac

# Notification function with proper debouncing
send_notification() {
    local start_time=$(date +%s%3N)  # milliseconds
    
    # Wait for the notification delay
    sleep "$NOTIFICATION_DELAY"
    
    # Check if lock file still exists and hasn't been updated by a newer call
    if [ -f "$LOCK_FILE" ]; then
        local lock_time=$(stat -c %Y "$LOCK_FILE" 2>/dev/null || echo "0")
        local current_time=$(date +%s)
        
        # Only send notification if the lock file is recent (within reasonable time)
        local time_diff=$((current_time - lock_time))
        if [ "$time_diff" -le 1 ]; then
            # Get the current brightness
            local brightness=$(cat "$CACHE_FILE")
            
            # Send notification
            notify-send -e -a "Eve Spectrum" -t 2000 -h int:value:"$brightness" "Eve Spectrum Brightness"
        fi
        
        # Remove lock file
        rm -f "$LOCK_FILE"
    fi
}

# Notification logic with proper debouncing
if [ -f "$LOCK_FILE" ]; then
    # Lock file exists, just update timestamp to reset the timer
    touch "$LOCK_FILE"
else
    # Create lock file
    touch "$LOCK_FILE"
    # Start notification timer
    (send_notification) &
fi
