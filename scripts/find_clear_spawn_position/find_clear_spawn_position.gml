/// find_clear_spawn_position(lane, size, object_to_check, max_attempts) -> array [x, y] or noone
/// Tries to find a clear position to spawn in the given lane
/// Returns [x, y] if found, or noone if no clear spot after max_attempts
function find_clear_spawn_position(_lane, _size, _obj, _max_attempts = 10) {
    var bounds = lane_bounds(_lane);
    var spawn_y = -100; // Start well above screen
    
    repeat(_max_attempts) {
        var spawn_x = irandom_range(bounds[0], bounds[1] - _size);
        
        // Check if this position is clear
        if (can_spawn_at(spawn_x, spawn_y, _size, _size, _obj)) {
            return [spawn_x, spawn_y];
        }
        
        // Try a different y position
        spawn_y -= 20;
    }
    
    // No clear position found
    return noone;
}