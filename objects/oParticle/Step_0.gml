x += vx;
y += vy;
vy += 0.3;
lifetime--;
if (lifetime <= 0) instance_destroy();