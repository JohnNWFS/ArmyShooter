/// oCorruptBlock - Destroy Event

var frames_lived = global.game_timer - birth_time;
log_death_event("CORRUPT_COLLECTED", "corrupt", 1, 60, damage,
                global.game_timer, oLevelManager.wave_count, oLevelManager.level, frames_lived);