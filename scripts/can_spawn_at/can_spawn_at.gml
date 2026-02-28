/// can_spawn_at(x, y, width, height, check_object) -> bool
/// Returns true if the area is clear of the specified object type
function can_spawn_at(_x, _y, _width, _height, _obj) {
    // Check if there's already an object in this area
    var collision = collision_rectangle(_x, _y, _x + _width, _y + _height, _obj, false, true);
    return (collision == noone);
}

