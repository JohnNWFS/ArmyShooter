/// oLevelManager - Create Event

level = 1;
state = 1; // 1 = SPAWNING_WAVES, 2 = BOSS_FIGHT, 3 = LEVEL_COMPLETE
wave_count = 0;
current_wave_pattern = get_wave_pattern(level, wave_count);

// Wave tracking
enemies_spawned_this_wave = 0;
spawn_timer = 0;

// Level completion
level_complete_timer = 0;

// Debug
//show_debug_message("=== LEVEL " + string(level) + " STARTED ===");
//show_debug_message("First wave: " + current_wave_pattern.description);

// Lightweight encounter-director memory
lane_spawn_cooldown = [0, 0, 0];
last_spawn_lane = 0;

// Boss support controls
boss_support_timer = 0;
boss_support_interval = 135;
boss_phase = 0;
