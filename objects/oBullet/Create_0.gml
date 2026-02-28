/// oBullet - Create Event

// Set damage based on power-up
damage = global.double_damage_active ? 2 : 1;

// Trail for visual effect
trail = ds_queue_create();
repeat(5) ds_queue_enqueue(trail, [x, y]);