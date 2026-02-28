/// oConfig - Create Event - EARLY INITIALIZATION (BALANCED START)
/// This runs BEFORE other objects and sets up globals immediately
randomise();

// Initialize globals FIRST before anything else
global.view_w = 768;
global.view_h = 1024;
global.scale = 1.0;
global.offset_x = 0;
global.offset_y = 0;

// Define macros with the initial values
#macro DESIGN_W 768
#macro DESIGN_H 1024

// Dynamic macros – these will update after we calculate actual scaling
#macro WIDTH  global.view_w
#macro HEIGHT global.view_h

// Gameplay constants (BALANCED FOR EASIER START)
#macro FPS                    60
#macro SCROLL_SPEED           2              // WAS 4 - slower enemy descent
#macro BULLET_SPEED           16
#macro FIRE_RATE              18			 //delay between bullets
#macro BASE_SOLDIER_SIZE      24
#macro FORMATION_SPACING      30
#macro Instances_PER_ROW       5
#macro PLAYER_Y               (HEIGHT - 200)
#macro MAX_Instances           20
#macro LANE_WIDTH             (WIDTH / 3)
#macro GOOD_LANE              1
#macro BLOCK_SIZE             60
#macro BLOCK_SPAWN_RATE       120            // WAS 70 - spawn Instances less often
#macro BLOCK_SPEED			  6			 // 3x faster - less time for bullet spam
#macro SPAWN_THRESHOLD        3
#macro BASE_ENEMY_SPAWN_RATE  90             // WAS 25 - spawn Instances much less often
#macro MIN_ENEMY_SPAWN_RATE   60             // WAS 15 - minimum spawn rate slower
#macro Instances_PER_SPAWN      1              // WAS 2 - only spawn 1 enemy at a time
#macro CONTROL_BAR_HEIGHT     120
#macro MOVEMENT_SPEED         12
#macro GAME_OVER_LINE         (HEIGHT - 130)

#macro BG_COLOR       make_color_rgb(20,20,40)
#macro SOLDIER_COLOR  make_color_rgb(0,100,255)
#macro BULLET_COLOR   make_color_rgb(255,255,0)
#macro ENEMY_COLOR    make_color_rgb(200,0,0)
#macro BOSS_COLOR     make_color_rgb(150,0,100)
#macro POS_BLOCK_COLOR make_color_rgb(0,200,0)
#macro NEG_BLOCK_COLOR make_color_rgb(255,150,0)
#macro CONVERTING_COLOR make_color_rgb(255,255,0)


// Power-up globals
global.rapid_fire_active    = false;
global.rapid_fire_timer     = 0;
global.double_damage_active = false;
global.double_damage_timer  = 0;
global.combo                = 0;
global.combo_timer          = 0;

// NOW calculate the actual scaling based on display
var disp_w = display_get_width();
var disp_h = display_get_height();

// Calculate perfect letterbox/pillarbox scaling
var aspect = DESIGN_W / DESIGN_H;
global.scale = (disp_w / disp_h > aspect) ? (disp_h / DESIGN_H) : (disp_w / DESIGN_W);

// Use a percentage of available space to ensure window chrome fits
global.scale = global.scale * 0.85; // Use 85% of calculated scale for safety

// Update the actual view dimensions
global.view_w  = round(DESIGN_W  * global.scale);
global.view_h  = round(DESIGN_H  * global.scale);
global.offset_x = (disp_w - global.view_w)  div 2;
global.offset_y = (disp_h - global.view_h)  div 2;

// ——— VIEW & WINDOW SETUP ———
view_enabled    = true;
view_visible[0] = true;

// Viewport fills the window exactly
view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = global.view_w;
view_hport[0] = global.view_h;

// Camera stays locked to design resolution (768×1024)
camera_set_view_size(view_camera[0], DESIGN_W, DESIGN_H);
camera_set_view_pos(view_camera[0], 0, 0);

// GUI layer matches design resolution
display_set_gui_size(DESIGN_W, DESIGN_H);

// Resize application surface to match viewport
surface_resize(application_surface, global.view_w, global.view_h);

// Set window size and center it
window_set_size(global.view_w, global.view_h);

// Center the window properly
var window_x = (disp_w - global.view_w) div 2;
var window_y = (disp_h - global.view_h) div 2;
window_set_position(window_x, window_y);

// Lock window size (prevents user from breaking scaling)
window_set_min_width(global.view_w);
window_set_max_width(global.view_w);
window_set_min_height(global.view_h);
window_set_max_height(global.view_h);

////show_debug_message("=== VIEWPORT SETUP COMPLETE ===");
////show_debug_message("Display: " + string(disp_w) + "x" + string(disp_h));
////show_debug_message("Design: " + string(DESIGN_W) + "x" + string(DESIGN_H));
////show_debug_message("Scale: " + string(global.scale));
////show_debug_message("Window: " + string(global.view_w) + "x" + string(global.view_h));
////show_debug_message("Position: " + string(window_x) + ", " + string(window_y));

global.MAXSOLDIERS = 49;

