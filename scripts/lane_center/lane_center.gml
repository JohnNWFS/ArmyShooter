/// lane_center(lane) -> real
/// Returns the x-coordinate of the center of each lane
function lane_center(lane) {
    var lane_width = DESIGN_W / 3; // Use DESIGN_W (768), not WIDTH (scaled)
    
    switch(lane) {
        case 0: return lane_width / 2;           // Left lane center: 128
        case 1: return DESIGN_W / 2;             // Center lane center: 384
        case 2: return lane_width * 2.5;         // Right lane center: 640
    }
    return 0;
}