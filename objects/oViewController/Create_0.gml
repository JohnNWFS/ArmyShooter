/// oViewController - Create Event (FINAL FIX)
/// The key: viewport PORT must match window size, camera VIEW shows logical size
/*
// Define your target game resolution (logical resolution)
global.game_width = 800;
global.game_height = 1200;

// Get the actual display dimensions
var display_width = display_get_width();
var display_height = display_get_height();

// Calculate safe area
var safe_width = display_width * 0.85;
var safe_height = display_height * 0.85;

// Calculate scaling factor
var scale_x = safe_width / global.game_width;
var scale_y = safe_height / global.game_height;
global.scale = min(scale_x, scale_y);
global.scale = min(global.scale, 1.0);

// Calculate window dimensions
var window_width = floor(global.game_width * global.scale);
var window_height = floor(global.game_height * global.scale);

// Set window size
window_set_size(window_width, window_height);

// Center window
var x_pos = floor((display_width - window_width) / 2);
var y_pos = floor((display_height - window_height) / 2);
window_set_position(x_pos, y_pos);

// Enable views
view_enabled = true;
view_visible[0] = true;

// The CAMERA views the logical game area (what to show)
camera_set_view_size(view_camera[0], global.game_width, global.game_height);
camera_set_view_pos(view_camera[0], 0, 0);

// The VIEWPORT PORT is where to draw it (physical window pixels)
// This MUST match the window size EXACTLY
view_wport[0] = window_width;
view_hport[0] = window_height;

// Position in the window (0,0 = top left)
view_xport[0] = 0;
view_yport[0] = 0;

// CRITICAL: Don't resize application surface!
// Let GameMaker handle it automatically based on viewport settings
// surface_resize(application_surface, global.game_width, global.game_height);

// GUI at logical resolution
display_set_gui_size(global.game_width, global.game_height);

//show_debug_message("=== VIEWPORT CONFIGURATION ===");
//show_debug_message("Window: " + string(window_width) + "x" + string(window_height));
//show_debug_message("Camera VIEW (what to show): " + string(global.game_width) + "x" + string(global.game_height));
//show_debug_message("Viewport PORT (where to draw): " + string(view_wport[0]) + "x" + string(view_hport[0]));
//show_debug_message("Scale: " + string(global.scale));

*/