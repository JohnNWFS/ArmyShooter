/// lane_bounds(lane) -> array [left, right]
/// Returns the pixel boundaries for each lane in a 768-width room
function lane_bounds(lane) {
    var lane_width = DESIGN_W / 3; // Use DESIGN_W (768), not WIDTH (scaled)
    
    switch(lane) {
        case 0: return [0, lane_width];                           // Left lane: 0-256
        case 1: return [lane_width, lane_width * 2];              // Center lane: 256-512
        case 2: return [lane_width * 2, DESIGN_W];                // Right lane: 512-768
    }
    return [0, 0];
}