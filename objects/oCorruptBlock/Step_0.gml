/// oCorruptBlock - Step Event

// Move downward at block speed
y += BLOCK_SPEED;

// Pulse animation
pulse += 0.1;

// Destroy if off screen
if (y > DESIGN_H + 100) {
    instance_destroy();
}