/// oPlayerFormation - Step Event
/// Handle player movement - DYNAMIC FORMATION BOUNDS (7 per row)

// Safety check - make sure oConfig has initialized
if (!variable_global_exists("view_w") || !variable_global_exists("view_h")) {
    exit;
}

// Movement controls
var move_x = 0;
if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
    move_x = -12;  // MOVEMENT_SPEED
}
if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
    move_x = 12;
}

// Move the formation center
x += move_x;

// Position all soldiers in formation around this point FIRST
var soldier_count = instance_number(oSoldier);
if (soldier_count > 0) {
    var soldiers = [];
    
    // Collect all soldiers into array
    with (oSoldier) {
        array_push(soldiers, id);
    }
    
    // Formation parameters
    var soldiers_per_row = 7;  // CHANGED FROM 5 TO 7
    var spacing = 26;          // FORMATION_SPACING
    var soldier_size = 24;     // BASE_SOLDIER_SIZE
    var row = 0;
    var col = 0;
    
    // Calculate formation bounds BEFORE positioning
    var total_rows = ceil(soldier_count / soldiers_per_row);
    var soldiers_in_last_row = soldier_count % soldiers_per_row;
    if (soldiers_in_last_row == 0) soldiers_in_last_row = soldiers_per_row;
    
    // Calculate the actual leftmost and rightmost positions of soldiers
    var leftmost_soldier_x = 0;
    var rightmost_soldier_x = 0;
    
    if (soldier_count == 1) {
        // Single soldier centered on formation
        leftmost_soldier_x = x - soldier_size/2;
        rightmost_soldier_x = x + soldier_size/2;
    } else {
        // Multiple soldiers - first row determines width
        var soldiers_in_first_row = min(soldier_count, soldiers_per_row);
        
        // Leftmost soldier position
        var leftmost_offset = -((soldiers_in_first_row - 1) / 2) * spacing;
        leftmost_soldier_x = x + leftmost_offset - soldier_size/2;
        
        // Rightmost soldier position
        var rightmost_offset = ((soldiers_in_first_row - 1) / 2) * spacing;
        rightmost_soldier_x = x + rightmost_offset + soldier_size/2;
    }
    
    // Clamp formation center so soldiers stay EXACTLY on screen edges
    if (leftmost_soldier_x < 0) {
        x += (0 - leftmost_soldier_x);  // Shift right
    }
    if (rightmost_soldier_x > DESIGN_W) {
        x -= (rightmost_soldier_x - DESIGN_W);  // Shift left
    }
    
    // Now position soldiers with the clamped x position
    row = 0;
    col = 0;
    
    for (var i = 0; i < soldier_count; i++) {
        var soldier = soldiers[i];
        
        if (soldier_count == 1) {
            // Single soldier: center at formation position
            soldier.x = x - soldier_size/2;
            soldier.y = y;
        } else {
            // Multiple soldiers: arrange in formation
            var offset_x = (col - (soldiers_per_row - 1) / 2) * spacing;
            var offset_y = row * spacing;
            
            soldier.x = x + offset_x - soldier_size/2;
            soldier.y = y + offset_y;
        }
        
        // Move to next position
        col++;
        if (col >= soldiers_per_row) {
            col = 0;
            row++;
        }
    }
}