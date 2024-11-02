name = "Triple Screen 5760x1080 1.04";
Description = "Triple Screen 5760x1080 1.04";

Viewports = {
    Left = {
        x = 0,
        y = 0,
        width = 1920,
        height = 1080,
        aspect = 1920 / 1080,
        viewDx = -1.04,
        viewDy = 0,
    },
    Center = {
        x = 1920,
        y = 0,
        width = 1920,
        height = 1080,
        aspect = 1920 / 1080,
        viewDx = 0,
        viewDy = 0,
    },
    Right = {
        x = 3840,
        y = 0,
        width = 1920,
        height = 1080,
        aspect = 1920 / 1080,
        viewDx = 1.04,
        viewDy = 0,
    }
}

UIMainView = Viewports.Center
GU_MAIN_VIEWPORT = Viewports.Center
