name = "Triple Screen 5760x1080";
Description = "Triple Screen 5760x1080";

Viewports = {
    Center = {
        x = 1920,
        y = 0,
        width = 1920,
        height = 1080,
        aspect = 1920 / 1080,
        useAbsoluteFOV = false,
        useAbsoluteAnglesShift = true,
        viewDx = 0,
        viewDy = 0,
    },
    Left = {
        x = 0,
        y = 0,
        width = 1920,
        height = 1080,
        aspect = 1920 / 1080,
        useAbsoluteFOV = false,
        useAbsoluteAnglesShift = true,
        viewDx = 1.12,
        viewDy = 0,
    },
    Right = {
        x = 3840,
        y = 0,
        width = 1920,
        height = 1080,
        aspect = 1920 / 1080,
        useAbsoluteFOV = false,
        useAbsoluteAnglesShift = true,
        viewDx = -1.12,
        viewDy = 0,
    }
}

GUI = {
    x = 1920,
    y = 0,
    width = 1920,
    height = 1080,
}

UIMainView = GUI
GU_MAIN_VIEWPORT = Viewports.Center
