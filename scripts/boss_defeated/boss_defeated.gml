/// boss_defeated()
function boss_defeated() {
    with (oLevelManager) {
        state = 3; // LEVEL_COMPLETE
        level_complete_timer = 120;
    }
}