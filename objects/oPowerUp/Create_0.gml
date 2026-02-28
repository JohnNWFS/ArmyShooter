/// oPowerUp - Create Event

type = 0;  // 0=rapid, 1=shield, 2=double
pulse = 0;

/// oPowerUp - Create Event

type = 0;
pulse = 0;

// Set sprite based on type
switch (type) {
    case 0:
        sprite_index = spr_powerup_rapid;
        break;
    case 1:
        sprite_index = spr_powerup_shield;
        break;
    case 2:
        sprite_index = spr_powerup_double;
        break;
}