name = "Half Screen";
Description = "Half Screen";

Viewports = {
    Center = {
        x = 0,
        y = 0,
        width = screen.width / 2,
        height = screen.height,
        viewDx = 0,
        viewDy = 0,
        aspect = (screen.width / 2) / screen.height,
    }
}

GUI = {
    x = 0,
    y = 0,
    width = screen.width / 2,
    height = screen.height,
}

UIMainView = GUI
GU_MAIN_VIEWPORT = GUI
