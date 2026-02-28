/// oViewController - Step Event
/// Handles dynamic window resizing (optional)

// If you want to allow window resizing, uncomment this section
/*
if (window_get_width() != view_wport[0] || window_get_height() != view_hport[0]) {
    var new_width = window_get_width();
    var new_height = window_get_height();
    
    // Update viewport to match new window size
    view_wport[0] = new_width;
    view_hport[0] = new_height;
    
    // Camera still shows the full game resolution
    // The viewport scaling handles fitting it to the window
}
*/
/*
// Keep application surface at consistent size
if (surface_get_width(application_surface) != global.game_width || 
    surface_get_height(application_surface) != global.game_height) {
    surface_resize(application_surface, global.game_width, global.game_height);
}

*/