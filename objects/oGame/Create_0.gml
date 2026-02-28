/// oGame - Create Event

// Game state
score = 0;
high_score = 0;
game_over = false;
block_spawn_counter = 0;

// Start with 1 soldier (not 5)
instance_create_layer(0, 0, "Instances", oSoldier);

// Level manager
instance_create_layer(0, 0, "Instances", oLevelManager);

// Global game timer for spawn tracking
global.game_timer = 0;

