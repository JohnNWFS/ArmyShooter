/// oNumberBlock - Destroy Event

// Calculate how long this block existed
var frames_lived = global.game_timer - birth_time;

// Determine block type
var block_subtype = value > 0 ? "positive" : "negative";

// Log the collection event
log_death_event("BLOCK_COLLECTED", block_subtype, 1, BLOCK_SIZE, value,
                global.game_timer, oLevelManager.wave_count, oLevelManager.level, frames_lived);